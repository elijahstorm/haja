import 'dart:math';

import 'package:flutter/material.dart';

import 'package:haja/display/components/widgets/avatars.dart';
import 'package:haja/display/components/animations/loading.dart';
import 'package:haja/content/users/content.dart';
import 'package:haja/language/constants.dart';

class UserAvatars extends CircleOverlappableAvatar {
  final UserContent user;

  UserAvatars(
    this.user, {
    double? size,
    Key? key,
  }) : super(
          key: key,
          display: user.icon,
          size: size,
        );
}

class UserAvatarStack extends StatelessWidget {
  final List<Future<UserContent?>> users;
  final double avatarSize = Constants.defaultPadding * 1.5;
  final VoidCallback? onTap;

  const UserAvatarStack(
    this.users, {
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: avatarSize + (users.length - 1) * avatarSize,
          height: avatarSize,
          child: Stack(
            children: List.generate(
              max(users.length, 3),
              (index) => Positioned(
                top: 0,
                bottom: 0,
                right: index * avatarSize * .5,
                child: FutureBuilder<UserContent?>(
                  future: users[index],
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return UserAvatars(
                        snapshot.data!,
                        size: avatarSize,
                      );
                    }

                    return LoadingAvatar(
                      size: avatarSize - 5,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
}
