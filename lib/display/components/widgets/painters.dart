import 'package:flutter/material.dart';
import 'package:haja/language/art.dart';

enum Painters {
  top,
  bottom,
}

extension PaintersExtension on Painters {
  void draw(
    Canvas canvas,
    Size size,
    Color color,
  ) {
    Art art = Art(size.width, size.height);
    Paint paint = Paint();

    switch (this) {
      case Painters.top:
        paint.color = color;
        paint.style = PaintingStyle.fill;
        paint.color = color.withOpacity(.7);

        canvas.drawPath(
          art.drawTop(
            height: 200,
          ),
          paint,
        );
        break;
      case Painters.bottom:
        paint.color = color;
        paint.style = PaintingStyle.fill;

        canvas.drawPath(
          art.drawBottom(),
          paint,
        );
        break;
    }
  }
}

class CurvePainter extends CustomPainter {
  final Color color;
  final List<Painters> painters;

  CurvePainter({
    required this.color,
    required this.painters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var painter in painters) {
      painter.draw(canvas, size, color);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
