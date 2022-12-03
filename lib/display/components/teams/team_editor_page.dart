import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:haja/firebase/firestore.dart';
import 'package:haja/firebase/storage.dart';
import 'package:haja/language/language.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/controllers/keys.dart';
import 'package:haja/display/components/animations/loading.dart';
import 'package:haja/display/components/widgets/editable.dart';
import 'package:haja/display/components/teams/vertical_user_list.dart';
import 'package:haja/display/components/widgets/alerts.dart';

import 'package:haja/content/teams/content.dart';
import 'package:haja/language/settings_keys.dart';
import 'package:provider/provider.dart';

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
              CustomEditableWidget<StorageFile>(
                onSave: (file) async {
                  if (file == null) return;

                  var url = await StorageApi.set(
                    isTeam: true,
                    id: team.id,
                  ).upload.images.file(
                    file,
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

                  FirestoreApi.feel(
                    type: TeamContent.collectionName,
                    id: team.id,
                    field: 'picture',
                    value: team.picture,
                  );

                  if (GlobalKeys.rootScaffoldMessengerKey.currentState ==
                      null) {
                    return;
                  }
                  GlobalKeys.rootScaffoldMessengerKey.currentState!
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Picture finished uploading. Refresh the page to see the changes.',
                      ),
                    ),
                  );
                },
                onTap: () async => await StorageApi.file.gallery(
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
                ),
                container: (child) => ClipRRect(
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
                          child: child,
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
                editor: (value) => value == null
                    ? const Loading()
                    : Image.asset(
                        value.path,
                        fit: BoxFit.cover,
                        errorBuilder: (context, err, stacktrace) =>
                            SvgPicture.network(
                          Constants.randomErrorPicture(),
                          fit: BoxFit.cover,
                        ),
                      ),
                child: team.responsiveImage,
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
              Provider(
                create: (context) => UserListController(),
                builder: (context, child) => Consumer<UserListController>(
                  builder: (context, controller, child) => CustomEditableWidget(
                    onSave: (s) {
                      controller.save(team);
                    },
                    onTap: () => Future.value(0),
                    editor: (d) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: Constants.defaultPadding,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_circle_outline,
                                size: Constants.defaultPadding * 2,
                              ),
                              SizedBox(
                                width: Constants.defaultPadding,
                              ),
                              Expanded(
                                child: Text(
                                  Language.teamMembersAddButton,
                                ),
                              ),
                            ],
                          ),
                        ),
                        VerticalUserList(
                          team.usersContent,
                          controller: controller,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: Constants.defaultPadding,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadiusDirectional.circular(
                                Constants.defaultBorderRadiusXLarge,
                              ),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                minHeight: Constants.defaultPadding * 2,
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.edit,
                                    color: Constants.bgColorLight,
                                  ),
                                  SizedBox(
                                    width: Constants.defaultPadding / 2,
                                  ),
                                  Text(
                                    Language.teamEditorEditMembers,
                                    style: TextStyle(
                                      color: Constants.bgColorLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        VerticalUserList(team.usersContent),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: Constants.defaultPadding,
              ),
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertConfirmDialog(
                    alert: '${Language.leaveTeamButtonWarning} ${team.title}?',
                    subtext: team.private
                        ? Language.leaveTeamButtonWarningPrivate
                        : Language.leaveTeamButtonWarningOpen,
                    onConfirm: () {
                      team.leaveTeam();
                      Navigator.pop(context);
                    },
                    actionLabel: Language.leaveTeamButton,
                    heightDevider: 2.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
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
