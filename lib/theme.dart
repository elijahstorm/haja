import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

import 'package:haja/constants.dart';

class ThemeSwitcher extends StatelessWidget {
  static bool darkModeEnabled = false;

  const ThemeSwitcher({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (BuildContext context, Store<AppState> store) {
        final state = store.state;
        ThemeSwitcher.darkModeEnabled = state.enableDarkMode;
        return DayNightSwitcher(
          isDarkModeEnabled: state.enableDarkMode,
          onStateChanged: (isDarkModeEnabled) => store.dispatch(
            UpdateDarkMode(enable: !state.enableDarkMode),
          ),
        );
      },
    );
  }
}

class Themes {
  static get isDark {
    return ThemeSwitcher.darkModeEnabled;
  }

  static Future<StoreProvider<AppState>> init(Widget mainApp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return StoreProvider<AppState>(
      store: Store<AppState>(
        reducer,
        distinct: true,
        initialState: AppState(
          enableDarkMode: prefs.getBool('darkMode') ?? false,
        ),
      ),
      child: mainApp,
    );
  }

  static ThemeData mainLightThem(BuildContext context) =>
      ThemeData.light().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Constants.textColorLight),
        colorScheme: ThemeData.dark()
            .colorScheme
            .copyWith(secondary: Constants.secondaryColorLight),
        cardColor: Constants.cardColorLight,
        scaffoldBackgroundColor: Constants.bgColorLight,
        primaryColor: Constants.primaryColorLight,
        buttonTheme: const ButtonThemeData(
          buttonColor: Constants.cardColorLight,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.primary,
        ),
      );
  static ThemeData mainDarkThem(BuildContext context) =>
      ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Constants.textColorDark),
        colorScheme: ThemeData.dark()
            .colorScheme
            .copyWith(secondary: Constants.secondaryColorDark),
        cardColor: Constants.cardColorDark,
        scaffoldBackgroundColor: Constants.bgColorDark,
        primaryColor: Constants.primaryColorDark,
        buttonTheme: const ButtonThemeData(
          buttonColor: Constants.cardColorDark,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.primary,
        ),
      );
}

// redux
class AppState {
  AppState({required this.enableDarkMode});
  bool enableDarkMode;
}

class UpdateDarkMode {
  final bool enable;

  UpdateDarkMode({required this.enable}) {
    _persistTheme();
  }

  void _persistTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', enable);
  }
}

AppState reducer(AppState state, dynamic action) {
  if (action is UpdateDarkMode) {
    return AppState(
      enableDarkMode: action.enable,
    );
  }

  return state;
}
