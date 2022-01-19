import 'package:flutter/material.dart';

import 'package:haja/language/language.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/display/components/widgets/editable.dart';

import 'package:haja/content/teams/content.dart';

class TeamEditorDisplay extends StatelessWidget {
  final TeamContent content;

  const TeamEditorDisplay(
    this.content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CloseAndSaveEditor(
      content: content,
      title: Language.teamEditorTitle,
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Constants.defaultPadding),
              CustomSwitch(
                label: Language.teamPrivacy,
                switchText: Language.teamPrivacyAction,
                help: Language.teamPrivacyHelp,
                value: content.private,
                onSave: (value) => content.private = value,
              ),
              const SizedBox(height: Constants.defaultPadding),
              const Padding(
                padding: EdgeInsets.all(Constants.defaultPadding),
                child: Divider(
                  thickness: 1,
                ),
              ),
              CustomEditablePicture(
                label: Language.teamPicture,
                help: Language.teamPictureHelp,
                value: content.imageUrl,
                onSave: (value) => content.picture = value.replaceAll(
                  Constants.storageUrlPrefix,
                  '',
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              const Padding(
                padding: EdgeInsets.all(Constants.defaultPadding),
                child: Divider(
                  thickness: 1,
                ),
              ),
              CustomEditableText(
                value: content.title,
                help: Language.teamTitleHelp,
                label: Language.teamTitle,
                onSave: (value) => content.title = value,
              ),
              const SizedBox(height: Constants.defaultPadding),
              CustomEditableText(
                value: content.caption,
                help: Language.teamCaptionHelp,
                label: Language.teamCaption,
                onSave: (value) => content.caption = value,
              ),
              const SizedBox(height: Constants.defaultPadding * 7),
            ],
          ),
        ),
      ),
    );
  }
}
