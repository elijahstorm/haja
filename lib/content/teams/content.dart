import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'package:haja/content/users/content.dart';
import 'package:haja/controllers/keys.dart';
import 'package:haja/firebase/auth.dart';
import 'package:haja/firebase/firestore.dart';
import 'package:haja/language/language.dart';
import 'package:haja/login/user_state.dart';
import 'package:provider/provider.dart';

import 'display.dart';
import 'editor.dart';
import '../content.dart';

import 'package:haja/language/constants.dart';

class TeamContent extends ContentContainer {
  static const String collectionName = 'teams';

  @override
  String get collection => collectionName;

  final contentType = CONTENT.team;

  List<String> users;
  bool private;
  String picture;
  final DateTime createdOn, lastLogin;

  TeamContent({
    required this.users,
    required this.picture,
    required this.private,
    required this.createdOn,
    required this.lastLogin,
    required title,
    required caption,
    required id,
  }) : super(
          title: title,
          caption: caption,
          id: id,
        ) {
    isTeam = true;
  }

  static void makeNewTeam(BuildContext context) {
    String? userAuthId = AuthApi.activeUser;

    if (userAuthId == null) {
      if (GlobalKeys.rootScaffoldMessengerKey.currentState != null) {
        GlobalKeys.rootScaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(
            content: const Text(Language.userstateError),
            action: SnackBarAction(
              label: Language.reloginButton,
              onPressed: () => Provider.of<UserState>(context).logout(),
            ),
          ),
        );
      }
      return;
    }

    TeamContent(
      title: '',
      caption: '',
      users: [userAuthId],
      private: true,
      picture: Constants.randomDefaultPicture(),
      id: DateTime.now().toString(),
      createdOn: DateTime.now(),
      lastLogin: DateTime.now(),
    ).navigateToEditor(context);
  }

  static Future<TeamContent?> fromId(String? id) async {
    if (id == null) return null;

    var data = await FirestoreApi.get(
      id: id,
      isTeam: true,
    );

    if (data == null || !data.exists) {
      return null;
    }

    var content = data.data()!;
    content['id'] = id;

    return TeamContent.fromJson(content);
  }

  factory TeamContent.fromJson(dynamic data) => TeamContent(
        title: data['title'],
        caption: data['caption'],
        users: Constants.toStringList(data['users']),
        picture: data['picture'],
        private: data['private'],
        createdOn: data['createdOn'].toDate(),
        lastLogin: data['lastLogin'].toDate(),
        id: data['id'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'caption': caption,
        'users': users,
        'picture': picture,
        'private': private,
        'createdOn': Timestamp.fromDate(createdOn),
        'lastLogin': Timestamp.fromDate(lastLogin),
      };

  @override
  TeamContentDisplayPage navigator() {
    return TeamContentDisplayPage(this);
  }

  @override
  TeamContentEditorPage navigatorEditor() {
    return TeamContentEditorPage(this);
  }

  void leaveTeam() {
    var activeUserId = AuthApi.activeUser;

    if (activeUserId == null) return;

    users.removeWhere((userId) => activeUserId == userId);

    FirestoreApi.feel<List<String>>(
      type: collectionName,
      id: id,
      field: 'users',
      value: users,
    );
  }

  String get shareLink => '${Constants.dataLinkUri}$collectionName/$id';

  List<Future<UserContent?>> get usersContent {
    return List.generate(
      users.length,
      (index) => UserContent.fromId(
        users[index],
      ),
    );
  }

  Widget get icon => Hero(
        tag: this,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) => const Icon(
            Icons.people,
          ),
        ),
      );

  Widget get responsiveImage {
    if (picture.contains('.svg')) {
      return SvgPicture.network(
        imageUrl,
        fit: BoxFit.cover,
      );
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, err, stacktrace) => SvgPicture.network(
        Constants.randomErrorPicture(),
        fit: BoxFit.cover,
      ),
    );
  }

  String get imageUrl => Constants.storageUrlPrefix + picture;
}
