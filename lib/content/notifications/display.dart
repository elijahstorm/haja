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
    return Scaffold(
      body: Column(
        children: const [
          Text('hey hey heys'),
        ],
      ),
    );
  }
}
