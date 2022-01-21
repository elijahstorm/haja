import 'package:flutter/material.dart';
import 'package:haja/language/settings_keys.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'package:haja/display/components/calendar/focused_date.dart';
import 'package:haja/content/todo/cache.dart';
import 'package:haja/content/todo/content.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';
import 'package:haja/display/components/calendar/events_builders.dart';

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

  Widget allFinishedBuilder(BuildContext context) => const Icon(
        Icons.check,
        color: Constants.textColorDark,
      );

  bool allFinished(List<TodoContent> events) {
    for (var e in events) {
      if (e.status == TodoContent.unfinishedStatus) {
        return false;
      }
    }
    return events.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) => Consumer<FocusedDate>(
        builder: (context, focusedDate, child) => Consumer<TodoCache>(
          builder: (context, cache, child) => SettingsKeyValues.buildWhenReady(
            key: SettingsKeyValues.settingsCalendarEventType,
            isBool: true,
            defaultValue: true,
            builder: (isBlockyCalendarStyle) => TableCalendar(
              firstDay: Constants.firstDay,
              lastDay: Constants.lastDay,
              focusedDay: focusedDate.day,
              calendarFormat: _calendarFormat,
              // pageJumpingEnabled: true,
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'month',
                CalendarFormat.twoWeeks: 'week',
                CalendarFormat.week: 'day',
              },
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
                    focusedDate.span = TimeSpan.week;
                  } else if (format == CalendarFormat.month) {
                    focusedDate.span = TimeSpan.month;
                  }
                });
              },
              onPageChanged: (focusedDay) {
                focusedDate.day = focusedDay;
              },
              headerStyle: const HeaderStyle(
                formatButtonShowsNext: false,
                leftChevronPadding: EdgeInsets.zero,
                rightChevronPadding: EdgeInsets.zero,
              ),
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
                      text = Language.januaryName;
                      break;
                    case 2:
                      text = Language.februaryName;
                      break;
                    case 3:
                      text = Language.marchName;
                      break;
                    case 4:
                      text = Language.aprilName;
                      break;
                    case 5:
                      text = Language.mayName;
                      break;
                    case 6:
                      text = Language.juneName;
                      break;
                    case 7:
                      text = Language.julyName;
                      break;
                    case 8:
                      text = Language.augustName;
                      break;
                    case 9:
                      text = Language.septemberName;
                      break;
                    case 10:
                      text = Language.octoberName;
                      break;
                    case 11:
                      text = Language.novemberName;
                      break;
                    case 12:
                      text = Language.decemberName;
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
                markerBuilder: (context, date, List<TodoContent> events) =>
                    Center(
                  child: events.isNotEmpty
                      ? isBlockyCalendarStyle
                          ? EventsHouseBuilder(
                              events,
                              date,
                              isSelected: isSameDay(focusedDate.day, date),
                            )
                          : EventsFlowerBuilder(events)
                      : Container(),
                ),
              ),
            ),
          ),
        ),
      );
}
