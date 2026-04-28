// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ============================================================
// ReliefNet — MAP ONLY Widget
// ✅ FlutterFlow Compatible (width + height params)
// ✅ WASM / Web Safe
// ✅ Labels via Flutter Positioned widgets — NOT canvas
// ============================================================

import 'dart:math';
import 'dart:async';
import 'dart:ui' as ui;

enum NodeType { you, resource, help, camp }

class MapNode {
  final String id;
  final String name;
  final NodeType type;
  final double x; // 0.0 to 1.0
  final double y; // 0.0 to 1.0

  const MapNode({
    required this.id,
    required this.name,
    required this.type,
    required this.x,
    required this.y,
  });
}

const List<MapNode> sampleNodes = [
  MapNode(id: 'you', name: 'YOU', type: NodeType.you, x: 0.50, y: 0.50),
  MapNode(
      id: 'ramesh', name: 'Ramesh', type: NodeType.resource, x: 0.27, y: 0.33),
  MapNode(
      id: 'priya', name: 'Priya', type: NodeType.resource, x: 0.70, y: 0.27),
  MapNode(id: 'mohan', name: 'Mohan', type: NodeType.help, x: 0.18, y: 0.65),
  MapNode(id: 'sunita', name: 'Sunita', type: NodeType.help, x: 0.78, y: 0.68),
  MapNode(id: 'ngo', name: 'NGO Camp', type: NodeType.camp, x: 0.55, y: 0.18),
  MapNode(
      id: 'vikram', name: 'Vikram', type: NodeType.resource, x: 0.38, y: 0.72),
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

// Colors
const Color kBg = Color(0xFF070D18);
const Color kCard = Color(0xFF111E30);
const Color kBorder = Color(0xFF1C2E48);
const Color kAccent = Color(0xFF00E5FF);
const Color kGreen = Color(0xFF00E676);
const Color kRed = Color(0xFFFF3B3B);
const Color kBlue = Color(0xFF3D8EFF);
const Color kText = Color(0xFFDDE6F5);
const Color kMuted = Color(0xFF5A6E8C);

/// ════════════════════════════════════════════════════════════ MAIN WIDGET
/// ════════════════════════════════════════════════════════════
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
  String? _selectedId;

  // Pin size constant
  static const double kPinR = 11.0;
  static const double kYouR = 14.0;
  static const double kLabelH = 22.0; // approx label pill height
  static const double kLabelW = 80.0; // approx label pill width

  @override
  void initState() {
    super.initState();
    _anim =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat();
    _ripple =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
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

  List<MapNode> get _visible {
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

  // Convert node x/y (0-1) to pixel position
  Offset _pinPos(MapNode n) => _pinPosFromSize(n, _actualSize);

  void _onTap(Offset pos) {
    for (final node in _visible) {
      final p = _pinPos(node);
      if ((pos - p).distance < 24) {
        setState(() => _selectedId = node.id);
        _showSheet(node);
        return;
      }
    }
    setState(() => _selectedId = null);
  }

  // Actual rendered size tracked via LayoutBuilder
  Size _actualSize = Size.zero;

  // Pin position using ACTUAL size (not widget.width/height)
  Offset _pinPosFromSize(MapNode n, Size s) => Offset(
        s.width / 2 + (n.x - .5) * s.width * _zoom + _pan.dx,
        s.height / 2 + (n.y - .5) * s.height * _zoom + _pan.dy,
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // ✅ Use actual rendered size — fixes FlutterFlow mismatch
          final actualW = constraints.maxWidth;
          final actualH = constraints.maxHeight;
          _actualSize = Size(actualW, actualH);

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: kBg,
              child: Stack(
                children: [
                  // ── 1. Animated canvas (lines, circles, rings)
                  AnimatedBuilder(
                    animation: _anim,
                    builder: (_, __) => GestureDetector(
                      onTapUp: (d) => _onTap(d.localPosition),
                      onScaleUpdate: (d) => setState(() {
                        _zoom = (_zoom * d.scale).clamp(0.6, 2.5);
                        _pan += d.focalPointDelta;
                      }),
                      child: CustomPaint(
                        painter: MapCanvasPainter(
                          nodes: _visible,
                          connections: meshConnections,
                          animVal: _anim.value,
                          rippleVal: _ripple.value,
                          zoom: _zoom,
                          pan: _pan,
                          selectedId: _selectedId,
                          colorFor: _colorFor,
                        ),
                        child: SizedBox(width: actualW, height: actualH),
                      ),
                    ),
                  ),

                  // ── 2. Labels as Flutter Positioned widgets
                  ..._visible.map((node) {
                    final pos = _pinPosFromSize(node, _actualSize);
                    final r = node.type == NodeType.you ? kYouR : kPinR;
                    final color = _colorFor(node.type);
                    final isSel = node.id == _selectedId;
                    final isHelp = node.type == NodeType.help;

                    // Label below pin by default
                    double labelTop = pos.dy + r + 5;
                    // Flip above if overflows bottom
                    if (labelTop + kLabelH > actualH - 8) {
                      labelTop = pos.dy - r - kLabelH - 5;
                    }

                    // Center label on pin, clamp to edges
                    double labelLeft = pos.dx - kLabelW / 2;
                    labelLeft = labelLeft.clamp(4.0, actualW - kLabelW - 4);

                    // Skip off-screen pins
                    if (pos.dx < -20 || pos.dx > actualW + 20)
                      return const SizedBox();
                    if (pos.dy < -20 || pos.dy > actualH + 20)
                      return const SizedBox();

                    return Positioned(
                      left: labelLeft,
                      top: labelTop,
                      width: kLabelW,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.82),
                          borderRadius: BorderRadius.circular(5),
                          border: isSel
                              ? Border.all(
                                  color: color.withOpacity(.5), width: 1)
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isHelp) ...[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    color: kRed, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 4),
                            ],
                            Flexible(
                              child: Text(
                                node.name,
                                style: TextStyle(
                                  color: isSel ? color : kText,
                                  fontSize: 10,
                                  fontWeight:
                                      isSel ? FontWeight.w700 : FontWeight.w500,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  // ── 3. TOP LEFT HUD
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _hudPill(Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                                color: kGreen,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: kGreen.withOpacity(.7),
                                      blurRadius: 5)
                                ]),
                          ),
                          const SizedBox(width: 6),
                          const Text('Live Updates',
                              style: TextStyle(
                                  color: kText,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ])),
                        const SizedBox(height: 6),
                        _hudPill(Text('Scale: ${_zoom.toStringAsFixed(1)}x',
                            style: const TextStyle(
                                color: kMuted,
                                fontSize: 11,
                                fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ),

                  // ── 4. TOP RIGHT zoom controls
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Column(children: [
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
                    ]),
                  ),

                  // ── 5. BOTTOM RIGHT legend
                  Positioned(
                    bottom: 48,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 9),
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

                  // ── 6. BOTTOM LEFT filter chips
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Row(children: [
                      _fChip('All', 'all'),
                      const SizedBox(width: 7),
                      _fChip('🆘', 'help'),
                      const SizedBox(width: 7),
                      _fChip('📦', 'resource'),
                    ]),
                  ),
                ],
              ),
            ),
          ); // ClipRRect
        }, // LayoutBuilder builder
      ), // LayoutBuilder
    ); // SizedBox
  }

  Widget _hudPill(Widget child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.78),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: kBorder),
        ),
        child: child,
      );

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
                      color: kText,
                      fontSize: 16,
                      fontWeight: FontWeight.w600))),
        ),
      );

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

  Widget _fChip(String label, String value) {
    final active = _filter == value;
    return GestureDetector(
      onTap: () => setState(() {
        _filter = value;
        _selectedId = null;
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
              fontWeight: FontWeight.w700,
            )),
      ),
    );
  }

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
            Center(
                child: Container(
                    width: 34,
                    height: 4,
                    decoration: BoxDecoration(
                        color: kBorder,
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(.35)),
                ),
                child: Center(
                    child: Container(
                  width: 20,
                  height: 20,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                )),
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(node.name,
                    style: TextStyle(
                        color: color,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                Text(
                    node.type == NodeType.help
                        ? '🔴 Needs Help'
                        : node.type == NodeType.resource
                            ? '🟢 Has Resources'
                            : node.type == NodeType.camp
                                ? '🔵 Relief Camp'
                                : '📍 Your Location',
                    style: const TextStyle(color: kMuted, fontSize: 12)),
              ]),
            ]),
            const SizedBox(height: 16),
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
// CANVAS PAINTER — Only draws circles, lines, rings
// Labels are NOT drawn here — done via Flutter widgets above
// ════════════════════════════════════════════════════════════
class MapCanvasPainter extends CustomPainter {
  final List<MapNode> nodes;
  final List<List<String>> connections;
  final double animVal;
  final double rippleVal;
  final double zoom;
  final Offset pan;
  final String? selectedId;
  final Color Function(NodeType) colorFor;

  MapCanvasPainter({
    required this.nodes,
    required this.connections,
    required this.animVal,
    required this.rippleVal,
    required this.zoom,
    required this.pan,
    required this.colorFor,
    this.selectedId,
  });

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
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
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

    canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
                  colors: [kAccent.withOpacity(.07), Colors.transparent])
              .createShader(Rect.fromCircle(center: c, radius: r)));

    _dashedCircle(
        canvas,
        c,
        r,
        Paint()
          ..color = kAccent.withOpacity(.2)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke);

    canvas.drawCircle(
        c,
        r * (.4 + .6 * rippleVal),
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
    final map = {for (final n in nodes) n.id: n};
    for (final conn in connections) {
      final a = map[conn[0]];
      final b = map[conn[1]];
      if (a == null || b == null) continue;
      final pa = _pos(a, size);
      final pb = _pos(b, size);
      final pulse = .18 + .12 * sin(animVal * 2 * pi + (pa.dx + pb.dx) * .008);
      _dashedLine(
          canvas,
          pa,
          pb,
          Paint()
            ..color = kAccent.withOpacity(pulse)
            ..strokeWidth = 1.0);
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
    double t = 0;
    bool draw = true;
    while (t < len) {
      final seg = draw ? 5.0 : 7.0;
      final end = min(t + seg, len);
      if (draw) canvas.drawLine(a + d / len * t, a + d / len * end, p);
      t = end;
      draw = !draw;
    }
  }

  void _drawPins(Canvas canvas, Size size) {
    for (final node in nodes) {
      final pos = _pos(node, size);
      if (pos.dx < -30 || pos.dx > size.width + 30) continue;
      if (pos.dy < -30 || pos.dy > size.height + 30) continue;

      final color = colorFor(node.type);
      final r = node.type == NodeType.you ? 14.0 : 11.0;
      final isSel = node.id == selectedId;

      // Ripple
      canvas.drawCircle(
          pos,
          r + 14 * rippleVal,
          Paint()
            ..color = color.withOpacity(.35 * (1 - rippleVal))
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke);

      // Selection ring
      if (isSel) {
        canvas.drawCircle(
            pos,
            r + 6,
            Paint()
              ..color = color.withOpacity(.55)
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke);
      }

      // Red glow for SOS
      if (node.type == NodeType.help) {
        canvas.drawCircle(
            pos,
            r * 2.8,
            Paint()
              ..shader = RadialGradient(
                      colors: [kRed.withOpacity(.28), Colors.transparent])
                  .createShader(Rect.fromCircle(center: pos, radius: r * 2.8)));
      }

      // Main circle fill
      canvas.drawCircle(pos, r, Paint()..color = color);

      // Dark border
      canvas.drawCircle(
          pos,
          r,
          Paint()
            ..color = Colors.black.withOpacity(.5)
            ..strokeWidth = 2.5
            ..style = PaintingStyle.stroke);

      // Inner white shape
      if (node.type == NodeType.you) {
        canvas.drawCircle(
            pos,
            r * 0.42,
            Paint()
              ..color = Colors.white.withOpacity(.9)
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke);
      } else {
        canvas.drawCircle(
            pos, r * 0.28, Paint()..color = Colors.white.withOpacity(.9));
      }
    }
  }

  @override
  bool shouldRepaint(MapCanvasPainter o) =>
      o.animVal != animVal ||
      o.rippleVal != rippleVal ||
      o.zoom != zoom ||
      o.pan != pan ||
      o.selectedId != selectedId ||
      o.nodes.length != nodes.length;
}
