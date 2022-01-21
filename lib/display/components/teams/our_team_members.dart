import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:haja/controllers/responsive.dart';
import 'package:haja/language/language.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/content/users/cache.dart';

import 'package:haja/display/components/teams/person_card_info.dart';
import 'package:haja/display/components/teams/team_avatars.dart';

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
