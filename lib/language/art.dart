import 'package:flutter/material.dart';

class Art {
  final double defaultWidth, defaultHeight;

  Art(
    this.defaultWidth,
    this.defaultHeight,
  );

  Path drawTop({
    double? width,
    double? height,
  }) {
    width = width ?? defaultWidth;
    height = height ?? defaultHeight;

    Path path = Path();

    path.moveTo(0, height * 0.9167);
    path.quadraticBezierTo(
      width * 0.25,
      height * 0.675,
      width * 0.5,
      height * 0.8167,
    );
    path.quadraticBezierTo(
      width * 0.75,
      height * 0.9584,
      width * 1.0,
      height * 0.8567,
    );
    path.lineTo(width, 0);
    path.lineTo(0, 0);

    return path;
  }

  Path drawBottom({
    double? width,
    double? height,
  }) {
    width = width ?? defaultWidth;
    height = height ?? defaultHeight;

    Path path = Path();

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

    return path;
  }
}
