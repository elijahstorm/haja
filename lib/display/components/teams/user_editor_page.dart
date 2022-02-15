import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haja/controllers/keys.dart';

import 'package:haja/firebase/storage.dart';
import 'package:haja/language/theme.dart';
import 'package:haja/language/language.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/settings_keys.dart';
import 'package:haja/display/components/widgets/editable.dart';
import 'package:haja/display/components/teams/vertical_user_list.dart';

import 'package:haja/content/users/content.dart';

class UserEditorDisplay extends StatelessWidget {
  final UserContent user;

  const UserEditorDisplay(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CloseAndSaveEditor(
      content: user,
      title: Language.userEditorTitle,
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Constants.defaultPadding),
              CustomEditableWidget<String>(
                onSave: (value) {},
                onTap: () async {
                  var url = await StorageApi.upload.images.gallery(
                    onError: (error) {
                      if (GlobalKeys.rootScaffoldMessengerKey.currentState ==
                          null) return;
                      GlobalKeys.rootScaffoldMessengerKey.currentState!
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            '${user.title} upload failed. $error',
                          ),
                          duration: kReleaseMode
                              ? const Duration(seconds: 4)
                              : const Duration(seconds: 20),
                        ),
                      );
                    },
                  );

                  if (url == null) return;

                  user.picture = url.replaceAll(
                    Constants.storageUrlPrefix,
                    '',
                  );
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      Constants.defaultBorderRadiusXLarge,
                    ),
                  ),
                  child: SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            user.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, err, stacktrace) =>
                                Image.asset(
                              Constants.defaultTeamPicture,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.center,
                                colors: [
                                  Theme.of(context)
                                      .iconTheme
                                      .color!
                                      .withOpacity(.5),
                                  Theme.of(context)
                                      .iconTheme
                                      .color!
                                      .withOpacity(.2),
                                  Colors.transparent,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: Constants.defaultPadding,
                          right: Constants.defaultPadding,
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              CustomEditableText(
                value: user.title,
                help: Language.userTitleHelp,
                label: Language.userTitle,
                onSave: (value) => user.title = value,
              ),
              CustomEditableText(
                value: user.caption,
                help: Language.userCaptionHelp,
                label: Language.userCaption,
                onSave: (value) => user.caption = value,
              ),
              CustomEditableText(
                value: user.email,
                help: Language.userCaptionHelp,
                label: Language.userCaption,
                onSave: (value) => user.email = value,
                maxLength: 100,
              ),
              const SizedBox(height: Constants.defaultPadding),
              CustomSwitch(
                label: Language.userPrivacy,
                switchText: Language.userPrivacyAction,
                help: Language.userPrivacyHelp,
                value: user.private,
                onSave: (value) => user.private = value,
              ),
              const SizedBox(height: Constants.defaultPadding),
              const CustomEditable(
                label: Language.settingsVisualBrightness,
                content: ThemeSwitcher(),
              ),
              const SizedBox(height: Constants.defaultPadding),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: Constants.defaultPadding / 2),
              VerticalUserList(user.followingListContent),
              const SizedBox(height: Constants.defaultPadding),
              ElevatedButton(
                onPressed: () {},
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
                  Language.removeAccount,
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
