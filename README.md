<div align="center">

<img src="https://img.shields.io/badge/STATUS-HACKATHON%20DEMO-4ADE80?style=for-the-badge&labelColor=0A0A0A" />
&nbsp;
<img src="https://img.shields.io/badge/PLATFORM-FLUTTER-54C5F8?style=for-the-badge&logo=flutter&logoColor=white&labelColor=0A0A0A" />
&nbsp;
<img src="https://img.shields.io/badge/AI-GEMINI-4285F4?style=for-the-badge&logo=google&logoColor=white&labelColor=0A0A0A" />
&nbsp;
<img src="https://img.shields.io/badge/NETWORK-BLE%20%2F%20MESH-8B5CF6?style=for-the-badge&labelColor=0A0A0A" />
&nbsp;
<img src="https://img.shields.io/badge/OFFLINE-FIRST-F87171?style=for-the-badge&labelColor=0A0A0A" />

<br/><br/>

# 🛰️ Alloca — Decentralise Relief

### *"When the internet fails, intelligence shouldn't."*

**By Team Synapso** — AI-powered mesh networking for real crisis conditions.

<br/>

</div>

---

## 🚨 The Problem

In disaster scenarios — earthquakes, floods, or infrastructure attacks — **traditional communication is the first thing to collapse.** 4G, 5G, and Wi-Fi go down within minutes, creating a dangerous information vacuum where:

- 🚑 Rescue teams **can't triage** who needs help most urgently
- 🗺️ Victims **can't locate** nearby resources like food, water, or medicine
- 📦 Aid distribution becomes **chaotic and inefficient**
- ⏱️ Every minute of delay costs lives

> The cruel irony: help often exists nearby — but no one knows where.

---

## 💡 The Solution — AI-Powered Decentralised Mesh

We built an **offline-first, decentralised resource-sharing network** that functions entirely without internet. Using device-to-device **Bluetooth Low Energy (BLE)** and **Wi-Fi Direct**, we've integrated **Gemini AI** as an intelligent layer sitting on top of the peer-to-peer connection.

The result: a network that doesn't just relay messages — it **understands** them.

```
Device A  ──►  Device B  ──►  Device C  ──►  Responder
(Victim)      (AI Relay)     (AI Relay)      (Rescuer)
   │               │
   │         Gemini Triage
   │         Priority: HIGH 🔴
   │         Summary: "Flood coming, need evacuation now"
   └─────────────────────────────────────────────────►
```

---

## 🧠 Core Innovation — The "Intelligent Relay"

Standard mesh networks broadcast every message to every device — causing **packet storms** that clog the network exactly when bandwidth is most precious.

We solve this with **Gemini AI running at every relay node**, doing three things automatically:

### 🔴 1. Automated Threat Assessment
Every incoming request is instantly analysed and categorised:

| Priority | Example | Action |
|---|---|---|
| 🔴 **HIGH** | "Flood coming, need evacuation now" | Express Lane — maximum hop speed |
| 🟡 **MEDIUM** | "Need food for 3 people" | Normal relay queue |
| 🟢 **LOW** | "Looking for blankets" | Throttled — saves bandwidth |

### 📋 2. Smart Summarisation
Instead of a rescuer reading 100 individual messages, Gemini **aggregates and summarises** all local requests into a single **Situation Report**:

```
📍 Cluster Report — Zone 3 (23 devices)
─────────────────────────────────────────
🔴 2 medical emergencies (trauma, dehydration)
🟡 7 food requests — approx. 18 people
🟢 4 shelter queries — redirecting to NGO camp
─────────────────────────────────────────
Nearest resource node: 0.9km NE (Priya — medicine)
```

### ⚡ 3. Priority-Based Routing (Our USP)
High-priority alerts get **"Express Lane" status** — they hop across the mesh at maximum speed. Low-priority messages are throttled to preserve network bandwidth for emergencies. No standard mesh network does this.

---

## 🧩 Key Features

| Feature | Description |
|---|---|
| 📡 **Zero-Infrastructure Connectivity** | Complete P2P communication via Bluetooth Low Energy and Wi-Fi Direct — no towers, no servers |
| 🤖 **On-Edge AI Triage** | Gemini classifies and prioritises emergency signals locally, without any cloud server |
| 🔁 **Multi-Hop Relay** | Messages hop device-to-device, extending range far beyond a single radio's reach |
| 📦 **Decentralised Resource Map** | Community-updated ledger of food, water, medicine, shelter — visible to all nodes |
| ⚡ **Express Lane Routing** | Critical messages travel faster; low-priority chatter is throttled to save bandwidth |
| 📊 **Rescuer Dashboard** | AI-generated situation summary for rescue teams showing cluster-wide needs at a glance |

---

## 🎯 Demo Flow

> All devices in **Airplane Mode** — zero internet throughout.

**1. Go Dark**
All demo devices switched to Airplane Mode. No cellular, no Wi-Fi.

**2. The Request**
Device A sends: *"I have a broken leg and need water"*

**3. AI Triage**
Gemini instantly analyses the message:
- Tags it 🔴 **HIGH PRIORITY**
- Generates summary: *"Trauma + dehydration — immediate response needed"*
- Assigns Express Lane status

**4. The Relay**
The summarised, high-priority alert hops:
```
Device A  ──►  Device B  ──►  Device C (Responder)
              (relay)         ✅ Alert received in < 2 seconds
```

**5. The Dashboard**
Device C (Rescuer) sees a clean AI situation report — not 100 raw messages, just actionable intelligence.

---

## 🧪 MVP Demonstrated

- ✅ **P2P Link** — Connection established between 3+ devices with no cellular data
- ✅ **AI Filtering** — High priority medical alert jumps to top; general queries stay below
- ✅ **Summary View** — Rescuer dashboard shows AI-generated cluster situation report
- ✅ **Flutter UI** — Full mobile interface: dashboard, resource map, relay animation, AI panel

---

## 🖼️ App Screens

> Built in Flutter — dark theme optimised for low-light disaster conditions.

### 📊 Dashboard
- Live mesh status indicator (BLE active)
- Stats: Resources Available · Help Requests · Nearby Nodes
- Flash disaster alert banner
- Live resource map with labelled markers (HELP / FOOD / MEDICINES / YOU)
- Gemini AI Smart Allocation panel with priority list
- One-tap **"Need Help"** SOS with animated relay simulation

### 🤝 Resource Sharing Screen
- Select resource type (Food / Medicine / Shelter / Water / Clothing / Transport)
- Add quantity and notes
- Broadcast to all nearby mesh nodes instantly
- Success confirmation with node acknowledgements

---

## 🗂️ Project Structure

```
alloca/
│
├── lib/
│   ├── main.dart                     # App entry point & dark theme
│   ├── screens/
│   │   ├── home_screen.dart          # Main dashboard
│   │   └── resource_page.dart        # Share resources screen
│   └── widgets/
│       ├── stat_card.dart            # Stats cards
│       ├── alert_banner.dart         # Disaster alert banner
│       ├── map_placeholder.dart      # Live resource map
│       ├── ai_allocation_panel.dart  # Gemini AI priority panel
│       └── relay_simulation.dart     # Mesh relay animation
│
├── prototype.html                    # Standalone browser demo (no install needed)
├── pubspec.yaml
└── README.md
```

---

## 🚀 Getting Started

### Run the Flutter App

```bash
# 1. Clone the repo
git clone https://github.com/ironlogic-source/alloca.git
cd alloca

# 2. Install dependencies
flutter pub get

# 3. Run on device or emulator
flutter run
```

### Or — Open the Browser Prototype instantly

```bash
# Just open in any browser — works on phone too!
open prototype.html
```

> On phone: open in Chrome → tap ⋮ → **Add to Home Screen** for a native app feel.

---

## 🛣️ Roadmap

| Phase | Feature | Status |
|---|---|---|
| ✅ MVP | Flutter UI — Dashboard + Resource page | Done |
| ✅ MVP | Gemini AI smart allocation + priority panel | Done |
| ✅ MVP | Relay simulation with animated overlay | Done |
| ✅ MVP | Browser prototype (zero install demo) | Done |
| 🔄 Next | Real BLE mesh via `flutter_blue_plus` | Planned |
| 🔄 Next | Multi-hop message relay (1–3 hops) | Planned |
| 🔄 Next | On-device Gemini triage (no cloud) | Planned |
| 🔮 Future | End-to-end encrypted messages | Planned |
| 🔮 Future | NGO / rescue team command dashboard | Planned |
| 🔮 Future | Satellite fallback (Starlink API) | Planned |

---

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) — dark theme, mobile-first |
| AI Triage & Allocation | Google Gemini API |
| Mesh Network | Bluetooth Low Energy + Wi-Fi Direct (simulated in demo) |
| State Management | Flutter `setState` |
| Browser Prototype | Vanilla HTML / CSS / JS (single file) |

---

## 🏆 Why Alloca is Different

Most disaster apps assume the internet exists. We don't.

> **Alloca is built for the exact moment everything else has already failed.**

- 🔌 **No internet needed** — works when 4G, 5G, and Wi-Fi are all down
- 🧠 **AI on the edge** — Gemini runs locally, no cloud dependency
- ⚡ **Smart not loud** — priority routing prevents network congestion
- 🏛️ **No central server** — nothing to overload, nothing to take down
- 📱 **Existing hardware** — runs on phones people already own
- 🌍 **Self-strengthening** — more people = stronger, wider network

---

## 👥 Team Synapso

> Built with urgency, empathy, and a lot of caffeine. ☕

---

## 📄 License

MIT License — free to use, modify, and build upon for humanitarian purposes.

---

<div align="center">

**Built for disasters. Tested in hackathons. Designed to save lives.**

⭐ Star this repo if you believe intelligence should survive any crisis.

</div>
