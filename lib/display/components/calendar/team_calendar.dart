import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:haja/display/components/calendar/focused_date.dart';
import 'package:haja/display/components/calendar/calendar.dart';
import 'package:haja/display/components/calendar/todo.dart';
import 'package:haja/display/components/widgets/responsive_content.dart';
import 'package:haja/content/todo/cache.dart';

class TeamCalendar extends StatelessWidget {
  final String team; // TODO: A LOT and upload picture

  const TeamCalendar({
    required this.team,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => FocusedDate(),
          ),
          ChangeNotifierProvider(
            create: (context) => TodoCache.team(),
          ),
        ],
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: const ResponsiveContent.landscapeFriendly(
            primaryContent: Calendar(),
            secondaryContent: Todo(),
          ),
        ),
      );
}
