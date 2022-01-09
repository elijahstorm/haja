import 'package:flutter/foundation.dart';

enum TimeSpan {
  day,
  week,
  month,
  year,
}

extension AlertIconExtension on TimeSpan {
  int span() {
    switch (this) {
      case TimeSpan.day:
        return 1;
      case TimeSpan.week:
        return 7;
      case TimeSpan.month:
        return 30;
      case TimeSpan.year:
        return 365;
      default:
        return 1;
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
    return _trackedDay;
  }

  DateTime get end {
    return _trackedDay.add(Duration(days: timeSpan.span()));
  }
}
