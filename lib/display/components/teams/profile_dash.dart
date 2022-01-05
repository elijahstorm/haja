import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:number_slide_animation/number_slide_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:haja/display/components/animations/loading.dart';
import 'package:haja/display/components/widgets/error.dart';
import 'package:haja/firebase/firestore.dart';
import 'package:haja/firebase/auth.dart';
import 'package:haja/login/user_state.dart';
import 'package:haja/constants.dart';

import 'package:haja/content/todo/content.dart';
import 'package:haja/content/files/content.dart';
import 'package:haja/content/users/content.dart';

class _DrawSnapshot extends StatelessWidget {
  final UserContent user;

  const _DrawSnapshot(this.user);

  Widget _rowWithData({
    required String label,
    required String field,
    required String collection,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        FirestoreApi.future(
          field: field,
          id: AuthApi.activeUser!,
          collection: collection,
          document: 'info',
          builder: (context, data) {
            try {
              String str = data.toString();

              int position = 0;
              for (; position < str.length; position++) {
                try {
                  int.parse(str[position]);
                } catch (e) {
                  break;
                }
              }

              if (position == str.length) {
                return NumberSlideAnimation(
                  number: str,
                  duration: const Duration(seconds: 1),
                  curve: Curves.bounceIn,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                );
              }

              return Row(
                children: [
                  NumberSlideAnimation(
                    number: str.substring(0, position),
                    duration: const Duration(seconds: 1),
                    curve: Curves.bounceIn,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    str.substring(position),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            } catch (e) {
              return Text(
                data,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              );
            }
          },
          onError: (e) {
            return const Text(
              'No data',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var activeUser = AuthApi.activeUserInformation;

    if (activeUser == null) {
      return Consumer<UserState>(
        builder: (context, userstate, child) {
          return ErrorDisplay(
            'Please make sure you are logged in',
            retryPrompt: 'Log Back In',
            retry: () {
              userstate.logout();
            },
          );
        },
      );
    }

    List<Widget> _widgetList = [
      Row(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: activeUser.photoURL != null
                ? Image.network(activeUser.photoURL!)
                : user.icon,
          ),
          const SizedBox(width: Constants.defaultPadding),
          SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeUser.displayName ?? user.title,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).iconTheme.color,
                      ),
                ),
                const SizedBox(height: Constants.defaultPadding / 2),
                Text(
                  user.pronounsString,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: Constants.defaultPadding),
                Text(activeUser.email ?? 'no email'),
              ],
            ),
          ),
        ],
      ),
      Text(user.caption),
      _rowWithData(
        label: 'Todos Done This Week',
        collection: TodoContent.collectionName,
        field: 'weeklyDone',
      ),
      _rowWithData(
        label: 'Todo\'s',
        collection: TodoContent.collectionName,
        field: 'numOfDocs',
      ),
      _rowWithData(
        label: 'Total Files',
        collection: FileContent.collectionName,
        field: 'numOfDocs',
      ),
    ];

    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          _widgetList.length,
          (int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: _AnimatedEditableBox(_widgetList[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedEditableBox extends StatefulWidget {
  final Widget child;

  const _AnimatedEditableBox(this.child);

  @override
  _StateAnimatedEditableBox createState() => _StateAnimatedEditableBox();
}

class _StateAnimatedEditableBox extends State<_AnimatedEditableBox> {
  bool selected = false;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        curve: Curves.ease,
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(Constants.defaultPadding),
        margin: const EdgeInsets.only(bottom: Constants.defaultPadding),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: selected
              ? Theme.of(context).primaryColorLight
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        child: widget.child,
      );
}

class DashboardProfileDisplay extends StatelessWidget {
  const DashboardProfileDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirestoreApi.stream(
            'users',
            id: AuthApi.activeUser,
          ),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Consumer<UserState>(
                builder: (context, userstate, child) {
                  return ErrorDisplay(
                    'Something went wrong... if you keep seeing this, try logging out and logging back in',
                    retry: () {
                      userstate.notify();
                    },
                  );
                },
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            }

            var document = snapshot.data!;

            if (!document.exists || document.data() == null) {
              return Consumer<UserState>(
                builder: (context, userstate, child) {
                  return ErrorDisplay(
                    'Please make sure you are logged in',
                    retryPrompt: 'Log Back In',
                    retry: () {
                      userstate.logout();
                    },
                  );
                },
              );
            }

            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            data['id'] = AuthApi.activeUser;

            return _DrawSnapshot(
              UserContent.fromJson(
                data,
              ),
            );
          },
        ),
      ],
    );
  }
}
