import 'package:flutter/material.dart';

import 'package:haja/display/components/teams/user_editor_page.dart';

import 'content.dart';

class UserContentEditorPage extends StatelessWidget {
  final UserContent content;

  const UserContentEditorPage(
    this.content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => UserEditorDisplay(content);
}
