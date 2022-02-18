import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:haja/login/user_state.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: Consumer<UserState>(builder: (context, user, child) {
          return ElevatedButton(
            onPressed: () => user.logout(),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              shadowColor: Colors.red,
              elevation: 5,
              minimumSize: const Size.fromHeight(
                Constants.defaultPadding * 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Constants.defaultBorderRadiusXLarge,
                ),
              ),
            ),
            child: const Text(
              Language.logoutButton,
            ),
          );
        }),
      );
}
