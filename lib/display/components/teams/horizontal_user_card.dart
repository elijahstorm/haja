import 'package:flutter/material.dart';

import 'package:haja/content/users/content.dart';
import 'package:haja/display/components/teams/team_user_avatars.dart';
import 'package:haja/display/components/widgets/buttons.dart';
import 'package:haja/firebase/auth.dart';
import 'package:haja/language/constants.dart';

class HorizontalUserCard extends StatelessWidget {
  final UserContent user;
  final Widget? trailing;

  const HorizontalUserCard(
    this.user, {
    this.trailing,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
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
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Opacity(
                    opacity: .6,
                    child: Text(
                      user.caption,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: Constants.defaultPadding,
            ),
            if (trailing == null && AuthApi.activeUser != user.id)
              FollowButton(user: user),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: Constants.defaultPadding,
                ),
                child: trailing!,
              ),
          ],
        ),
      );
}
