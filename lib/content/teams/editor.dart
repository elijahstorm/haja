import 'package:flutter/material.dart';

import 'package:haja/display/components/teams/team_editor_page.dart';
import 'package:haja/display/components/teams/user_list_editor_page.dart';

import 'content.dart';

class TeamContentEditorPage extends StatelessWidget {
  final TeamContent content;

  const TeamContentEditorPage(
    this.content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TeamEditorDisplay(content);
}

class TeamUserListEditorPage extends StatelessWidget {
  final TeamContent content;

  const TeamUserListEditorPage(
    this.content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => UserListEditorDisplay(content);
}
