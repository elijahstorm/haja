import 'dart:math';
import 'package:flutter/material.dart';
import 'package:haja/display/components/teams/person_card_info.dart';
import 'package:provider/provider.dart';

import 'package:haja/firebase/auth.dart';
import 'package:haja/controllers/responsive.dart';
import 'package:haja/controllers/keys.dart';
import 'package:haja/login/user_state.dart';
import 'package:haja/language/language.dart';
import 'package:haja/content/teams/cache.dart';
import 'package:haja/content/teams/content.dart';
import 'package:haja/content/users/cache.dart';
import 'package:haja/display/components/widgets/avatars.dart'
    show CircleStoryAvatar;

import 'package:haja/language/constants.dart';

class OurTeamMembers extends StatelessWidget {
  const OurTeamMembers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Language.appScreenHeaderYourTeam,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.more_horiz,
              ),
            ),
          ],
        ),
        const SizedBox(height: Constants.defaultPadding),
        Responsive(
          mobile: const TeamMemberSmallCircleRow(),
          tablet: const TeamMemberCardInfoGridView(),
          desktop: TeamMemberCardInfoGridView(
            childAspectRatio:
                MediaQuery.of(context).size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class TeamMemberCardInfoGridView extends StatelessWidget {
  const TeamMemberCardInfoGridView({
    Key? key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserCache>(
      builder: (context, cache, child) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: Constants.defaultPadding,
            mainAxisSpacing: Constants.defaultPadding,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: min(8, cache.items.length),
          itemBuilder: (context, index) => PersonCardInfo(cache.items[index]),
        );
      },
    );
  }
}

class TeamMemberSmallCircleRow extends StatelessWidget {
  const TeamMemberSmallCircleRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<TeamsCache>(
        builder: (context, cache, child) => Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.defaultPadding / 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List<Widget>.generate(
                  cache.items.length + 1,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding / 2,
                    ),
                    child: index == 0
                        ? Consumer<UserState>(
                            builder: (context, userstate, child) =>
                                AddMoreTeamsButton(
                              cache,
                              userstate: userstate,
                            ),
                          )
                        : TeamDisplay(cache.items[index - 1]),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class TeamDisplay extends CircleStoryAvatar {
  final TeamContent team;

  TeamDisplay(
    this.team, {
    Key? key,
  }) : super(
          key: key,
          label: team.title,
          navigateTo: team.navigateTo,
          display: team.icon,
        );
}

class AddMoreTeamsButton extends CircleStoryAvatar {
  final TeamsCache cache;
  final UserState? userstate;

  AddMoreTeamsButton(
    this.cache, {
    this.userstate,
    Key? key,
  }) : super(
          key: key,
          label: Language.makeNewButton,
          navigateTo: (BuildContext context) {
            String? userAuthId = AuthApi.activeUser;

            if (userAuthId == null) {
              if (GlobalKeys.rootScaffoldMessengerKey.currentState != null) {
                GlobalKeys.rootScaffoldMessengerKey.currentState!
                    .showSnackBar(SnackBar(
                  content: const Text(Language.userstateError),
                  action: SnackBarAction(
                    label: Language.reloginButton,
                    onPressed: () {
                      if (userstate == null) return;

                      userstate.logout();
                    },
                  ),
                ));
              }
              return;
            }

            TeamContent(
              title: '',
              caption: '',
              users: [userAuthId],
              private: true,
              picture: Constants.defaultTeamPicture,
              id: '${cache.items.length}-${DateTime.now().toString()}',
              createdOn: DateTime.now(),
              lastLogin: DateTime.now(),
            ).navigateToEditor(context);
          },
          display: const Icon(Icons.add),
        );
}
