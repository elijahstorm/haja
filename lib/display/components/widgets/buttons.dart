import 'package:flutter/material.dart';
import 'package:haja/content/users/content.dart';
import 'package:haja/display/components/animations/loading.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';

class GenericFloatingButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const GenericFloatingButton({
    required this.onTap,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding,
          ),
          height: Constants.defaultPadding * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Constants.defaultCardRadius * 4,
            ),
            color: Theme.of(context).primaryColor,
          ),
          child: Align(
            child: Text(
              label,
            ),
          ),
        ),
      );
}

class FollowButton extends StatefulWidget {
  final UserContent user;

  const FollowButton({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  State<FollowButton> createState() => _FollowButton();
}

class _FollowButton extends State<FollowButton> {
  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
        future: widget.user.following(),
        builder: (context, snapshot) => snapshot.hasData
            ? snapshot.data!
                ? OutlinedButton(
                    onPressed: () => setState(
                      () => widget.user.follow(
                        followType: FollowType.unfollow,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
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
                    child: Text(
                      Language.unfollowButton,
                      style: TextStyle(
                        color: Constants.bgColorDark.withOpacity(.5),
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () => setState(() => widget.user.follow()),
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
                      style: TextStyle(
                        color: Constants.bgColorLight,
                      ),
                    ),
                  )
            : const LoadingButton(),
      );
}
