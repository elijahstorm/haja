import 'package:flutter/foundation.dart';

enum TimeSpan {
  day,
  week,
  month,
  year,
}

extension AlertIconExtension on TimeSpan {
  int span(DateTime date) {
    switch (this) {
      case TimeSpan.day:
        return 1;
      case TimeSpan.week:
        return 7;
      case TimeSpan.month:
        return DateTime.utc(date.year, date.month + 1)
            .difference(
              DateTime.utc(date.year, date.month),
            )
            .inDays;
      case TimeSpan.year:
        return DateTime.utc(date.year + 1)
            .difference(
              DateTime.utc(date.year),
            )
            .inDays;
      default:
        return 1;
    }
  }

  DateTime startDay(DateTime date) {
    switch (this) {
      case TimeSpan.day:
        return date;
      case TimeSpan.week:
        return DateTime.utc(
          date.year,
          date.month,
          date.day - date.weekday % 7,
        );
      case TimeSpan.month:
        return DateTime.utc(date.year, date.month);
      case TimeSpan.year:
        return DateTime.utc(date.year);
      default:
        return date;
    }
  }
}

class FocusedDate extends ChangeNotifier {
  DateTime _trackedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  TimeSpan timeSpan = TimeSpan.day;

  DateTime get day {
    return _trackedDay;
  }

  set day(DateTime date) {
    _trackedDay = date;
    notifyListeners();
  }

  DateTime get time {
    var now = DateTime.now();
    return _trackedDay.add(Duration(
      hours: now.hour,
      minutes: now.minute,
      seconds: now.second,
    ));
  }

  set span(TimeSpan span) {
    timeSpan = span;
    notifyListeners();
  }

  DateTime get start {
    return timeSpan.startDay(_trackedDay);
  }

  DateTime get end {
    return timeSpan
        .startDay(_trackedDay)
        .add(Duration(days: timeSpan.span(_trackedDay)));
  }
}
