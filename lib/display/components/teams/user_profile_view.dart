import 'package:flutter/material.dart';
import 'package:haja/content/stream.dart';
import 'package:provider/provider.dart';
import 'package:number_slide_animation/number_slide_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:haja/login/user_state.dart';
import 'package:haja/display/components/widgets/error.dart';
import 'package:haja/firebase/firestore.dart';
import 'package:haja/firebase/auth.dart';
import 'package:haja/display/components/teams/team_user_avatars.dart';
import 'package:haja/display/components/widgets/border_display.dart';
import 'package:haja/language/language.dart';
import 'package:haja/language/constants.dart';

import 'package:haja/content/todo/content.dart';
import 'package:haja/content/users/content.dart';

class UserProfileView extends StatelessWidget {
  final String userId;
  final bool noBackground;

  const UserProfileView(
    this.userId, {
    this.noBackground = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ContentStreamBuilder(
        collection: UserContent.collectionName,
        id: userId,
        error: Consumer<UserState>(
          builder: (context, userstate, child) {
            return ErrorDisplay(
              Language.userstateError,
              retry: () {
                userstate.notify();
              },
            );
          },
        ),
        notFound: Consumer<UserState>(
          builder: (context, userstate, child) {
            return ErrorDisplay(
              'Error: No user found',
              retryPrompt: Language.retryButton,
              retry: () {
                userstate.notify();
              },
            );
          },
        ),
        success: (data) => _DrawSnapshot(
          UserContent.fromJson(
            data,
          ),
          simpleDisplay: noBackground,
        ),
      );
}

class _DrawSnapshot extends StatelessWidget {
  final UserContent user;
  final bool simpleDisplay;

  const _DrawSnapshot(
    this.user, {
    this.simpleDisplay = false,
    Key? key,
  }) : super(key: key);

  Widget _rowWithData({
    required String label,
    required String field,
    required String collection,
    required String id,
  }) =>
      Padding(
        padding: const EdgeInsets.only(
          bottom: Constants.defaultPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: .6,
              child: Text(label),
            ),
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
        ),
      );

  Widget _contentRowWithText({
    required String label,
    required String value,
  }) =>
      Padding(
        padding: const EdgeInsets.only(
          bottom: Constants.defaultPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: .6,
              child: Text(label),
            ),
            Text(value),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    List<Widget> header = [
      SizedBox(
        height: 150,
        width: 150,
        child: UserAvatars(user),
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
    ];
    List<Widget> widgetList = [
      const SizedBox(height: Constants.defaultPadding),
      _contentRowWithText(label: 'Pronouns', value: user.pronounsString),
      _contentRowWithText(label: 'Email', value: user.email),
      _rowWithData(
        id: user.id,
        label: 'Total Todos',
        collection: TodoContent.collectionName,
        field: 'numOfDocs',
      ),
      const SizedBox(height: Constants.defaultPadding),
      if (user.id != AuthApi.activeUser)
        ElevatedButton(
          onPressed: () => user.navigateToEditor(context),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Constants.defaultBorderRadiusXLarge,
              ),
            ),
          ),
          child: Container(
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage(Constants.buttonBackgroundSmall),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            constraints: const BoxConstraints(
              minHeight: Constants.defaultPadding * 2,
            ),
            alignment: Alignment.center,
            child: Text(
              Language.userEditorTitle,
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      if (user.id == AuthApi.activeUser)
        ElevatedButton(
          onPressed: () => user.navigateToEditor(context),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Constants.defaultBorderRadiusXLarge,
              ),
            ),
          ),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: Constants.defaultPadding * 2,
            ),
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit,
                  color: Constants.bgColorLight,
                ),
                SizedBox(
                  width: Constants.defaultPadding / 2,
                ),
                Text(
                  Language.editButton,
                  style: TextStyle(
                    color: Constants.bgColorLight,
                  ),
                ),
              ],
            ),
          ),
        ),
    ];

    if (simpleDisplay) {
      return Column(
        children: header + widgetList,
      );
    }

    return BorderDisplay(
      header: header,
      children: List.generate(
        widgetList.length,
        (index) => AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: Column(
                children: [
                  const SizedBox(height: Constants.defaultPadding),
                  widgetList[index],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
