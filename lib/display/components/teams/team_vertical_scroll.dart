import 'package:flutter/material.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';
import 'package:haja/content/teams/cache.dart';
import 'package:haja/display/components/teams/team_card.dart';
import 'package:provider/provider.dart';

class TeamContentVerticalList extends StatelessWidget {
  const TeamContentVerticalList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              Language.teamCacheListHeader,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Consumer<TeamsCache>(
              builder: (context, cache, child) {
                if (cache.items.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Constants.defaultPadding,
                        ),
                        child: Image.asset(Constants.noTeamsPlaceholder),
                      ),
                      const Text(
                        Language.noTeamsPlaceholder,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(
                    top: Constants.defaultPadding,
                  ),
                  child: Column(
                    children: List.generate(
                      cache.items.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: Constants.defaultPadding,
                        ),
                        child: TeamCard(cache.items[index]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
}
