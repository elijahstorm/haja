import 'package:flutter/material.dart';

import 'package:haja/display/components/widgets/skeleton.dart';
import 'package:haja/display/components/widgets/dividers.dart';
import 'package:haja/display/components/widgets/editable.dart';
import 'package:haja/language/settings_keys.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';
import 'package:haja/language/theme.dart';

class DashSettingsMain extends StatelessWidget {
  const DashSettingsMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Main Settings',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        const SizedBox(height: Constants.defaultPadding),
        Container(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: const [
              CustomEditable(
                label: Language.settingsVisualBrightness,
                content: ThemeSwitcher(),
              ),
              CustomDivider(),
              CustomEditable(
                label: Language.settingsNotosAlarm,
                content: StoredPreferenceSwitcher(
                  keyName: SettingsKeyValues.settingsNotosAlarm,
                ),
              ),
              CustomEditable(
                label: Language.settingsCalendarEventType,
                content: StoredPreferenceSwitcher(
                  keyName: SettingsKeyValues.settingsCalendarEventType,
                ),
              ),
              CustomDivider(),
              SkeletonLoader(
                amount: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
