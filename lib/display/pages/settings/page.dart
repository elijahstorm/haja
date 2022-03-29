import 'package:flutter/material.dart';

import 'package:haja/display/pages/settings/components/settings_side.dart';
import 'package:haja/display/pages/settings/components/settings_main.dart';
import 'package:haja/display/components/widgets/responsive_content.dart';
import 'package:haja/login/user_state.dart';
import 'package:provider/provider.dart';

class AccountSettingsPage extends StatelessWidget {
  static const routeName = '/settings';

  const AccountSettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Provider(
        create: (context) => UserState(),
        builder: (context, __) => const SafeArea(
          child: ResponsiveContent(
            primaryContent: DashSettingsMain(),
            sideContent: DashSettingsSide(),
          ),
        ),
      ),
    );
  }
}
