import 'package:flutter/material.dart';

import 'package:haja/display/components/teams/team_page.dart';

import 'content.dart';

class TeamContentDisplayPage extends StatelessWidget {
  final TeamContent content;

  const TeamContentDisplayPage(
    this.content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TeamPageDisplay(content);
}
