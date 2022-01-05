import 'package:flutter/material.dart';
import 'package:haja/firebase/core.dart';
import 'package:provider/provider.dart';

import 'package:haja/controllers/menu_controller.dart';
import 'package:haja/display/pages/main/page.dart';
import 'package:haja/display/components/animations/loading.dart';
import 'package:haja/display/components/widgets/error.dart';
import 'package:haja/login/user_state.dart';
import 'package:haja/login/login_screen.dart';

class UiManager extends StatefulWidget {
  static const routeName = '/main';

  const UiManager({
    Key? key,
  }) : super(key: key);

  @override
  _UiManagerState createState() => _UiManagerState();
}

class _UiManagerState extends State<UiManager> {
  Widget mainScreen(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MenuController()),
          ChangeNotifierProvider(create: (context) => UserState()),
        ],
        child: Consumer<UserState>(
          builder: (context, userstate, child) {
            return userstate.data.exists
                ? const MainScreen()
                : const LoginScreen();
          },
        ),
      );

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: FirebaseApi.init(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: ErrorDisplay(snapshot.error.toString()),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return mainScreen(context);
          }

          return const Loading();
        },
      );
}
