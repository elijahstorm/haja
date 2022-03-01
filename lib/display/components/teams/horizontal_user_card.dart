import 'package:flutter/material.dart';

import 'package:haja/content/users/content.dart';
import 'package:haja/display/components/teams/team_user_avatars.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';

class HorizontalUserCard extends StatelessWidget {
  final UserContent user;

  const HorizontalUserCard(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
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
                    user.title,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: Constants.defaultPadding,
          ),
          TextButton(
            onPressed: () => user.follow(),
            style: TextButton.styleFrom(
              primary: Theme.of(context).scaffoldBackgroundColor,
              backgroundColor: Theme.of(context).primaryColor,
              minimumSize: const Size(
                Constants.defaultPadding * 3,
                Constants.defaultPadding * 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Constants.defaultBorderRadiusXLarge,
                ),
              ),
            ),
            child: const Text(
              Language.followButton,
            ),
          ),
        ],
      );
}
