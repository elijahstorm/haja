import 'dart:math';
import 'package:flutter/material.dart';
import 'package:haja/display/components/teams/person_card_info.dart';
import 'package:provider/provider.dart';

import 'package:haja/responsive.dart';
import 'package:haja/content/teams/cache.dart';
import 'package:haja/content/teams/content.dart';
import 'package:haja/content/users/cache.dart';
import 'package:haja/display/components/widgets/avatars.dart'
    show CircleStoryAvatar;

import 'package:haja/constants.dart';

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
              'Your Teams',
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
        builder: (context, cache, child) => SizedBox(
          height: Constants.defaultPadding * 2 + 23,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cache.items.length + 1,
            itemExtent: Constants.defaultPadding * 4,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.defaultPadding / 4,
              ),
              child: index == 0
                  ? AddMoreTeamsButton(cache)
                  : TeamDisplay(cache.items[index - 1]),
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

  AddMoreTeamsButton(
    this.cache, {
    Key? key,
  }) : super(
          key: key,
          label: 'New',
          navigateTo: (BuildContext context) {
            var team = TeamContent(
              title: '${cache.items.length}',
              caption: 'caption for ${cache.items.length}',
              users: [],
              private: false,
              id: '${cache.items.length}',
              createdOn: DateTime.now(),
              lastLogin: DateTime.now(),
            );
            cache.add(team);
            team.upload();
          },
          display: const Icon(Icons.add),
        );
}
