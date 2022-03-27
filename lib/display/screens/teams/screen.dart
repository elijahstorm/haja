import 'package:flutter/material.dart';
import 'package:haja/language/language.dart';
import 'package:provider/provider.dart';

import 'package:haja/display/components/widgets/responsive_screen.dart';

import 'package:haja/content/teams/cache.dart';

import 'package:haja/display/components/teams/team_vertical_scroll.dart';

class TeamsScreen extends StatelessWidget {
  static const screenName = 'store';

  const TeamsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TeamsCache.activeUserTeams(),
          ),
        ],
        child: const ResponsiveScreen(
          header: Language.appNavBarTitlesTeams,
          primaryContent: TeamContentVerticalList(),
        ),
      ),
    );
  }
}
