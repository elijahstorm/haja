import 'package:flutter/material.dart';
import 'package:haja/controllers/responsive.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';

import 'package:haja/display/pages/settings/components/settings_side.dart';
import 'package:haja/display/pages/settings/components/settings_main.dart';
import 'package:haja/display/pages/settings/components/settings_team.dart';

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
                fillColor: Theme.of(context).canvasColor,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          child: Column(
            children: [
              const SizedBox(height: Constants.defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        const DashSettingsMain(),
                        const SizedBox(height: Constants.defaultPadding),
                        const DashSettingsTeam(),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: Constants.defaultPadding),
                        if (Responsive.isMobile(context))
                          const DashSettingsSide(),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    const SizedBox(width: Constants.defaultPadding),
                  if (!Responsive.isMobile(context))
                    const Expanded(
                      flex: 2,
                      child: DashSettingsSide(),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
