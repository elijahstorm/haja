import 'package:flutter/material.dart';
import 'package:haja/display/components/widgets/alerts.dart';

import 'package:haja/firebase/storage.dart';
import 'package:haja/language/language.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/display/components/widgets/editable.dart';

import 'package:haja/content/teams/content.dart';
import 'package:haja/language/settings_keys.dart';

class UserListEditorDisplay extends StatelessWidget {
  final TeamContent team;

  const UserListEditorDisplay(
    this.team, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CloseAndSaveEditor(
      content: team,
      title: Language.teamEditorTitle,
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomEditableWidget<String>(
                onSave: (value) => team.picture = value.replaceAll(
                  Constants.storageUrlPrefix,
                  '',
                ),
                onTap: () async {
                  var url = await StorageApi.upload.images.gallery(
                    onError: (err) {
                      print('we errored: $err');
                    },
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
              CustomEditableText(
                value: team.title,
                onSave: (value) => team.title = value,
                label: Language.teamTitle,
                help: Language.teamTitleHelp,
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
              CustomEditableWidget(
                onSave: (s) {},
                child: Container(
                  height: 100,
                  color: Colors.blue,
                  child: Text('TODO'), // TODO
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
