import 'package:flutter/material.dart';
import 'package:haja/language/language.dart';
import 'package:provider/provider.dart';

import 'package:haja/display/components/widgets/responsive_screen.dart';

import 'package:haja/content/notifications/cache.dart';
import 'package:haja/content/users/cache.dart';
import 'package:haja/firebase/auth.dart';

import 'package:haja/display/components/teams/recommended_friends.dart';
import 'package:haja/display/components/notifications/recent_notifications.dart';

class NotificationScreen extends StatelessWidget {
  static const screenName = 'notification';

  const NotificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NotificationCache()),
          ChangeNotifierProvider(
              create: (context) =>
                  UserCache.nonFriends(AuthApi.activeUser ?? '')),
        ],
        child: const ResponsiveScreen(
          header: Language.appNavBarTitlesNotos,
          primaryContent: RecentNotifications(),
          sideContent: RecommendedFriends(),
        ),
      ),
    );
  }
}
