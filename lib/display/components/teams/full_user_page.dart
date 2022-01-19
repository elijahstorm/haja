import 'package:flutter/material.dart';
import 'package:haja/language/language.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:number_slide_animation/number_slide_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:haja/display/components/animations/loading.dart';
import 'package:haja/display/components/widgets/error.dart';
import 'package:haja/display/components/widgets/slivers.dart';
import 'package:haja/display/components/widgets/painters.dart';
import 'package:haja/firebase/firestore.dart';
import 'package:haja/firebase/auth.dart';
import 'package:haja/firebase/storage.dart';
import 'package:haja/login/user_state.dart';
import 'package:haja/language/constants.dart';

import 'package:haja/content/todo/content.dart';
import 'package:haja/content/users/content.dart';

class DashboardProfileDisplay extends StatelessWidget {
  final UserContent user;

  const DashboardProfileDisplay(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // force users to be logged in to view other user info
    if (AuthApi.activeUser == null) {
      return Consumer<UserState>(
        builder: (context, userstate, child) {
          return ErrorDisplay(
            Language.reloginRequest,
            retryPrompt: Language.reloginButton,
            retry: () {
              userstate.logout();
            },
          );
        },
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: CurvePainterBottom(Theme.of(context).primaryColor),
          ),
        ),
        Positioned.fill(
          child: SafeArea(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirestoreApi.stream(
                'users',
                id: user.id,
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Consumer<UserState>(
                    builder: (context, userstate, child) {
                      return ErrorDisplay(
                        Language.userstateError,
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
                        'Error: No user found',
                        retryPrompt: Language.retryButton,
                        retry: () {
                          userstate.notify();
                        },
                      );
                    },
                  );
                }

                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                data['id'] = user.id;

                UserContent content = UserContent.fromJson(
                  data,
                );
                content.synchedWithDatabase = user.synchedWithDatabase;

                return _DrawSnapshot(
                  content,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DrawSnapshot extends StatelessWidget {
  final UserContent user;

  const _DrawSnapshot(this.user);

  Widget _rowWithData({
    required String label,
    required String field,
    required String collection,
    required String id,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          FirestoreApi.future(
            field: field,
            id: id,
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
                Language.noDataFoundError,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              );
            },
          ),
        ],
      );

  Widget _contentRowWithText({
    required String label,
    required String value,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Opacity(
            opacity: .6,
            child: Text(value),
          ),
        ],
      );

  void _changeImage() async {
    String? url = await StorageApi.upload.images.gallery(
      onError: (e) {
        // print(e);
      },
    );

    if (url == null) return;

    user.pic = url;

    user.upload();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetList = [
      const SizedBox(height: Constants.defaultPadding),
      _contentRowWithText(label: 'Pronouns', value: user.pronounsString),
      _contentRowWithText(label: 'Email', value: user.email),
      _rowWithData(
        id: user.id,
        label: 'Total Todos',
        collection: TodoContent.collectionName,
        field: 'numOfDocs',
      ),
      const SizedBox(height: Constants.defaultPadding * 4),
      if (user.id != AuthApi.activeUser)
        SizedBox(
          width: 200,
          child: AspectRatio(
            aspectRatio: 208 / 71,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  color: const Color(0xFF4960F9).withOpacity(.3),
                  spreadRadius: 4,
                  blurRadius: 50,
                )
              ]),
              child: MaterialButton(
                onPressed: () {
                  // TODO: add to circle
                },
                splashColor: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
                padding: const EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(Constants.buttonBackgroundSmall),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 88.0,
                      minHeight: 36.0,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      Language.followButton,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ];

    return CustomScrollView(
      slivers: [
        CenteredAppbarWithContent(
          background: CustomPaint(
            painter: CurvePainterTop(Theme.of(context).primaryColor),
          ),
          children: [
            GestureDetector(
              onTap: _changeImage,
              child: user.pic == UserContent.defaultData['pic']
                  ? const CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          AssetImage(Constants.placeholderUserIcon),
                      backgroundColor: Colors.transparent,
                      child: Opacity(
                        opacity: 0.7,
                        child: Icon(Icons.edit),
                      ),
                    )
                  : CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(user.pic),
                      backgroundColor: Colors.transparent,
                      child: const Opacity(
                        opacity: 0.7,
                        child: Icon(Icons.edit),
                      ),
                    ),
            ),
            const SizedBox(height: Constants.defaultPadding),
            Text(
              user.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Constants.defaultPadding / 2),
            Text(
              user.caption,
            )
          ],
        ),
        AnimationLimiter(
          child: PaddedContentSliver(
            children: List.generate(
              _widgetList.length,
              (index) => AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _AnimatedEditableBox(_widgetList[index]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
        margin: const EdgeInsets.only(bottom: Constants.defaultPadding),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: selected ? Theme.of(context).primaryColorLight : null,
        ),
        child: widget.child,
      );
}
