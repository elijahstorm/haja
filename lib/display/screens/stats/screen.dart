import 'package:flutter/material.dart';
import 'package:haja/language/language.dart';
import 'package:provider/provider.dart';

import 'package:haja/display/components/widgets/responsive_screen.dart';

import 'package:haja/content/dashboard/cache.dart';

import 'package:haja/display/components/charts/panel_left_page.dart';
import 'package:haja/display/components/charts/panel_right_page.dart';

class StatsScreen extends StatelessWidget {
  static const screenName = 'stats';

  const StatsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => DashboardCache()),
        ],
        child: const ResponsiveScreen.thirds(
          header: Language.appNavBarTitlesHome,
          primaryContent: PanelRightPage(),
          secondaryContent: PanelLeftPage(),
        ),
      ),
    );
  }
}
