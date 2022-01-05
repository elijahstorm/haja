import 'package:flutter/material.dart';

import 'package:haja/display/components/calendar/todo.dart';

class TodoViewer extends StatelessWidget {
  const TodoViewer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Todo(),
        ],
      );
}
