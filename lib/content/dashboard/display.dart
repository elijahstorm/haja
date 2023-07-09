import 'package:flutter/material.dart';

import 'content.dart';

class DashboardContentDisplayPage extends StatelessWidget {
  final DashboardContent content;

  const DashboardContentDisplayPage(
    this.content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
