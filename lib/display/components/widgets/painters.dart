import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  final Color color;

  CurvePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var width = size.width, height = size.height;

    var path = Path();

    path.moveTo(0, height * 0.9167);
    path.quadraticBezierTo(
      width * 0.25,
      height * 0.875,
      width * 0.5,
      height * 0.9167,
    );
    path.quadraticBezierTo(
      width * 0.75,
      height * 0.9584,
      width * 1.0,
      height * 0.9167,
    );
    path.lineTo(width, height);
    path.lineTo(0, height);

    canvas.drawPath(path, paint);

    paint.color = color.withOpacity(.7);
    height = 150;

    var pathTop = Path();

    pathTop.moveTo(0, height * 0.9167);
    pathTop.quadraticBezierTo(
      width * 0.25,
      height * 0.675,
      width * 0.5,
      height * 0.8167,
    );
    pathTop.quadraticBezierTo(
      width * 0.75,
      height * 0.9584,
      width * 1.0,
      height * 0.8567,
    );
    pathTop.lineTo(width, 0);
    pathTop.lineTo(0, 0);

    canvas.drawPath(pathTop, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainterTop extends CustomPainter {
  final Color color;

  CurvePainterTop(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var width = size.width, height = size.height;

    paint.color = color.withOpacity(.7);
    height = 150;

    var pathTop = Path();

    pathTop.moveTo(0, height * 0.9167);
    pathTop.quadraticBezierTo(
      width * 0.25,
      height * 0.675,
      width * 0.5,
      height * 0.8167,
    );
    pathTop.quadraticBezierTo(
      width * 0.75,
      height * 0.9584,
      width * 1.0,
      height * 0.8567,
    );
    pathTop.lineTo(width, 0);
    pathTop.lineTo(0, 0);

    canvas.drawPath(pathTop, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CurvePainterBottom extends CustomPainter {
  final Color color;

  CurvePainterBottom(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var width = size.width, height = size.height;

    var path = Path();

    path.moveTo(0, height * 0.9167);
    path.quadraticBezierTo(
      width * 0.25,
      height * 0.875,
      width * 0.5,
      height * 0.9167,
    );
    path.quadraticBezierTo(
      width * 0.75,
      height * 0.9584,
      width * 1.0,
      height * 0.9167,
    );
    path.lineTo(width, height);
    path.lineTo(0, height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
