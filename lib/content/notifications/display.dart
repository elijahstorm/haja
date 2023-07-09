import 'package:flutter/material.dart';

import 'content.dart';

class NotificationContentDisplayPage extends StatelessWidget {
  final NotificationContent content;

  const NotificationContentDisplayPage(
    this.content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text('hey hey heys'),
        ],
      ),
    );
  }
}
