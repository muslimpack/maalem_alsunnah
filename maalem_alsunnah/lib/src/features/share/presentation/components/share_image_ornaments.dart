import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An eight-pointed star (two overlapping squares), with a small hole in the
/// middle in [holeColor].
class EightPointStar extends StatelessWidget {
  final double size;
  final Color color;
  final Color holeColor;

  const EightPointStar({
    super.key,
    required this.size,
    required this.color,
    required this.holeColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _StarPainter(color: color, holeColor: holeColor),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  final Color holeColor;

  _StarPainter({required this.color, required this.holeColor});

  @override
  void paint(Canvas canvas, Size size) {
    paintStar(canvas, size.center(Offset.zero), size.shortestSide / 2, color, holeColor);
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.color != color || old.holeColor != holeColor;
}

void paintStar(Canvas canvas, Offset center, double radius, Color color, Color holeColor) {
  // A square whose corners touch the circle has half-side radius / √2.
  final half = radius / math.sqrt2;
  final square = Rect.fromCenter(center: center, width: half * 2, height: half * 2);
  final paint = Paint()..color = color;

  canvas.drawRect(square, paint);
  canvas
    ..save()
    ..translate(center.dx, center.dy)
    ..rotate(math.pi / 4)
    ..translate(-center.dx, -center.dy)
    ..drawRect(square, paint)
    ..restore();

  canvas.drawCircle(center, radius * .32, Paint()..color = holeColor);
  canvas.drawCircle(center, radius * .14, paint);
}

/// A hairline that fades out at both ends with a star in the middle.
class OrnamentDivider extends StatelessWidget {
  final Color color;
  final Color background;
  final double starSize;

  const OrnamentDivider({
    super.key,
    required this.color,
    required this.background,
    this.starSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    Widget line(Alignment fadeTo) {
      return Expanded(
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: -fadeTo,
              end: fadeTo,
              colors: [color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        line(Alignment.centerLeft),
        const SizedBox(width: 18),
        EightPointStar(size: starSize, color: color, holeColor: background),
        const SizedBox(width: 18),
        line(Alignment.centerRight),
      ],
    );
  }
}

/// A double rounded frame inset from the card edges, with a star on each
/// corner of the outer line.
class OrnamentFramePainter extends CustomPainter {
  static const double outerInset = 36;
  static const double innerInset = 50;

  final Color color;
  final Color background;

  OrnamentFramePainter({required this.color, required this.background});

  @override
  void paint(Canvas canvas, Size size) {
    final outer = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(outerInset),
      const Radius.circular(28),
    );
    final inner = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(innerInset),
      const Radius.circular(18),
    );

    canvas.drawRRect(
      outer,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = color,
    );
    canvas.drawRRect(
      inner,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = color.withValues(alpha: color.a * .5),
    );

    // Stars sit where the rounded corner meets the diagonal.
    const d = outerInset + 28 * (1 - 1 / math.sqrt2);
    for (final corner in [
      Offset(d, d),
      Offset(size.width - d, d),
      Offset(d, size.height - d),
      Offset(size.width - d, size.height - d),
    ]) {
      canvas.drawCircle(corner, 18, Paint()..color = background);
      paintStar(canvas, corner, 14, color, background);
    }
  }

  @override
  bool shouldRepaint(OrnamentFramePainter old) =>
      old.color != color || old.background != background;
}
