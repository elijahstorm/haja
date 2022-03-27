import 'package:flutter/material.dart';

import 'package:haja/content/users/content.dart';
import 'package:haja/display/components/animations/loading.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';

@Deprecated("No use case for this card. Use HorizontalUserCard instead")
class UserCard extends StatelessWidget {
  final UserContent user;

  const UserCard(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          vertical: Constants.defaultPadding / 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: user.icon,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.caption,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .color!
                            .withOpacity(.8),
                      ),
                    ),
                  ],
                )
              ],
            ),
            FutureBuilder<bool>(
              future: user.following(),
              builder: (context, snapshot) => snapshot.hasData
                  ? StatefulBuilder(
                    builder: (context, setState) {
                      return GestureDetector(
                          onTap: () => setState(
                            () => snapshot.data!
                                ? user.follow(
                                    followType: FollowType.unfollow,
                                  )
                                : user.follow(),
                          ),
                          child: AnimatedContainer(
                            height: 35,
                            width: 110,
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: snapshot.data!
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: snapshot.data!
                                    ? Colors.transparent
                                    : Colors.grey.shade700,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                snapshot.data!
                                    ? Language.unfollowButton
                                    : Language.followButton,
                                style: TextStyle(
                                  color: snapshot.data!
                                      ? Theme.of(context).scaffoldBackgroundColor
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        );
                    }
                  )
                  : const LoadingButton(),
            ),
          ],
        ),
      );
}
