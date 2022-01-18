import 'package:haja/language/language.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:haja/display/components/animations/fade_in_incrementable.dart';
import 'package:haja/content/todo/content.dart';
import 'package:haja/display/components/widgets/slivers.dart';
import 'package:haja/display/components/calendar/team_calendar.dart';
import 'package:haja/display/components/widgets/buttons.dart';
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

    return AnimationIncrementable(
      child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              DramaticAppbarWithContent(
                background: content.imageUrl,
                children: [
                  FadeInIncrementable(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: Constants.defaultPadding / 2,
                            right: Constants.defaultPadding / 2,
                          ),
                          child: Icon(
                            content.private ? Icons.lock : Icons.lock_open,
                            size: 28,
                          ),
                        ),
                        Text(
                          content.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Constants.defaultPadding * 2),
                  Row(
                    children: [
                      FadeInIncrementable(
                        child: Opacity(
                          opacity: .7,
                          child: FutureBuilder<List<TodoContent>>(
                            future: content.activeTodos,
                            builder: (context, snapshot) => Text(
                              snapshot.hasData
                                  ? Constants.countableWithTrailingS(
                                      snapshot.data!.length,
                                      'active Todo',
                                    )
                                  : Language.loadingActiveTeamTodos,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Constants.defaultPadding * 5),
                      FadeInIncrementable(
                        child: Opacity(
                          opacity: .7,
                          child: Text(
                            Constants.countableWithTrailingS(
                              content.users.length,
                              'member',
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                  const SizedBox(height: Constants.defaultPadding),
                  TeamCalendar(
                    team: content.id,
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
                  const SizedBox(height: Constants.defaultPadding * 7),
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
    );
  }
}
