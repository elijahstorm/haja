import 'package:flutter/material.dart';
import 'package:haja/language/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:haja/display/components/animations/loading.dart';

class SettingsKeyValues {
  static const String settingsCalendarEventType = 'calendarEventType';
  static const String settingsNotosAlarm = 'notosAlarm';
  static const String appIntroHasBeenSeen = 'appIntroSeen';
  static const String darkMode = 'darkMode';

  static void removeAll(SharedPreferences prefs) {
    prefs.remove(settingsCalendarEventType);
    prefs.remove(settingsNotosAlarm);
    prefs.remove(appIntroHasBeenSeen);
    prefs.remove(darkMode);
  }

  static Widget buildWhenReady({
    required String key,
    required Widget Function(dynamic) builder,
    required dynamic defaultValue,
    Widget loading = const Loading(),
    Widget error = const Text(Language.settingsDataSearchHasFailed),
    isBool = false,
    isInt = false,
    isDouble = false,
  }) =>
      FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading;
          }

          if (snapshot.hasError ||
              (isBool && isDouble) ||
              (isBool && isInt) ||
              (isInt && isDouble)) {
            return error;
          }

          if (isBool) {
            return builder(snapshot.data!.getBool(key) ?? defaultValue);
          }
          if (isInt) {
            return builder(snapshot.data!.getInt(key) ?? defaultValue);
          }
          if (isDouble) {
            return builder(snapshot.data!.getDouble(key) ?? defaultValue);
          }

          return error;
        },
      );

  static Future<void> set({
    required String key,
    required dynamic value,
    isBool = false,
    isInt = false,
    isDouble = false,
  }) async {
    assert(isBool || isInt || isDouble);

    var prefs = await SharedPreferences.getInstance();

    if (isBool) {
      prefs.setBool(key, value);
    } else if (isInt) {
      prefs.setInt(key, value);
    } else if (isDouble) {
      prefs.setDouble(key, value);
    }
  }
}
