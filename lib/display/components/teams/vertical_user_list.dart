import 'package:flutter/material.dart';

import 'package:haja/display/components/widgets/skeleton.dart';

import 'package:haja/content/users/content.dart';

import 'package:haja/display/components/teams/horizontal_user_card.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';

class VerticalUserList extends StatelessWidget {
  final List<Future<UserContent?>> users;

  const VerticalUserList(
    this.users, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(
          users.length + 1,
          (index) => index == 0
              ? Padding(
                  padding: const EdgeInsets.only(
                    bottom: Constants.defaultPadding,
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print('todo for sure');
                    },
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
                )
              : FutureBuilder<UserContent?>(
                  future: users[index - 1],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SkeletonLoader(
                        amount: 1,
                      );
                    }

                    if (snapshot.data == null) {
                      return const SizedBox(
                        height: Constants.defaultPadding,
                        child: Text('Error loading'),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: Constants.defaultPadding,
                      ),
                      child: HorizontalUserCard(snapshot.data!),
                    );
                  },
                ),
        ),
      );
}
