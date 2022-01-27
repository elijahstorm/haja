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
            const Text(Language.teamCacheListHeader),
            Consumer<TeamsCache>(
              builder: (context, cache, child) => Column(
                children: List.generate(
                  cache.items.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Constants.defaultPadding,
                    ),
                    child: TeamCard(cache.items[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}