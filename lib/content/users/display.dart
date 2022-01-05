import 'package:flutter/material.dart';

import 'package:haja/display/components/teams/full_user_page.dart';
import 'package:haja/display/components/widgets/backable_page.dart';

import 'content.dart';

class UserContentDisplayPage extends StatelessWidget {
  final UserContent user;

  const UserContentDisplayPage(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackablePage(
      child: DashboardProfileDisplay(user),
    );
  }
}
