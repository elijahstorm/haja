import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haja/firebase/firestore.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/firebase/auth.dart';

import 'display.dart';
import 'editor.dart';
import '../content.dart';

class UserContent extends ContentContainer {
  static const String collectionName = 'users';

  @override
  String get collection => collectionName;
  final contentType = CONTENT.user;

  String email, picture;
  List<String> pronouns, following;
  bool private;
  final bool online, verified;
  final DateTime createdOn, lastLogin;

  UserContent({
    required this.email,
    required this.picture,
    required this.pronouns,
    required this.following,
    required this.online,
    required this.verified,
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

  factory UserContent.fromJson(dynamic data) => UserContent(
        email: data['email'] ?? UserContent.defaultData['email'],
        picture: data['picture'] ?? UserContent.defaultData['picture'],
        title: data['title'] ?? UserContent.defaultData['title'],
        caption: data['caption'] ?? UserContent.defaultData['caption'],
        pronouns: Constants.toStringList(data['pronouns']),
        following: Constants.toStringList(data['following']),
        online: data['online'] ?? UserContent.defaultData['online'],
        verified: data['verified'] ?? UserContent.defaultData['verified'],
        private: data['private'] ?? UserContent.defaultData['private'],
        createdOn: (data['createdOn'] ?? UserContent.defaultData['createdOn'])
            .toDate(),
        lastLogin: (data['lastLogin'] ?? UserContent.defaultData['lastLogin'])
            .toDate(),
        id: data['id'] ?? UserContent.defaultData['id'],
      );

  static Future<UserContent?> fromId(String? id) async {
    if (id == null) return null;

    var data = await FirestoreApi.get(
      id: id,
    );

    if (data == null || !data.exists) {
      return null;
    }

    var content = data.data()!;
    content['id'] = id;

    return UserContent.fromJson(content);
  }

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'caption': caption,
        'email': email,
        'picture': picture,
        'pronouns': pronouns,
        'following': following,
        'online': online,
        'verified': verified,
        'private': private,
        'createdOn': Timestamp.fromDate(createdOn),
        'lastLogin': Timestamp.fromDate(lastLogin),
      };

  bool get isFollowing => following.contains(AuthApi.activeUser);

  static Widget get placeholderIcon => Image.asset(
        Constants.placeholderUserIcon,
        fit: BoxFit.fill,
      );

  Widget get icon => Hero(
        tag: '$collectionName$id',
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
          errorBuilder: (context, _, __) => placeholderIcon,
        ),
      );

  String get imageUrl => Constants.storageUrlPrefix + picture;

  String get pronounsString {
    String run = '';
    for (var element in pronouns) {
      run += '$element, ';
    }
    return run.substring(0, run.length - 2);
  }

  static Map<String, dynamic> defaultData = {
    'title': 'Anonymous',
    'caption': '',
    'email': '',
    'picture': '',
    'pronouns': [],
    'following': [],
    'online': false,
    'verified': false,
    'private': false,
    'createdOn': Timestamp.now(),
    'lastLogin': Timestamp.now(),
    'id': '',
  };

  @override
  UserContentDisplayPage navigator() {
    return UserContentDisplayPage(this);
  }

  @override
  UserContentEditorPage navigatorEditor() {
    return UserContentEditorPage(this);
  }

  List<Future<UserContent>> get followingListContent {
    return [];
  }

  String get shareLink => '${Constants.linkUri}$collectionName?id=$id';
}
