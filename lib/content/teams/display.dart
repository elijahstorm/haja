import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:haja/display/components/animations/fade_in_incrementable.dart';
import 'package:haja/content/todo/content.dart';
import 'package:haja/display/components/widgets/slivers.dart';
import 'package:haja/display/components/widgets/video_prebuffer.dart';
import 'package:haja/display/components/widgets/buttons.dart';
import 'package:haja/constants.dart';

import 'content.dart';

class TeamContentDisplayPage extends StatelessWidget {
  final TeamContent content;

  const TeamContentDisplayPage(
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
                background: const AssetImage('assets/imports/emma.jpg'),
                children: [
                  FadeInIncrementable(
                    child: Text(
                      content.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
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
                                      snapshot.data!.length, 'active Todo')
                                  : 'Loading active Todos...',
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
                                content.users.length, 'member'),
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
                  const SizedBox(height: Constants.defaultPadding * 4),
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
                  const SizedBox(height: Constants.defaultPadding * 2),
                  const FadeInIncrementable(
                    child: Opacity(
                      opacity: .7,
                      child: Text(
                        'Upcoming Todos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Constants.defaultPadding * 2),
                  FadeInIncrementable(
                    child: SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          VideoPrebuffer(
                            onTap: () {},
                            imageLink: 'assets/imports/emma-1.jpg',
                            localImage: true,
                          ),
                          VideoPrebuffer(
                            onTap: () {},
                            imageLink: 'assets/imports/emma-2.jpg',
                            localImage: true,
                          ),
                          VideoPrebuffer(
                            onTap: () {},
                            imageLink: 'assets/imports/emma-3.jpg',
                            localImage: true,
                          ),
                        ],
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
                  onTap: () {},
                  label: 'Edit Team Info', // TODO: fix
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
