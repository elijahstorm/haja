import 'package:flutter/material.dart';

import 'package:haja/content/users/content.dart';
import 'package:haja/display/components/teams/team_user_avatars.dart';
import 'package:haja/display/components/widgets/buttons.dart';
import 'package:haja/firebase/auth.dart';
import 'package:haja/language/constants.dart';

class HorizontalUserCard extends StatelessWidget {
  final UserContent user;

  const HorizontalUserCard(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => user.navigateTo(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Constants.defaultPadding * 2,
              child: UserAvatars(user),
            ),
            const SizedBox(
              width: Constants.defaultPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Opacity(
                    opacity: .6,
                    child: Text(
                      user.caption,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: Constants.defaultPadding,
            ),
            if (AuthApi.activeUser != user.id) FollowButton(user: user),
          ],
        ),
      );
}
