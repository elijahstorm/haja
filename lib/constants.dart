import 'dart:math';
import 'package:flutter/material.dart';

class Constants {
  static const Color primaryColorLight = Color(0xFF1E9AFE);
  static const Color secondaryColorLight = Color(0xFF60dfcd);
  static const Color cardColorLight = Color(0xFFE2F2FF);
  static const Color bgColorLight = Color(0xFFf8f9fa);
  static const Color textColorLight = Color(0xFF000000);

  static const Color primaryColorDark = Color(0xFF2697FF);
  static const Color secondaryColorDark = Color(0xFF2697FF);
  static const Color cardColorDark = Color(0xFF0F3960);
  static const Color bgColorDark = Color(0xFF061A40);
  static const Color textColorDark = Color(0xFFFFFFFF);

  static const Color lightShimmerLowlight = Color(0xFFF5F5F5);
  static const Color lightShimmerHighlight = Color(0xFFE0E0E0);
  static const Color lightShimmerWidget = Colors.white;

  static const Color darkShimmerLowlight = Color(0xFF424242);
  static const Color darkShimmerHighlight = Color(0xFF757575);
  static const Color darkShimmerWidget = Colors.black;

  static const double defaultPadding = 16.0;
  static const double defaultCardRadius = 15.0;
  static const double defaultBorderRadiusSmall = 6.0;

  static const String defaultHeaderTitle = 'Haja: Do Together';

  static const String wavyThemeBackground = 'assets/icons/wavy_background.svg';
  static const String wavyThemeBackgroundTempWrong =
      'assets/icons/wavy_background.png';
  static const String buttonBackgroundSmall =
      'assets/images/button-bg-small.png';
  static const String placeholderUserIcon =
      'assets/images/placeholder_user.png';
  static const String liveSvgs = 'https://avatars.dicebear.com/api/avataaars/';
  static const String storeItemsSvgs =
      'https://avatars.dicebear.com/api/gridy/';
  static const String trainingDataSvgs =
      'https://avatars.dicebear.com/api/jdenticon/';

  static const String appName = 'Haja';
  static const String appTitleDesc = 'Do Together';
  static const String logoAsset = 'assets/images/logo.png';
  static const String imageAssetPath = 'assets/images/';
  static const String logoTag = 'haja.logo';
  static const String titleTag = 'haja.title';

  static DateTime firstDay = DateTime.utc(2021, 1, 1);
  static DateTime lastDay = DateTime.utc(2041, 3, 1);

  static Color? fromHex(String hexString) {
    if (hexString == '') return null;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String toHex(Color color, {bool leadingHashSign = false}) =>
      '${leadingHashSign ? '#' : ''}'
      '${color.alpha.toRadixString(16).padLeft(2, '0')}'
      '${color.red.toRadixString(16).padLeft(2, '0')}'
      '${color.green.toRadixString(16).padLeft(2, '0')}'
      '${color.blue.toRadixString(16).padLeft(2, '0')}';

  static List<String> toStringList(List<dynamic>? list) {
    var change = list ?? [];
    return List<String>.generate(
        change.length, (index) => change[index].toString());
  }

  static String createUniqueId() {
    const int lettersLength = 8;
    String randStr = '';

    for (int i = 0; i < lettersLength; i++) {
      randStr += 'abcdefghijklmnopqrstuvwxyz'[Random().nextInt(26)];
    }

    return '$randStr.${DateTime.now().toString()}';
  }

  static String countableWithTrailingS(
    int countable,
    String output, {
    bool forceEs = false,
  }) {
    return '$countable $output${countable != 1 ? '${forceEs ? 'e' : ''}s' : ''}';
  }

  static String timeSinceDate(DateTime date) {
    Duration timeSince = DateTime.now().difference(date);
    String output = 'just now';

    if (timeSince.inSeconds < 0) return output;

    if (timeSince.inDays == 0) {
      if (timeSince.inHours == 0) {
        if (timeSince.inMinutes == 0) {
          output = timeSince.inSeconds.toString() + ' second';
          if (timeSince.inSeconds > 1) output += 's';
          output += ' ago';
        } else {
          output = timeSince.inMinutes.toString() + ' minute';
          if (timeSince.inMinutes > 1) output += 's';
          output += ' ago';
        }
      } else {
        output = timeSince.inHours.toString() + ' hour';
        if (timeSince.inHours > 1) output += 's';
        output += ' ago';
      }
    } else {
      if (timeSince.inDays >= 365) {
        int years = timeSince.inDays ~/ 365;
        output = years.toString() + ' year';
        if (years > 1) output += 's';
        output += ' ago';
      } else if (timeSince.inDays >= 29) {
        int months = timeSince.inDays ~/ 30;
        output = months.toString() + ' month';
        if (months > 1) output += 's';
        output += ' ago';
      } else {
        output = timeSince.inDays.toString() + ' day';
        if (timeSince.inDays > 1) output += 's';
        output += ' ago';
      }
    }

    return output;
  }
}
