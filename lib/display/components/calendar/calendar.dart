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
  final multipleEventCirclePadding = 8.0, multipleEventCircleSize = 15.0;

  Widget largeEventCircleBuilder(
    BuildContext context,
    TodoContent event,
  ) =>
      Container(
        width: multipleEventCircleSize,
        height: multipleEventCircleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).iconTheme.color!,
          ),
          color:
              Constants.fromHex(event.color) ?? Theme.of(context).primaryColor,
        ),
      );

  Widget allFinishedBuilder(
    BuildContext context,
    List<TodoContent> events,
  ) =>
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
        ),
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          Icons.check,
          color: Theme.of(context).scaffoldBackgroundColor,
          size: multipleEventCircleSize,
        ),
      );

  Widget sameDayEventBuilder(
    BuildContext context,
    List<TodoContent> events,
  ) =>
      Container();

  Widget smallEventStackBuilder(
    BuildContext context,
    List<TodoContent> events,
  ) =>
      Container(
        margin: const EdgeInsets.only(
            // top: 30.0,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            events.length,
            (index) => Container(
              margin: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Constants.fromHex(
                          events[events.length - index - 1].color) ??
                      Theme.of(context).primaryColor),
              width: calendarBoxWidth / 4,
            ),
          ),
        ),
      );

  Widget largeEventsStackBuilder(
    BuildContext context,
    List<TodoContent> events,
  ) =>
      Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              bottom: multipleEventCirclePadding,
            ),
            child: largeEventCircleBuilder(
              context,
              events[0],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              bottom: multipleEventCirclePadding,
              left: multipleEventCirclePadding,
            ),
            child: largeEventCircleBuilder(
              context,
              events[1],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: multipleEventCirclePadding,
            ),
            child: largeEventCircleBuilder(
              context,
              events[2],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: multipleEventCirclePadding,
              left: multipleEventCirclePadding,
            ),
            child: largeEventCircleBuilder(
              context,
              events[3],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              // TODO: Fix paddings to center content
              bottom: multipleEventCirclePadding / 2,
              left: multipleEventCirclePadding / 2,
            ),
            child: Text(
              // TODO: TEXT is not centered
              events.length <= 9 ? events.length.toString() : '9+',
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );

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
                    (date.month == 1 &&
                        date.day == 2) || // New Year Holiday [Scotland]
                    (date.month == 3 &&
                        date.day ==
                            17) || // St. Patrick's Day [Northern Ireland]
                    (date.month == 3 &&
                        date.day ==
                            19) || // St. Patrick's Day [Northern Ireland] (Observed)
                    (date.month == 3 && date.day == 30) || // Good Friday
                    (date.month == 4 &&
                        date.day ==
                            2) || // Easter Monday [England, Wales, Northern Ireland]
                    (date.month == 5 && date.day == 7) || // May Day
                    (date.month == 5 &&
                        date.day == 28) || // Spring Bank Holiday
                    (date.month == 7 &&
                        date.day ==
                            12) || // Battle of the Boyne [Northern Ireland]
                    (date.month == 8 &&
                        date.day == 6) || // Summer Bank Holiday [Scotland]
                    (date.month == 8 &&
                        date.day ==
                            27) || // Late Summer Bank Holiday [England, Wales, Northern Ireland]
                    (date.month == 11 &&
                        date.day == 30) || // St. Andrew's Day [Scotland]
                    (date.month == 12 && date.day == 25) || // Christmas Day
                    (date.month == 12 && date.day == 26); // Boxing Day
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
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  );
                },
                todayBuilder: (context, date, focusedDay) => Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            // color: Colors.grey,
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
                    child: allFinished(events)
                        ? allFinishedBuilder(context, events)
                        : isSmallEventsStack(events)
                            ? smallEventStackBuilder(context, events)
                            : largeEventsStackBuilder(context, events),
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
