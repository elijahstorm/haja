import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haja/content/users/content.dart';
import 'package:haja/firebase/firestore.dart';

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
    // TODO leave team
  }

  String get shareLink {
    return '${Constants.linkUri}team?id=$id';
  }

  List<Future<UserContent?>> get usersContent {
    return List.generate(
      users.length,
      (index) => UserContent.fromId(
        users[index],
      ),
    );
  }

  Widget get icon => Hero(
        tag: '$collectionName$id',
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) => const Icon(
            Icons.people,
          ),
        ),
      );

  Widget get responsiveImage {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, err, stacktrace) => Image.asset(
        Constants.defaultTeamPicture,
        fit: BoxFit.contain,
      ),
    );
  }

  String get imageUrl => Constants.storageUrlPrefix + picture;
}
