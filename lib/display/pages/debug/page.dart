import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haja/controllers/keys.dart';

import 'package:haja/display/components/widgets/error.dart';

class DebugTestingPage extends StatelessWidget {
  static const String routeName = '/debug';

  const DebugTestingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (GlobalKeys.rootScaffoldMessengerKey.currentState == null) return;
          GlobalKeys.rootScaffoldMessengerKey.currentState!
              .showSnackBar(SnackBar(
            content: const Text('Snackbar test: release mode $kReleaseMode'),
            duration: kReleaseMode
                ? const Duration(seconds: 4)
                : const Duration(seconds: 20),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () {},
            ),
          ));
        },
        child: const ErrorPage(
          header: 'Debug Page',
          help: 'Tap the screen to test the current debug feature',
        ),
      );
}
