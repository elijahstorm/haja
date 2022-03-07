import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:day_night_switcher/day_night_switcher.dart';

import 'package:haja/language/constants.dart';

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

  static const TextStyle englishFont = TextStyle(
    fontFamily: 'Roboto',
  );
  static TextTheme englishFontFamily = TextTheme(
    displayLarge: englishFont,
    displayMedium: englishFont,
    displaySmall: englishFont,
    headlineLarge: englishFont,
    headlineMedium: englishFont,
    headlineSmall: englishFont,
    titleLarge: englishFont,
    titleMedium: englishFont,
    titleSmall: englishFont,
    bodyLarge: englishFont,
    bodyMedium: englishFont,
    bodySmall: englishFont,
    labelLarge: englishFont,
    labelMedium: englishFont,
    labelSmall: englishFont,
    headline1: englishFont,
  );

  static ThemeData mainLightThem(BuildContext context) => ThemeData(
        primaryColor: Constants.primaryColorLight,
        scaffoldBackgroundColor: Constants.bgColorLight,
        cardColor: Constants.cardColorLight,
        canvasColor: Constants.canvasColorLight,
        buttonTheme: const ButtonThemeData(
          buttonColor: Constants.cardColorLight,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.primary,
        ),
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        snackBarTheme: const SnackBarThemeData(
          actionTextColor: Constants.primaryColorLight,
          disabledActionTextColor: Constants.cardColorDark,
          backgroundColor: Constants.snackbarBackground,
          elevation: 2,
          behavior: SnackBarBehavior.floating,
          contentTextStyle: TextStyle(
            color: Constants.snackbarText,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      );
  static ThemeData mainDarkThem(BuildContext context) => ThemeData(
        primaryColor: Constants.primaryColorDark,
        scaffoldBackgroundColor: Constants.bgColorDark,
        cardColor: Constants.cardColorDark,
        canvasColor: Constants.canvasColorDark,
        buttonTheme: const ButtonThemeData(
          buttonColor: Constants.cardColorDark,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.primary,
        ),
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        snackBarTheme: const SnackBarThemeData(
          actionTextColor: Constants.primaryColorLight,
          disabledActionTextColor: Constants.cardColorDark,
          backgroundColor: Constants.snackbarBackground,
          elevation: 2,
          behavior: SnackBarBehavior.floating,
          contentTextStyle: TextStyle(
            color: Constants.snackbarText,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
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
