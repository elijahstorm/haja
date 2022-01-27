import 'package:flutter/material.dart';

import 'package:haja/display/components/teams/user_profile_view.dart';

import 'content.dart';

class UserContentDisplayPage extends StatelessWidget {
  final UserContent user;

  const UserContentDisplayPage(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => UserProfileView(user.id);
}
