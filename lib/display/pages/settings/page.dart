import 'package:flutter/material.dart';

import 'package:haja/language/language.dart';

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

  void _onSearch(String search) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: Theme.of(context).iconTheme,
        title: SizedBox(
          height: 38,
          child: TextField(
            onChanged: (value) => _onSearch(value),
            decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.all(0),
                prefixIconColor: Colors.red,
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).iconTheme.color ??
                      Theme.of(context).primaryColor,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
                hintStyle: const TextStyle(
                  fontSize: 14,
                ),
                hintText: '${Language.searchPrompt} settings'),
          ),
        ),
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
