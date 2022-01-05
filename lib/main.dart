import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:haja/firebase/core.dart';
import 'package:haja/login/user_state.dart';
import 'package:haja/login/responder.dart';
import 'package:haja/content/cache.dart';

import 'package:haja/theme.dart';
import 'package:haja/routes.dart';
import 'package:haja/keys.dart';
import 'package:haja/constants.dart';

void main() async {
  if (!kReleaseMode && AppDebugLogin.bypass) {
    // lanching in debug mode
    ContentCache.loadMockData = true;
    UserState.loadMockData = true;
    FirebaseApi.disabled = true;
  }

  WidgetsFlutterBinding.ensureInitialized();
  runApp(await Themes.init(const DashboardApp()));
}

class DashboardApp extends StatelessWidget {
  const DashboardApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      distinct: true,
      converter: (store) => store.state.enableDarkMode,
      builder: (_, bool enableDarkMode) {
        ThemeSwitcher.darkModeEnabled = enableDarkMode;
        return MaterialApp(
          scaffoldMessengerKey: GlobalKeys.rootScaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          title: '${Constants.appName} | ${Constants.appTitleDesc}',
          theme: Themes.mainLightThem(context),
          darkTheme: Themes.mainDarkThem(context),
          themeMode: enableDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: Routes.initalRoute,
          routes: Routes.routes,
          onUnknownRoute: Routes.unknownRoute,
        );
      },
    );
  }
}
