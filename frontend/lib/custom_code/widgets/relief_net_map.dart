// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ============================================================
// ReliefNet — MAP ONLY Widget (Sirf Map — No Extra UI)
// ✅ FlutterFlow Custom Widget Compatible
// ✅ WASM / Web Safe — No TextDirection, No dart:html
// ✅ Define Parameters: width (double), height (double)
// ============================================================

import 'dart:math';
import 'dart:async';
import 'dart:ui' as ui;

// ── NODE TYPE
enum NodeType { you, resource, help, camp }

// ── NODE MODEL
class MapNode {
  final String id;
  final String name;
  final String emoji;
  final String detail;
  final String distance;
  final NodeType type;
  final double x;
  final double y;

  const MapNode({
    required this.id,
    required this.name,
    required this.emoji,
    required this.detail,
    required this.distance,
    required this.type,
    required this.x,
    required this.y,
  });
}

// ── DEMO DATA
const List<MapNode> sampleNodes = [
  MapNode(
      id: 'you',
      name: 'YOU',
      emoji: '📍',
      detail: 'Your location\nVisible to 6 mesh nodes',
      distance: '0.0 km',
      type: NodeType.you,
      x: 0.50,
      y: 0.50),
  MapNode(
      id: 'ramesh',
      name: 'Ramesh',
      emoji: '🍱',
      detail: '100 Food Packets available\nBluetooth Mesh',
      distance: '0.8 km',
      type: NodeType.resource,
      x: 0.27,
      y: 0.33),
  MapNode(
      id: 'priya',
      name: 'Priya',
      emoji: '💊',
      detail: '15 Medicine Kits\nWiFi Direct',
      distance: '1.1 km',
      type: NodeType.resource,
      x: 0.68,
      y: 0.26),
  MapNode(
      id: 'mohan',
      name: 'Mohan ⚠',
      emoji: '🆘',
      detail: 'NEEDS: 50 Food Packets\nFamily of 8 • Critical',
      distance: '1.2 km',
      type: NodeType.help,
      x: 0.18,
      y: 0.65),
  MapNode(
      id: 'sunita',
      name: 'Sunita ⚠',
      emoji: '🆘',
      detail: 'NEEDS: BP Medicine\nElderly • Critical',
      distance: '0.9 km',
      type: NodeType.help,
      x: 0.75,
      y: 0.68),
  MapNode(
      id: 'ngo',
      name: 'NGO Camp',
      emoji: '🏥',
      detail: 'Capacity: 50 people\nFood + Water + Tents',
      distance: '1.3 km',
      type: NodeType.camp,
      x: 0.55,
      y: 0.18),
  MapNode(
      id: 'vikram',
      name: 'Vikram',
      emoji: '🔦',
      detail: '3 Emergency Lights\nBluetooth Mesh',
      distance: '0.5 km',
      type: NodeType.resource,
      x: 0.38,
      y: 0.72),
];

const List<List<String>> meshConnections = [
  ['you', 'ramesh'],
  ['you', 'priya'],
  ['you', 'mohan'],
  ['you', 'sunita'],
  ['you', 'ngo'],
  ['ramesh', 'mohan'],
  ['priya', 'sunita'],
  ['ngo', 'ramesh'],
  ['ngo', 'vikram'],
];

// ── COLORS
const Color kBg = Color(0xFF070D18);
const Color kCard = Color(0xFF111E30);
const Color kBorder = Color(0xFF1C2E48);
const Color kAccent = Color(0xFF00E5FF);
const Color kGreen = Color(0xFF00E676);
const Color kRed = Color(0xFFFF3B3B);
const Color kBlue = Color(0xFF3D8EFF);
const Color kText = Color(0xFFDDE6F5);
const Color kMuted = Color(0xFF5A6E8C);

// ════════════════════════════════════════════════════════════
// MAIN WIDGET
// ════════════════════════════════════════════════════════════

class ReliefNetMap extends StatefulWidget {
  final double width;
  final double height;

  const ReliefNetMap({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<ReliefNetMap> createState() => _ReliefNetMapState();
}

class _ReliefNetMapState extends State<ReliefNetMap>
    with TickerProviderStateMixin {
  late AnimationController _anim;
  late AnimationController _ripple;

  double _zoom = 1.0;
  Offset _pan = Offset.zero;
  String _filter = 'all';
  MapNode? _selectedNode;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _ripple = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _anim.dispose();
    _ripple.dispose();
    super.dispose();
  }

  Color _colorFor(NodeType t) {
    switch (t) {
      case NodeType.you:
        return kAccent;
      case NodeType.resource:
        return kGreen;
      case NodeType.help:
        return kRed;
      case NodeType.camp:
        return kBlue;
    }
  }

  List<MapNode> get _visibleNodes {
    switch (_filter) {
      case 'help':
        return sampleNodes
            .where((n) => n.type == NodeType.help || n.type == NodeType.you)
            .toList();
      case 'resource':
        return sampleNodes.where((n) => n.type != NodeType.help).toList();
      default:
        return sampleNodes;
    }
  }

  void _onTap(Offset pos, Size size) {
    for (final node in _visibleNodes) {
      final nx = size.width / 2 + (node.x - .5) * size.width * _zoom + _pan.dx;
      final ny =
          size.height / 2 + (node.y - .5) * size.height * _zoom + _pan.dy;
      if ((pos - Offset(nx, ny)).distance < 24) {
        setState(() => _selectedNode = node);
        _showSheet(node);
        return;
      }
    }
    setState(() => _selectedNode = null);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Container(
        decoration: BoxDecoration(
          color: kBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // ── Animated Map Canvas
              AnimatedBuilder(
                animation: _anim,
                builder: (_, __) => GestureDetector(
                  onTapUp: (d) => _onTap(
                      d.localPosition, Size(widget.width, widget.height)),
                  onScaleUpdate: (d) => setState(() {
                    _zoom = (_zoom * d.scale).clamp(0.6, 2.5);
                    _pan += d.focalPointDelta;
                  }),
                  child: CustomPaint(
                    painter: ReliefMapPainter(
                      nodes: _visibleNodes,
                      connections: meshConnections,
                      animVal: _anim.value,
                      rippleVal: _ripple.value,
                      zoom: _zoom,
                      pan: _pan,
                      selectedId: _selectedNode?.id,
                    ),
                    child: SizedBox(
                      width: widget.width,
                      height: widget.height,
                    ),
                  ),
                ),
              ),

              // ── TOP LEFT: Live + Scale HUD
              Positioned(
                top: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _hudPill(Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: kGreen,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: kGreen.withOpacity(.7), blurRadius: 5)
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('Live Updates',
                            style: TextStyle(
                                color: Color(0xFFDDE6F5),
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ],
                    )),
                    const SizedBox(height: 6),
                    _hudPill(Text(
                      'Scale: ${_zoom.toStringAsFixed(1)}x',
                      style: const TextStyle(
                          color: kMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    )),
                  ],
                ),
              ),

              // ── TOP RIGHT: Zoom Controls
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  children: [
                    _ctrlBtn(
                        '+',
                        () => setState(
                            () => _zoom = (_zoom + .3).clamp(.6, 2.5))),
                    const SizedBox(height: 6),
                    _ctrlBtn(
                        '−',
                        () => setState(
                            () => _zoom = (_zoom - .3).clamp(.6, 2.5))),
                    const SizedBox(height: 6),
                    _ctrlBtn(
                        '◎',
                        () => setState(() {
                              _zoom = 1.0;
                              _pan = Offset.zero;
                            })),
                  ],
                ),
              ),

              // ── BOTTOM RIGHT: Legend
              Positioned(
                bottom: 48,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.82),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _legRow(kGreen, 'Resources'),
                      const SizedBox(height: 5),
                      _legRow(kRed, 'Need Help'),
                      const SizedBox(height: 5),
                      _legRow(kBlue, 'Camp'),
                      const SizedBox(height: 5),
                      _legRow(kAccent, 'You'),
                    ],
                  ),
                ),
              ),

              // ── BOTTOM: Filter chips
              Positioned(
                bottom: 10,
                left: 10,
                child: Row(
                  children: [
                    _filterChip('All', 'all'),
                    const SizedBox(width: 7),
                    _filterChip('🆘', 'help'),
                    const SizedBox(width: 7),
                    _filterChip('📦', 'resource'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── HUD Pill
  Widget _hudPill(Widget child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.78),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kBorder),
        ),
        child: child,
      );

  // ── Zoom button
  Widget _ctrlBtn(String icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.78),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kBorder),
          ),
          child: Center(
            child: Text(icon,
                style: const TextStyle(
                    color: kText, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      );

  // ── Legend row
  Widget _legRow(Color color, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(color: kMuted, fontSize: 10)),
        ],
      );

  // ── Filter chip
  Widget _filterChip(String label, String value) {
    final active = _filter == value;
    return GestureDetector(
      onTap: () => setState(() {
        _filter = value;
        _selectedNode = null;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
        decoration: BoxDecoration(
          color:
              active ? kAccent.withOpacity(.15) : Colors.black.withOpacity(.75),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? kAccent : kBorder),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? kAccent : kMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700)),
      ),
    );
  }

  // ── Node tap bottom sheet
  void _showSheet(MapNode node) {
    final color = _colorFor(node.type);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D1625),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
                child: Container(
                    width: 34,
                    height: 4,
                    decoration: BoxDecoration(
                        color: kBorder,
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            // Header
            Row(children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(.3)),
                ),
                child: Center(
                    child:
                        Text(node.emoji, style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(node.name,
                    style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                Text('📍 ${node.distance} away',
                    style: const TextStyle(color: kMuted, fontSize: 12)),
              ]),
            ]),
            const SizedBox(height: 14),
            // Detail
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBorder),
              ),
              child: Text(node.detail,
                  style:
                      const TextStyle(color: kText, fontSize: 13, height: 1.6)),
            ),
            const SizedBox(height: 14),
            // Action
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(.35)),
                ),
                child: Center(
                    child: Text(
                        node.type == NodeType.help
                            ? '✓ I Can Help'
                            : node.type == NodeType.resource
                                ? '📡 Connect via Mesh'
                                : node.type == NodeType.camp
                                    ? '🏥 Get Directions'
                                    : '📦 Share Resources',
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: 14))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// CUSTOM PAINTER
// ════════════════════════════════════════════════════════════

class ReliefMapPainter extends CustomPainter {
  final List<MapNode> nodes;
  final List<List<String>> connections;
  final double animVal;
  final double rippleVal;
  final double zoom;
  final Offset pan;
  final String? selectedId;

  ReliefMapPainter({
    required this.nodes,
    required this.connections,
    required this.animVal,
    required this.rippleVal,
    required this.zoom,
    required this.pan,
    this.selectedId,
  });

  Color _colorFor(NodeType t) {
    switch (t) {
      case NodeType.you:
        return kAccent;
      case NodeType.resource:
        return kGreen;
      case NodeType.help:
        return kRed;
      case NodeType.camp:
        return kBlue;
    }
  }

  Offset _pos(MapNode n, Size s) => Offset(
        s.width / 2 + (n.x - .5) * s.width * zoom + pan.dx,
        s.height / 2 + (n.y - .5) * s.height * zoom + pan.dy,
      );

  @override
  void paint(Canvas canvas, Size size) {
    _drawBg(canvas, size);
    _drawGrid(canvas, size);
    _drawCoverage(canvas, size);
    _drawLines(canvas, size);
    _drawPins(canvas, size);
  }

  void _drawBg(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF070D18), Color(0xFF0A1525)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  void _drawGrid(Canvas canvas, Size size) {
    final p = Paint()
      ..color = kBorder.withOpacity(.35)
      ..strokeWidth = .6;
    final step = 38.0 * zoom;
    final ox = (size.width / 2 + pan.dx) % step;
    final oy = (size.height / 2 + pan.dy) % step;
    for (double x = ox; x < size.width; x += step)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    for (double y = oy; y < size.height; y += step)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
  }

  void _drawCoverage(Canvas canvas, Size size) {
    final you = nodes.firstWhere((n) => n.type == NodeType.you,
        orElse: () => nodes.first);
    final c = _pos(you, size);
    final r = 85.0 * zoom;

    // Radial glow fill
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
                  colors: [kAccent.withOpacity(.07), Colors.transparent])
              .createShader(Rect.fromCircle(center: c, radius: r)));

    // Dashed border ring
    _dashedCircle(
        canvas,
        c,
        r,
        Paint()
          ..color = kAccent.withOpacity(.2)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);

    // Animated scan pulse
    final sr = r * (.4 + .6 * rippleVal);
    canvas.drawCircle(
        c,
        sr,
        Paint()
          ..color = kAccent.withOpacity(.18 * (1 - rippleVal))
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke);
  }

  void _dashedCircle(Canvas canvas, Offset c, double r, Paint p) {
    const segs = 24;
    for (int i = 0; i < segs; i++) {
      if (i % 2 != 0) continue;
      final s = (i / segs) * 2 * pi;
      final e = ((i + .7) / segs) * 2 * pi;
      canvas.drawPath(
          Path()..addArc(Rect.fromCircle(center: c, radius: r), s, e - s), p);
    }
  }

  void _drawLines(Canvas canvas, Size size) {
    final nodeMap = {for (final n in nodes) n.id: n};
    for (final conn in connections) {
      final a = nodeMap[conn[0]];
      final b = nodeMap[conn[1]];
      if (a == null || b == null) continue;
      final pa = _pos(a, size);
      final pb = _pos(b, size);

      final pulse = .18 + .12 * sin(animVal * 2 * pi + (pa.dx + pb.dx) * .008);

      // Dashed line
      _dashedLine(
          canvas,
          pa,
          pb,
          Paint()
            ..color = kAccent.withOpacity(pulse)
            ..strokeWidth = 1.0);

      // Animated dot moving along line
      final t = (animVal + (pa.dx + pb.dx) * .0025) % 1.0;
      final dp = pa + (pb - pa) * t;
      canvas.drawCircle(dp, 2.5,
          Paint()..color = kAccent.withOpacity((pulse * 2.8).clamp(.0, 1.0)));
    }
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint p) {
    final d = b - a;
    final len = d.distance;
    if (len < 1) return;
    const dash = 5.0, gap = 7.0;
    double t = 0;
    bool draw = true;
    while (t < len) {
      final seg = draw ? dash : gap;
      final end = min(t + seg, len);
      if (draw) canvas.drawLine(a + d / len * t, a + d / len * end, p);
      t = end;
      draw = !draw;
    }
  }

  void _drawPins(Canvas canvas, Size size) {
    for (final node in nodes) {
      final pos = _pos(node, size);

      // Skip off-screen pins
      if (pos.dx < -30 || pos.dx > size.width + 30) continue;
      if (pos.dy < -30 || pos.dy > size.height + 30) continue;

      final color = _colorFor(node.type);
      final r = node.type == NodeType.you ? 12.0 : 9.0;
      final isSel = node.id == selectedId;

      // Ripple
      canvas.drawCircle(
          pos,
          r + 13 * rippleVal,
          Paint()
            ..color = color.withOpacity(.38 * (1 - rippleVal))
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke);

      // Selection ring
      if (isSel) {
        canvas.drawCircle(
            pos,
            r + 5,
            Paint()
              ..color = color.withOpacity(.55)
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke);
      }

      // Red glow for help
      if (node.type == NodeType.help) {
        canvas.drawCircle(
            pos,
            r * 2.6,
            Paint()
              ..shader = RadialGradient(
                      colors: [kRed.withOpacity(.30), Colors.transparent])
                  .createShader(Rect.fromCircle(center: pos, radius: r * 2.6)));
      }

      // Main circle
      canvas.drawCircle(pos, r + (isSel ? 1.5 : 0), Paint()..color = color);

      // Dark border
      canvas.drawCircle(
          pos,
          r + (isSel ? 1.5 : 0),
          Paint()
            ..color = Colors.black.withOpacity(.45)
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke);

      // ✅ Emoji — WASM safe (ui.Paragraph, no TextDirection)
      _drawText(canvas, node.emoji, Offset(pos.dx, pos.dy),
          node.type == NodeType.you ? 13.0 : 11.0, Colors.white, false);

      // ✅ Label — WASM safe
      _drawLabel(canvas, node.name, Offset(pos.dx, pos.dy + r + 6),
          isSel ? 10.5 : 9.5, isSel ? color : kText, isSel);
    }
  }

  // ✅ WASM-safe emoji drawing using ui.Paragraph
  void _drawText(Canvas canvas, String text, Offset center, double size,
      Color color, bool bold) {
    final pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      fontSize: size,
      textAlign: TextAlign.center,
    ))
      ..pushStyle(ui.TextStyle(
          color: color,
          fontSize: size,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400))
      ..addText(text);
    final para = pb.build()..layout(const ui.ParagraphConstraints(width: 40));
    canvas.drawParagraph(para,
        Offset(center.dx - para.longestLine / 2, center.dy - para.height / 2));
  }

  // ✅ WASM-safe label with dark background
  void _drawLabel(Canvas canvas, String text, Offset origin, double fontSize,
      Color color, bool bold) {
    final pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      fontSize: fontSize,
      textAlign: TextAlign.center,
    ))
      ..pushStyle(ui.TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400))
      ..addText(text);
    final para = pb.build()..layout(const ui.ParagraphConstraints(width: 100));
    final w = para.longestLine;
    final h = para.height;
    final dx = origin.dx - w / 2;

    // Dark pill background
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(dx - 5, origin.dy - 1, w + 10, h + 3),
            const Radius.circular(4)),
        Paint()..color = Colors.black.withOpacity(.80));

    canvas.drawParagraph(para, Offset(dx, origin.dy));
  }

  @override
  bool shouldRepaint(ReliefMapPainter old) =>
      old.animVal != animVal ||
      old.rippleVal != rippleVal ||
      old.zoom != zoom ||
      old.pan != pan ||
      old.selectedId != selectedId ||
      old.nodes.length != nodes.length;
}
