import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'display.dart';
import 'editor.dart';
import '../content.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/content/todo/content.dart';

class TeamContent extends ContentContainer {
  static const String collectionName = 'teams';

  @override
  String get collection => collectionName;

  @override
  bool get isTeam => true;
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
        );

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

  Widget get icon {
    return const Icon(Icons.people);
  }

  String get imageUrl {
    return Constants.storageUrlPrefix + picture;
  }

  Future<List<TodoContent>> get activeTodos async {
    return [];
  }
}
