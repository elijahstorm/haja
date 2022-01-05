import 'package:flutter/material.dart';

import 'package:haja/display/components/teams/our_team_members.dart';
import 'package:haja/display/components/calendar/calendar.dart';

class CalendarTopbar extends StatelessWidget {
  const CalendarTopbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: const [
          TeamMemberSmallCircleRow(),
          Calendar(),
        ],
      );
}
