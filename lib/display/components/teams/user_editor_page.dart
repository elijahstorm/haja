import 'package:flutter/material.dart';

import 'package:haja/language/theme.dart';
import 'package:haja/language/language.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/settings_keys.dart';
import 'package:haja/display/components/widgets/editable.dart';
import 'package:haja/display/components/widgets/skeleton.dart';

import 'package:haja/content/users/content.dart';

class UserEditorDisplay extends StatelessWidget {
  final UserContent content;

  const UserEditorDisplay(
    this.content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CloseAndSaveEditor(
      content: content,
      title: Language.userEditorTitle,
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Constants.defaultPadding),
              CustomEditablePicture(
                label: Language.userPicture,
                help: Language.userPictureHelp,
                value: content.imageUrl,
                onSave: (value) => content.pic = value.replaceAll(
                  Constants.storageUrlPrefix,
                  '',
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              CustomEditableText(
                value: content.title,
                help: Language.userTitleHelp,
                label: Language.userTitle,
                onSave: (value) => content.title = value,
              ),
              const SizedBox(height: Constants.defaultPadding),
              CustomEditableText(
                value: content.caption,
                help: Language.userCaptionHelp,
                label: Language.userCaption,
                onSave: (value) => content.caption = value,
              ),
              const SizedBox(height: Constants.defaultPadding),
              CustomEditableText(
                value: content.email,
                help: Language.userCaptionHelp,
                label: Language.userCaption,
                onSave: (value) => content.email = value,
              ),
              const SizedBox(height: Constants.defaultPadding),
              CustomSwitch(
                label: Language.userPrivacy,
                switchText: Language.userPrivacyAction,
                help: Language.userPrivacyHelp,
                value: content.private,
                onSave: (value) => content.private = value,
              ),
              const SizedBox(height: Constants.defaultPadding),
              const CustomEditable(
                label: Language.settingsVisualBrightness,
                content: ThemeSwitcher(),
              ),
              const CustomEditable(
                label: Language.settingsNotosAlarm,
                content: StoredPreferenceSwitcher(
                  keyName: SettingsKeyValues.settingsNotosAlarm,
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              const CustomEditable(
                label: Language.settingsCalendarEventType,
                content: StoredPreferenceSwitcher(
                  keyName: SettingsKeyValues.settingsCalendarEventType,
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              const Text(
                Language.friends,
              ),
              const SkeletonLoader(
                amount: 5,
              ),
              const SizedBox(height: Constants.defaultPadding * 7),
            ],
          ),
        ),
      ),
    );
  }
}
