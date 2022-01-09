import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:haja/display/components/widgets/responsive_screen.dart';

import 'package:haja/display/components/calendar/calendar.dart';
import 'package:haja/display/components/calendar/focused_date.dart';
import 'package:haja/display/components/calendar/todo_viewer.dart';
import 'package:haja/display/components/teams/our_team_members.dart';

import 'package:haja/content/notifications/cache.dart';
import 'package:haja/display/components/notifications/friends_recent.dart';

import 'package:haja/content/todo/cache.dart';
import 'package:haja/content/teams/cache.dart';

class CalendarScreen extends StatelessWidget {
  static const screenName = 'calendar';

  const CalendarScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FocusedDate(),
        ),
        ChangeNotifierProvider(
          create: (context) => TodoCache.recent(),
        ),
        ChangeNotifierProvider(
          create: (context) => TeamsCache.activeUserTeams(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationCache.friends(),
        ),
      ],
      child: const ResponsiveScreen.landscapeFriendly(
        header: 'Haja: Do Together',
        primaryContent: Calendar(),
        mobileHeaderContent: TeamMemberSmallCircleRow(),
        secondaryContent: TodoViewer(),
        sideContent: RecentFriendActivities(),
      ),
    );
  }
}
