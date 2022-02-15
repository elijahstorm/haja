import 'package:haja/language/language.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:haja/display/components/animations/fade_in_incrementable.dart';
import 'package:haja/display/components/widgets/slivers.dart';
import 'package:haja/display/components/widgets/buttons.dart';
import 'package:haja/display/components/calendar/team_calendar.dart';
import 'package:haja/display/components/teams/team_user_avatars.dart';
import 'package:haja/language/constants.dart';

import 'package:haja/content/teams/content.dart';

class TeamPageDisplay extends StatelessWidget {
  final TeamContent content;

  const TeamPageDisplay(
    this.content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('MM/dd/yyyy hh:mm a');

    return Scaffold(
      body: SafeArea(
        child: AnimationIncrementable(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  PaddedContentSliver(
                    children: [
                      FadeInIncrementable(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BackButton(
                              onPressed: () => Navigator.pop(context),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Constants.defaultPadding / 2,
                                right: Constants.defaultPadding / 4,
                                bottom: Constants.defaultPadding / 3 + 6,
                              ),
                              child: Icon(
                                content.private ? Icons.lock : Icons.lock_open,
                                size: 20,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                content.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Constants.textSizeTitle,
                                ),
                              ),
                            ),
                            UserAvatarStack(
                              content.usersContent,
                              onTap: () => content.navigateToEditor(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  NoPaddingContentSliver(
                    children: [
                      FadeInIncrementable(
                        child: TeamCalendar(
                          team: content.id,
                        ),
                      ),
                    ],
                  ),
                  PaddedContentSliver(
                    children: [
                      FadeInIncrementable(
                        child: Opacity(
                          opacity: .7,
                          child: Text(
                            content.caption,
                            style: const TextStyle(
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Constants.defaultPadding * 2),
                      const FadeInIncrementable(
                        child: Text(
                          'Created',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: Constants.defaultPadding),
                      FadeInIncrementable(
                        child: Opacity(
                          opacity: .7,
                          child: Text(
                            dateFormat.format(content.createdOn),
                          ),
                        ),
                      ),
                      const SizedBox(height: Constants.defaultPadding * 2),
                      const FadeInIncrementable(
                        child: Opacity(
                          opacity: .7,
                          child: Text(
                            'Last Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Constants.defaultPadding),
                      FadeInIncrementable(
                        child: Opacity(
                          opacity: .7,
                          child: Text(
                            dateFormat.format(content.lastLogin),
                          ),
                        ),
                      ),
                      const SizedBox(height: Constants.defaultPadding * 4),
                    ],
                  ),
                ],
              ),
              Positioned.fill(
                bottom: Constants.defaultPadding * 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FadeInIncrementable(
                    child: GenericFloatingButton(
                      onTap: () => content.navigateToEditor(context),
                      label: Language.editButton,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
