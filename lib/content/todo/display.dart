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
    return Scaffold(
      body: Column(
        children: const [
          Text('hey hey heys'),
        ],
      ),
    );
  }
}
