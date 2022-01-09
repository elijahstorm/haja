import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haja/constants.dart';

import 'display.dart';
import '../content.dart';

import 'package:haja/content/todo/content.dart';

class TeamContent extends ContentContainer {
  static const String collectionName = 'teams';

  @override
  String get collection => collectionName;

  @override
  bool get isTeam => true;
  final contentType = CONTENT.team;

  final List<String> users;
  final bool private;
  final DateTime createdOn, lastLogin;

  TeamContent({
    required this.users,
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
        'private': private,
        'createdOn': Timestamp.fromDate(createdOn),
        'lastLogin': Timestamp.fromDate(lastLogin),
      };

  @override
  TeamContentDisplayPage navigator() {
    return TeamContentDisplayPage(this);
  }

  Widget get icon {
    return const Icon(Icons.people);
  }

  Future<List<TodoContent>> get activeTodos async {
    return [];
  }
}
