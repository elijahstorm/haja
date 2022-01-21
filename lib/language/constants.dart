import 'dart:math';
import 'package:flutter/material.dart';

class Constants {
  static const Color primaryColorLight = Color(0xFF1E9AFE);
  static const Color secondaryColorLight = Color(0xFF60dfcd);
  static const Color cardColorLight = Color(0xFFE2F2FF);
  static const Color bgColorLight = Color(0xFFf8f9fa);
  static const Color textColorLight = Color(0xFF000000);
  static const Color canvasColorLight = Color(0xFFDBDBDB);

  static const Color primaryColorDark = Color(0xFF2697FF);
  static const Color secondaryColorDark = Color(0xFF2697FF);
  static const Color cardColorDark = Color(0xFF0F3960);
  static const Color bgColorDark = Color(0xFF061A40);
  static const Color textColorDark = Color(0xFFFFFFFF);
  static const Color canvasColorDark = Color(0xFF7E7E7E);

  static const Color lightShimmerLowlight = Color(0xFFF5F5F5);
  static const Color lightShimmerHighlight = Color(0xFFE0E0E0);
  static const Color lightShimmerWidget = Colors.white;

  static const Color darkShimmerLowlight = Color(0xFF424242);
  static const Color darkShimmerHighlight = Color(0xFF757575);
  static const Color darkShimmerWidget = Colors.black;

  static const Color snackbarBackground = Color(0xFF323232);
  static const Color snackbarText = Color(0xFFCFCFCF);

  static const double defaultPadding = 24.0;
  static const double defaultCardRadius = 15.0;
  static const double textSizeRegular = 16.0;
  static const double textSizeTitle = 28.0;
  static const double defaultBorderRadiusSmall = 6.0;
  static const double defaultBorderRadiusMedium = 14.0;
  static const double defaultBorderRadiusLarge = 18.0;

  static const String storageUrlPrefix =
      'https://firebasestorage.googleapis.com/v0/b/haja-project.appspot.com/o/';
  static const String defaultTeamPicture =
      'users%2FZbDWV5123FadwDAEZnH2K1t4kRf1%2Fprofile.png?alt=media&token=4e533a70-a670-493e-91b3-e7c31eb57ab9';
  static const String buttonBackgroundSmall =
      'assets/images/button-bg-small.png';
  static const String placeholderUserIcon =
      'assets/images/placeholder_user.png';
  static const String liveSvgs = 'https://avatars.dicebear.com/api/avataaars/';

  static const String logoAsset = 'assets/images/logo/haja_logo_full.png';
  static const String errorImage = 'assets/images/error.png';
  static const String imageAssetPath = 'assets/images/';

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
}
