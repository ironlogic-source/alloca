import os
from dotenv import load_dotenv
load_dotenv()
import uuid
import re
from typing import Literal
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

try:
    import google.generativeai as genai
    _gemini_available = True
except ImportError:
    _gemini_available = False


GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")

if _gemini_available and GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)

# Relay hop limits by priority
HOP_LIMITS: dict[str, int] = {
    "HIGH":   5,
    "MEDIUM": 2,
    "LOW":    2,
}

HIGH_KEYWORDS = {
    "urgent", "critical", "emergency", "danger", "sos", "help", "fire",
    "flood", "attack", "injured", "dead", "dying", "rescue", "immediate",
}
MEDIUM_KEYWORDS = {
    "need", "require", "request", "shortage", "missing", "lost",
    "supplies", "water", "food", "medical", "shelter", "power", "outage",
}


Priority = Literal["HIGH", "MEDIUM", "LOW"]


class MessageIn(BaseModel):
    """Payload accepted by POST /send."""
    text: str = Field(..., min_length=1, max_length=1000, description="Message content")


class Message(BaseModel):
    """Full message record stored in-memory and returned to clients."""
    id: str            = Field(..., description="Unique message identifier (UUID)")
    text: str          = Field(..., description="Original message text")
    priority: Priority = Field(..., description="Gemini-classified priority level")
    hops: int          = Field(..., description="Number of relay hops simulated so far")
    max_hops: int      = Field(..., description="Maximum allowed hops for this message")


class SummaryResponse(BaseModel):
    """Response shape for GET /summary."""
    total_messages: int
    high: int
    medium: int
    low: int
    summary: str


class StatusResponse(BaseModel):
    """Generic status acknowledgement."""
    status: str
    detail: str

_messages: list[Message] = []


def _fallback_classify(text: str) -> Priority:
    """
    Rule-based classifier used when Gemini is unavailable.

    Tokenises the text and checks against keyword sets.
    HIGH keywords take priority over MEDIUM; defaults to LOW.
    """
    tokens = set(re.findall(r"\b\w+\b", text.lower()))
    if tokens & HIGH_KEYWORDS:
        return "HIGH"
    if tokens & MEDIUM_KEYWORDS:
        return "MEDIUM"
    return "LOW"


def classify_priority(text: str) -> Priority:
    """
    Classify message urgency using Gemini (gemini-1.5-flash).
    Falls back to rule-based classifier if API key is absent or the call fails.

    Returns one of: "HIGH", "MEDIUM", "LOW"
    """
    if _gemini_available and GEMINI_API_KEY:
        try:
            model = genai.GenerativeModel("gemini-1.5-flash")
            prompt = (
                "You are an emergency triage assistant.\n"
                "Classify the urgency of the message below as exactly ONE word: "
                "HIGH, MEDIUM, or LOW.\n"
                "HIGH   = immediate threat to life or safety.\n"
                "MEDIUM = important but not immediately life-threatening.\n"
                "LOW    = informational or routine.\n"
                "Reply with ONLY the single classification word — no punctuation, "
                "no explanation.\n\n"
                f"Message: {text}"
            )
            response = model.generate_content(prompt)
            label = response.text.strip().upper()
            if label in ("HIGH", "MEDIUM", "LOW"):
                return label 
        except Exception:
            pass

    return _fallback_classify(text)


def summarize_messages(messages: list[Message]) -> str:
    """
    Produce a natural-language summary using Gemini when available,
    or a structured plain-text summary locally as fallback.
    """
    if not messages:
        return "No messages in the network."

    if _gemini_available and GEMINI_API_KEY:
        try:
            model = genai.GenerativeModel("gemini-1.5-flash")
            combined = "\n".join(f"[{m.priority}] {m.text}" for m in messages)
            prompt = (
                "You are an emergency operations coordinator.\n"
                "Summarise the following triage messages in 3-5 sentences, "
                "highlighting the most critical issues first.\n\n"
                f"{combined}"
            )
            response = model.generate_content(prompt)
            return response.text.strip()
        except Exception:
            pass

    high   = [m for m in messages if m.priority == "HIGH"]
    medium = [m for m in messages if m.priority == "MEDIUM"]
    low    = [m for m in messages if m.priority == "LOW"]

    lines = [f"Network status: {len(messages)} message(s) in relay."]
    if high:
        lines.append("CRITICAL ({}): {}".format(
            len(high), " | ".join(m.text[:60] for m in high)
        ))
    if medium:
        lines.append("MEDIUM ({}): {}".format(
            len(medium), " | ".join(m.text[:60] for m in medium)
        ))
    if low:
        lines.append(f"LOW ({len(low)}): {len(low)} routine message(s).")
    return " ".join(lines)


def simulate_relay(message: Message) -> Message:
    """
    Advance the hop counter by 1 (up to max_hops) on each GET /messages call,
    simulating message propagation across a decentralised mesh network.
    """
    if message.hops < message.max_hops:
        return message.model_copy(update={"hops": message.hops + 1})
    return message


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Print startup info showing which classifier mode is active."""
    if _gemini_available and GEMINI_API_KEY:
        mode = "Gemini (gemini-1.5-flash)"
    else:
        reason = "package missing" if not _gemini_available else "no API key set"
        mode = f"Rule-based fallback ({reason})"
    print(f"[DRSN] Starting — classifier: {mode}")
    yield
    print("[DRSN] Shutting down.")


app = FastAPI(
    title="Decentralized Resource Sharing Network",
    description=(
        "Emergency communication backend with Gemini-powered triage "
        "and mesh-relay simulation."
    ),
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.post(
    "/send",
    response_model=Message,
    status_code=201,
    summary="Send a new emergency message",
    tags=["Messaging"],
)
async def send_message(payload: MessageIn) -> Message:
    """
    Accept a text message, classify its priority via Gemini (or fallback),
    and store it in the in-memory relay network.
    """
    text = payload.text.strip()
    if not text:
        raise HTTPException(status_code=422, detail="Message text must not be empty.")

    priority: Priority = classify_priority(text)
    max_hops = HOP_LIMITS[priority]

    message = Message(
        id=str(uuid.uuid4()),
        text=text,
        priority=priority,
        hops=0,
        max_hops=max_hops,
    )
    _messages.append(message)
    return message


@app.get(
    "/messages",
    response_model=list[Message],
    summary="Retrieve all messages (triggers relay simulation)",
    tags=["Messaging"],
)
async def get_messages() -> list[Message]:
    """
    Return all stored messages.
    Each call advances the hop counter for every message not yet at max_hops,
    simulating one round of relay propagation.
    """
    for i, msg in enumerate(_messages):
        _messages[i] = simulate_relay(msg)
    return _messages


@app.post(
    "/clear",
    response_model=StatusResponse,
    summary="Clear all messages (demo reset)",
    tags=["Admin"],
)
async def clear_messages() -> StatusResponse:
    """Remove all messages from the in-memory store. Useful for demo resets."""
    count = len(_messages)
    _messages.clear()
    return StatusResponse(
        status="ok",
        detail=f"Cleared {count} message(s) from the network.",
    )


@app.get(
    "/summary",
    response_model=SummaryResponse,
    summary="Gemini-powered summary of all messages",
    tags=["Analytics"],
)
async def get_summary() -> SummaryResponse:
    """
    Return a natural-language summary of the current message queue
    (via Gemini or fallback), plus per-priority counts.
    """
    high   = sum(1 for m in _messages if m.priority == "HIGH")
    medium = sum(1 for m in _messages if m.priority == "MEDIUM")
    low    = sum(1 for m in _messages if m.priority == "LOW")

    return SummaryResponse(
        total_messages=len(_messages),
        high=high,
        medium=medium,
        low=low,
        summary=summarize_messages(_messages),
    )


@app.get(
    "/health",
    response_model=StatusResponse,
    summary="Health check",
    tags=["Admin"],
)
async def health_check() -> StatusResponse:
    """Liveness probe for Flutter and load balancers."""
    classifier = "gemini" if (_gemini_available and GEMINI_API_KEY) else "rule-based"
    return StatusResponse(
        status="ok",
        detail=f"DRSN relay node online | classifier={classifier} | messages={len(_messages)}",
    )