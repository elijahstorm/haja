import 'package:flutter/material.dart';
import 'package:haja/display/components/teams/horizontal_user_card.dart';
import 'package:haja/display/components/widgets/alerts.dart';
import 'package:provider/provider.dart';

import 'package:haja/controllers/responsive.dart';
import 'package:haja/language/language.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/content/users/cache.dart';

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
              onTap: () => AlertTextDialog.run(
                context,
                const AlertTextDialog(
                  alert: 'needs to be fixed',
                  subtext: 'OurTeamMembers',
                ),
              ),
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
  Widget build(BuildContext context) => Consumer<UserCache>(
        builder: (context, cache, child) => Column(
          children: List.generate(
            cache.items.length,
            (index) => HorizontalUserCard(
              cache.items[index],
            ),
          ),
        ),
      );
}
