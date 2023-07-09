import 'package:flutter/material.dart';

import 'content.dart';

class TodoContentDisplayPage extends StatelessWidget {
  final TodoContent content;

  const TodoContentDisplayPage(
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
