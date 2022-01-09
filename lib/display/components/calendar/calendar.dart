import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'package:haja/content/todo/cache.dart';
import 'package:haja/content/todo/content.dart';
import 'package:haja/display/components/calendar/focused_date.dart';
import 'package:haja/constants.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.week;

  final calendarBoxWidth = 40.0;
  static const multipleEventCirclePadding = 10.0;
  final multipleEventCircleSize = 16.0, eventLabelTextSize = 16.0;

  Widget eventCircleBuilder(
    BuildContext context,
    TodoContent event, {
    BlendMode blend = BlendMode.multiply,
    String? color,
  }) =>
      Container(
        width: multipleEventCircleSize,
        height: multipleEventCircleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          backgroundBlendMode: blend,
          color: Constants.fromHex(color ?? event.color) ??
              Theme.of(context).primaryColor,
        ),
      );

  Widget allFinishedBuilder(BuildContext context) => Icon(
        Icons.check,
        color: Constants.textColorDark,
        size: eventLabelTextSize,
      );

  static const List<EdgeInsets> smallEventPaddings = [
    EdgeInsets.zero,
    EdgeInsets.only(
      right: multipleEventCirclePadding * 2,
    ),
    EdgeInsets.only(
      left: multipleEventCirclePadding * 2,
    ),
    EdgeInsets.zero,
  ];

  Widget eventsStackBuilder(
    BuildContext context,
    List<TodoContent> events,
  ) =>
      Padding(
        padding: events.length == 2
            ? EdgeInsets.only(left: multipleEventCircleSize / 2)
            : EdgeInsets.zero,
        child: Stack(
          children: List.generate(
            min(events.length, 4) + 2,
            (index) => Center(
              child: index == 0
                  ? eventCircleBuilder(
                      context,
                      events[index],
                      color: 'ffffff',
                      blend: BlendMode.plus,
                    )
                  : index == events.length + 1 || index == 5
                      ? allFinished(events)
                          ? Padding(
                              padding: events.length == 2
                                  ? EdgeInsets.only(
                                      right: multipleEventCircleSize / 2)
                                  : EdgeInsets.zero,
                              child: allFinishedBuilder(context),
                            )
                          : isSmallEventsStack(events)
                              ? Container()
                              : Text(
                                  events.length <= 9
                                      ? events.length.toString()
                                      : '9+',
                                  style: TextStyle(
                                    color: Constants.textColorDark,
                                    fontSize: eventLabelTextSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                      : Container(
                          padding: isSmallEventsStack(events)
                              ? smallEventPaddings[index - 1]
                              : largeEventPaddings[index - 1],
                          child: eventCircleBuilder(context, events[index - 1]),
                        ),
            ),
          ),
        ),
      );

  static const List<EdgeInsets> largeEventPaddings = [
    EdgeInsets.only(
      bottom: multipleEventCirclePadding,
      right: multipleEventCirclePadding,
    ),
    EdgeInsets.only(
      bottom: multipleEventCirclePadding,
      left: multipleEventCirclePadding,
    ),
    EdgeInsets.only(
      top: multipleEventCirclePadding,
      right: multipleEventCirclePadding,
    ),
    EdgeInsets.only(
      top: multipleEventCirclePadding,
      left: multipleEventCirclePadding,
    ),
    EdgeInsets.zero,
  ];

  bool allFinished(List<TodoContent> events) {
    for (var e in events) {
      if (e.status == TodoContent.unfinishedStatus) {
        return false;
      }
    }
    return events.isNotEmpty;
  }

  bool isSmallEventsStack(List<TodoContent> events) => events.length <= 3;

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusedDate>(
      builder: (context, focusedDate, child) {
        return Consumer<TodoCache>(
          builder: (context, cache, child) {
            return TableCalendar(
              firstDay: Constants.firstDay,
              lastDay: Constants.lastDay,
              focusedDay: focusedDate.day,
              calendarFormat: _calendarFormat,
              holidayPredicate: (date) {
                return (date.month == 1 && date.day == 1) || // New Year's Day
                    (date.month == 3 && date.day == 17) || // St. Patrick's Day
                    (date.month == 3 && date.day == 30) || // Good Friday
                    (date.month == 4 && date.day == 17) || // Easter [American]
                    (date.month == 5 && date.day == 7) || // May Day
                    (date.month == 5 &&
                        date.day == 15) || // Korean Independance Day
                    (date.month == 7 && date.day == 4) || // Independance Day
                    (date.month == 10 && date.day == 31) || // Halloween
                    (date.month == 12 && date.day == 25); // Christmas Day
              },
              eventLoader: (date) {
                return cache.filterByDates(
                    date, date.add(const Duration(days: 1)));
              },
              selectedDayPredicate: (date) {
                return isSameDay(focusedDate.day, date);
              },
              onDaySelected: (selectedDay, focusedDay) {
                focusedDate.day = focusedDay;
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                  if (format == CalendarFormat.week) {
                    focusedDate.span = TimeSpan.day;
                  } else if (format == CalendarFormat.twoWeeks) {
                    focusedDate.span = TimeSpan.day;
                  } else if (format == CalendarFormat.month) {
                    focusedDate.span = TimeSpan.day;
                  }
                });
              },
              onPageChanged: (focusedDay) {
                focusedDate.day = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, date) {
                  final text = DateFormat.E().format(date);

                  return Center(
                    child: Text(
                      text.toLowerCase(),
                    ),
                  );
                },
                headerTitleBuilder: (context, date) {
                  String text = '';

                  switch (date.month) {
                    case 1:
                      text = 'january';
                      break;
                    case 2:
                      text = 'february';
                      break;
                    case 3:
                      text = 'march';
                      break;
                    case 4:
                      text = 'april';
                      break;
                    case 5:
                      text = 'may';
                      break;
                    case 6:
                      text = 'june';
                      break;
                    case 7:
                      text = 'july';
                      break;
                    case 8:
                      text = 'august';
                      break;
                    case 9:
                      text = 'september';
                      break;
                    case 10:
                      text = 'october';
                      break;
                    case 11:
                      text = 'november';
                      break;
                    case 12:
                      text = 'december';
                      break;
                  }

                  return Text(
                    text.toLowerCase(),
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
                todayBuilder: (context, date, focusedDay) => Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).iconTheme.color ??
                              Theme.of(context).primaryColor.withOpacity(.3),
                        ),
                      ),
                    ),
                    width: calendarBoxWidth - 10,
                    height: calendarBoxWidth - 10,
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                holidayBuilder: (context, date, focusedDay) {
                  return Opacity(
                    opacity: date.month != focusedDay.month ? .6 : 1,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        width: calendarBoxWidth - 10,
                        height: calendarBoxWidth - 10,
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                selectedBuilder: (context, date, focusedDay) => Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    width: calendarBoxWidth - 10,
                    height: calendarBoxWidth - 10,
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                markerBuilder: (context, date, List<TodoContent> events) {
                  return Center(
                    child: events.isNotEmpty
                        ? eventsStackBuilder(context, events)
                        : Container(),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
