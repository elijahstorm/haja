import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haja/controllers/keys.dart';

import 'package:haja/firebase/storage.dart';
import 'package:haja/language/language.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/display/components/widgets/editable.dart';
import 'package:haja/display/components/teams/vertical_user_list.dart';
import 'package:haja/display/components/widgets/alerts.dart';

import 'package:haja/content/teams/content.dart';
import 'package:haja/language/settings_keys.dart';

class TeamEditorDisplay extends StatelessWidget {
  final TeamContent team;

  const TeamEditorDisplay(
    this.team, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CloseAndSaveEditor(
      content: team,
      title: Language.teamEditorTitle,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.defaultPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomEditableWidget<String>(
                onSave: (value) {},
                onTap: () async {
                  var url = await StorageApi.set(
                    isTeam: true,
                    id: team.id,
                  ).upload.images.gallery(
                    onError: (error) {
                      if (GlobalKeys.rootScaffoldMessengerKey.currentState ==
                          null) return;
                      GlobalKeys.rootScaffoldMessengerKey.currentState!
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            '${team.title} upload failed. $error',
                          ),
                          duration: kReleaseMode
                              ? const Duration(seconds: 4)
                              : const Duration(seconds: 20),
                        ),
                      );
                    },
                  );

                  if (url == null) return;

                  team.picture = url.replaceAll(
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
                            team.imageUrl,
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
              const SizedBox(
                height: Constants.defaultPadding,
              ),
              CustomEditableText(
                value: team.title,
                onSave: (value) => team.title = value,
                label: Language.teamTitle,
                help: Language.teamTitleHelp,
              ),
              CustomSwitch(
                label: Language.teamPrivacy,
                switchText: Language.teamPrivacyAction,
                help: Language.teamPrivacyHelp,
                value: team.private,
                onSave: (value) => team.private = value,
              ),
              const CustomEditable(
                label: Language.settingsNotosAlarm,
                content: StoredPreferenceSwitcher(
                  keyName: SettingsKeyValues.settingsNotosAlarm,
                ),
              ),
              const SizedBox(
                height: Constants.defaultPadding,
              ),
              const Text(
                Language.teamMembers,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: Constants.defaultPadding / 2,
              ),
              CustomEditableWidget(
                onSave: (s) {},
                child: VerticalUserList(team.usersContent),
              ),
              const SizedBox(
                height: Constants.defaultPadding,
              ),
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => const AlertTextDialog(
                    alert: 'main',
                    subtext: 'sub',
                  ),
                ),
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
                  Language.leaveTeamButton,
                ),
              ),
              const SizedBox(
                height: Constants.defaultPadding,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
