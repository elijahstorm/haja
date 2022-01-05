import 'package:flutter/material.dart';

class NavbarDataHolder {
  String name, title;
  IconData icon;
  Color Function(BuildContext) color;
  Widget child;

  NavbarDataHolder({
    required this.name,
    required this.title,
    required this.color,
    required this.icon,
    required this.child,
  });
}
