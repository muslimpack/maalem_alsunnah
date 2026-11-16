import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Gold used for the manuscript-style chapter opening, tuned per brightness.
Color manuscriptGold(BuildContext context) => Theme.of(context).brightness == Brightness.dark
    ? const Color(0xFFD9B56A)
    : const Color(0xFFA07A2C);

/// A gold eight-point star (khatam) between two hairlines that fade outwards,
/// like the divider of an illuminated manuscript opening.
class ManuscriptOrnament extends StatelessWidget {
  const ManuscriptOrnament({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    final gold = manuscriptGold(context);
    Widget line(Alignment begin) => Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,
                end: -begin,
                colors: [gold.withValues(alpha: 0), gold],
              ),
            ),
          ),
        );

    return ExcludeSemantics(
      child: Row(
        spacing: 10,
        children: [
          line(Alignment.centerLeft),
          CustomPaint(
            size: Size.square(size),
            painter: _KhatamPainter(
              color: gold,
              hole: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          line(Alignment.centerRight),
        ],
      ),
    );
  }
}

class _KhatamPainter extends CustomPainter {
  const _KhatamPainter({required this.color, required this.hole});

  final Color color;
  final Color hole;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final half = size.shortestSide / 2 * 0.72;
    final paint = Paint()..color = color;

    // Two overlapping squares, one turned 45°, make the eight-point star.
    for (final angle in [0.0, math.pi / 4]) {
      canvas
        ..save()
        ..translate(center.dx, center.dy)
        ..rotate(angle)
        ..drawRect(Rect.fromCenter(center: Offset.zero, width: half * 2, height: half * 2), paint)
        ..restore();
    }
    canvas.drawCircle(center, half * 0.42, Paint()..color = hole);
    canvas.drawCircle(center, half * 0.2, paint);
  }

  @override
  bool shouldRepaint(_KhatamPainter old) => old.color != color || old.hole != hole;
}
