import 'dart:math';
import 'package:flutter/material.dart';

class Constants {
  static const List<Color> todoColorOptions = [
    Color(0xFFffda1e),
    Color(0xFFf2a005),
    Color(0xFFf24503),
    Color(0xFFfe9ad2),
    Color(0xFF9d9bfe),
    Color(0xFF1f99fd),
    Color(0xFF7ac6ff),
    Color(0xFF60dfcd),
    Color(0xFF62ca9c),
  ];

  static const Color primaryColorLight = Color(0xFF1f99fd);
  static const Color secondaryColorLight = Color(0xFF60dfcd);
  static const Color cardColorLight = Color(0xFFE2F2FF);
  static const Color bgColorLight = Color(0xFFf8f9fa);
  static const Color textColorLight = Color(0xFF000000);
  static const Color canvasColorLight = Color(0xFFe6e4ef);

  static const Color primaryColorDark = Color(0xFF1E9AFE);
  static const Color secondaryColorDark = Color(0xFF60dfcd);
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
  static const double textSizeButton = 18.0;
  static const double textSizeTitle = 22.0;
  static const double defaultBorderRadiusSmall = 6.0;
  static const double defaultBorderRadiusMedium = 14.0;
  static const double defaultBorderRadiusLarge = 18.0;
  static const double defaultBorderRadiusXLarge = 25.0;
  static const double defaultBorderRadiusRound = 90.0;

  static const String storageUrlPrefix =
      'https://firebasestorage.googleapis.com/v0/b/haja-project.appspot.com/o/';
  static const List<String> defaultTeamPictures = [
    'icons%2Fdefaults%2Fcalendar.svg?alt=media&token=6b2a1b00-51df-49cc-a7a9-193839d29453',
    'icons%2Fdefaults%2Fevents.svg?alt=media&token=0cac2a74-762e-43f1-9527-cb52e3463e0b',
    'icons%2Fdefaults%2Fgirl-party.svg?alt=media&token=274aa77b-0d9e-4005-8d52-9fa9033e0ca3',
    'icons%2Fdefaults%2Fhalloween.svg?alt=media&token=45a7ab69-2b87-4504-a0f7-b0f701abb2fd',
    'icons%2Fdefaults%2Fheart.svg?alt=media&token=82085d8c-0e46-4933-8529-99ec43016552',
    'icons%2Fdefaults%2Fhospital.svg?alt=media&token=ca467ca8-5003-4551-8d31-fe0ebc7822df',
    'icons%2Fdefaults%2Ftoronto.svg?alt=media&token=9dac13e6-3bbc-427c-9de2-70e64c7cb1b0',
    'icons%2Fdefaults%2Fwelcome.svg?alt=media&token=de30676e-6200-431b-8111-7ce6057e74bb',
  ];
  static const List<String> networkErrorImages = [
    '0.svg?alt=media&token=e2eece61-3671-4c66-ae9a-15af427e6d09',
    '1.svg?alt=media&token=f4a491d4-058b-44ed-91bb-353afa0f8fa1',
    '2.svg?alt=media&token=b79d56b7-b99e-43ec-96d6-d651ade50fe9',
    '3.svg?alt=media&token=3cfc28d7-b54b-460b-9940-4c498199d2df',
  ];
  static const String buttonBackgroundSmall =
      'assets/images/button-bg-small.png';
  static const String placeholderUserIcon =
      'assets/images/placeholder_user.png';
  static const String noTeamsPlaceholder =
      'assets/images/placeholder_no_teams.png';
  static const String noNotosPlaceholder =
      'assets/images/placeholder_no_notos.png';
  static const String noInternetPlaceholder =
      'assets/images/placeholder_no_internet.png';
  static const String liveSvgs = 'https://avatars.dicebear.com/api/avataaars/';

  static const String linkUri = 'https://haja-project.web.app/';
  static const String dataLinkUri = 'https://haja-data.herokuapp.com/';
  static const String logoAsset = 'assets/images/logo/haja_logo_full.png';
  static const String logoTitleAsset =
      'assets/images/logo/haja logo_horizontal_full.png';
  static const String logoTitleAssetWhite =
      'assets/images/logo/haja logo_horizontal_white.png';
  static const String errorImage = 'assets/images/error.png';
  static const String imageAssetPath = 'assets/images/';

  static const String iconAssetFacebook = 'assets/icons/brands/facebook.png';
  static const String iconAssetKakaotalk = 'assets/icons/brands/kakaotalk.png';
  static const String iconAssetGoogle = 'assets/icons/brands/google.svg';

  static DateTime firstDay = DateTime.utc(2021, 1, 1);
  static DateTime lastDay = DateTime.utc(2041, 3, 1);

  static String randomDefaultPicture() {
    return defaultTeamPictures[Random().nextInt(defaultTeamPictures.length)];
  }

  static String randomErrorPicture() {
    return 'https://firebasestorage.googleapis.com/v0/b/haja-project.appspot.com/o/icons%2Ferror%2F404-' +
        networkErrorImages[Random().nextInt(networkErrorImages.length)];
  }

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

  static BoxDecoration cardStyle(
    BuildContext context, {
    Color? color,
  }) =>
      BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: color ?? Theme.of(context).iconTheme.color!.withOpacity(.1),
            offset: Offset.fromDirection(1.5, 6),
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: color ?? Theme.of(context).iconTheme.color!.withOpacity(.5),
          width: .2,
        ),
      );

  static String createUniqueId() {
    const int lettersLength = 8;
    String randStr = '';

    for (int i = 0; i < lettersLength; i++) {
      randStr += 'abcdefghijklmnopqrstuvwxyz'[Random().nextInt(26)];
    }

    return '$randStr.${DateTime.now().toString()}';
  }
}
