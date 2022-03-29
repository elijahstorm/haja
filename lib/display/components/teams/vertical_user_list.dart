import 'package:flutter/material.dart';
import 'package:haja/content/teams/content.dart';

import 'package:haja/display/components/widgets/skeleton.dart';

import 'package:haja/content/users/content.dart';

import 'package:haja/display/components/teams/horizontal_user_card.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';

typedef FutureUser = Future<UserContent?>;

class VerticalUserList extends StatelessWidget {
  final List<FutureUser> users;
  final UserListController? controller;

  const VerticalUserList(
    this.users, {
    this.controller,
    Key? key,
  }) : super(key: key);

  void update() {
    if (controller == null) return;

    controller!.cleanPrevious();
    controller!.update(users);
  }

  void removeAt(int index) {
    users.removeAt(index);
    update();
  }

  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, setState) => Column(
          children: List.generate(
            users.length,
            (index) => FutureBuilder<UserContent?>(
              future: users[index],
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
                  child: HorizontalUserCard(
                    snapshot.data!,
                    trailing: controller == null
                        ? null
                        : GestureDetector(
                            onTap: () => setState(() => removeAt(index)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadiusDirectional.circular(
                                  Constants.defaultBorderRadiusXLarge,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Constants.defaultPadding / 6 + 4,
                                  horizontal: Constants.defaultPadding / 2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.person_remove,
                                      size: Constants.defaultPadding - 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    const SizedBox(
                                      width: Constants.defaultPadding / 2,
                                    ),
                                    Text(
                                      Language.teamEditorEditMembersRemove,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      );
}

class UserListController {
  List<UserContent> list = const [];
  bool interruptRequest = false;

  UserListController();

  void save(TeamContent team) {
    print('in save');
    team.users = [];
    for (var user in list) {
      team.users.add(user.id);
    }
    team.upload();
  }

  void update(List<FutureUser> users) async {
    interruptRequest = false;

    list = [];

    for (var user in users) {
      if (interruptRequest) return;

      var u = await user;
      if (u == null) continue;

      list.add(u);
    }
  }

  void cleanPrevious() {
    interruptRequest = true;
  }
}
