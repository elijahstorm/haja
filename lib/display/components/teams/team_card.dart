import 'package:flutter/material.dart';

import 'package:haja/content/teams/content.dart';
import 'package:haja/display/components/teams/team_user_avatars.dart';
import 'package:haja/language/constants.dart';

class TeamCard extends StatelessWidget {
  final TeamContent team;

  const TeamCard(
    this.team, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(
          Constants.defaultBorderRadiusXLarge,
        ),
      ),
      child: GestureDetector(
        onTap: () => team.navigateTo(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      team.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, err, stacktrace) => Image.asset(
                        Constants.defaultTeamPicture,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Theme.of(context).iconTheme.color!.withOpacity(.7),
                            Theme.of(context).iconTheme.color!.withOpacity(.5),
                            Colors.transparent,
                            Theme.of(context).iconTheme.color!.withOpacity(.2),
                            Theme.of(context).iconTheme.color!.withOpacity(.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: Constants.defaultPadding,
                    bottom: Constants.defaultPadding,
                    child: Text(
                      team.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: Constants.defaultPadding,
                    bottom: Constants.defaultPadding,
                    child: Row(
                      children: [
                        UserAvatarStack(team.usersContent),
                        const SizedBox(
                          width: Constants.defaultPadding / 2,
                        ),
                        Opacity(
                          opacity: .8,
                          child: Text(
                            team.users.length.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: Constants.defaultPadding,
                    top: Constants.defaultPadding / 2,
                    child: GestureDetector(
                      child: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      onTap: () {
                        print('open options');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}