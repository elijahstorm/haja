import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:haja/controllers/menu_controller.dart';
import 'package:haja/responsive.dart';
import 'package:haja/display/pages/main/components/bottom_nav.dart';
import 'package:haja/display/pages/main/components/side_menu.dart';
import 'package:haja/display/pages/main/components/navbar_holder.dart';

import 'package:haja/display/screens/calendar/screen.dart';
import 'package:haja/display/screens/stats/screen.dart';
import 'package:haja/display/screens/teams/screen.dart';
import 'package:haja/display/screens/notification/screen.dart';
import 'package:haja/display/screens/profile/screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ScreenManagerState createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<MainScreen> {
  ValueNotifier<String> _stateIndexNotifier = ValueNotifier('Dashboard');

  final int _defaultScreen = 2;
  final List<NavbarDataHolder> _navbarStates = [
    NavbarDataHolder(
      name: StatsScreen.screenName,
      child: const StatsScreen(),
      icon: Icons.home,
      title: 'Home',
      color: (context) => Theme.of(context).colorScheme.secondary,
    ),
    NavbarDataHolder(
      name: TeamsScreen.screenName,
      child: const TeamsScreen(),
      icon: Icons.group,
      title: 'Teams',
      color: (context) => Colors.purple,
    ),
    NavbarDataHolder(
      name: CalendarScreen.screenName,
      child: const CalendarScreen(),
      icon: Icons.event_available,
      title: 'Calendar',
      color: (context) => Theme.of(context).primaryColor,
    ),
    NavbarDataHolder(
      name: NotificationScreen.screenName,
      child: const NotificationScreen(),
      icon: Icons.favorite_border,
      title: 'Likes',
      color: (context) => Colors.pink,
    ),
    NavbarDataHolder(
      name: ProfileScreen.screenName,
      child: const ProfileScreen(),
      icon: Icons.person,
      title: 'Profile',
      color: (context) => Colors.teal,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _stateIndexNotifier = ValueNotifier(_navbarStates[_defaultScreen].name);
  }

  Widget _decideInteriorBody() {
    for (int i = 0; i < _navbarStates.length; i++) {
      if (_navbarStates[i].name == _stateIndexNotifier.value) {
        return _navbarStates[i].child;
      }
    }

    return _navbarStates[_defaultScreen].child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      bottomNavigationBar: Responsive.isDesktop(context)
          ? null
          : HajaSalomonNavbar(
              stateIndex: _stateIndexNotifier,
              navbarStates: _navbarStates,
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            Expanded(
              child: SideMenu(
                stateIndex: _stateIndexNotifier,
                navbarStates: _navbarStates,
              ),
            ),
          Expanded(
            flex: 5,
            child: ValueListenableBuilder<String>(
              valueListenable: _stateIndexNotifier,
              builder: (context, value, child) {
                return _decideInteriorBody();
              },
            ),
          ),
        ],
      ),
    );
  }
}
