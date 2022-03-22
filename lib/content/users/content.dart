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
  List<String> pronouns;
  bool private;
  final bool online, verified;
  final DateTime createdOn, lastLogin;

  UserContent({
    required this.email,
    required this.picture,
    required this.pronouns,
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
        'online': online,
        'verified': verified,
        'private': private,
        'createdOn': Timestamp.fromDate(createdOn),
        'lastLogin': Timestamp.fromDate(lastLogin),
      };

  static Widget get placeholderIcon => Image.asset(
        Constants.placeholderUserIcon,
        fit: BoxFit.fill,
      );

  Widget get icon => Hero(
        tag: '$collectionName$id',
        child: picture == ''
            ? placeholderIcon
            : Image.network(
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

  FollowType? _followHandler;
  void follow({
    FollowType followType = FollowType.follow,
  }) {
    if (AuthApi.activeUser == null || id == AuthApi.activeUser) return;

    FirestoreApi.feel<String>(
      type: 'follow',
      id: '${AuthApi.activeUser!}:$id',
      field: 'type',
      value: followType.value,
    );

    _followHandler = followType;
  }

  Future<bool> following({
    bool atActiveUser = false,
  }) async {
    if (AuthApi.activeUser == null) return false;

    if (_followHandler != null) {
      return _followHandler!.following;
    }

    var value = await FirestoreApi.feelings(
      type: 'follow',
      id: atActiveUser
          ? '$id:${AuthApi.activeUser}'
          : '${AuthApi.activeUser}:$id',
      field: 'type',
    );

    FollowType answer = FollowType.unfollow;

    switch (value) {
      case 'f':
        answer = FollowType.follow;
        break;
      case 'u':
        answer = FollowType.unfollow;
        break;
      case 'b':
        answer = FollowType.block;
        break;
    }
    _followHandler = answer;

    return _followHandler!.following;
  }

  String get shareLink => '${Constants.dataLinkUri}$collectionName/$id';
}

enum FollowType {
  follow,
  unfollow,
  block,
}

extension FollowTypeExtension on FollowType {
  String get value {
    switch (this) {
      case FollowType.follow:
        return 'f';
      case FollowType.unfollow:
        return 'u';
      case FollowType.block:
        return 'b';
    }
  }

  bool compare(String that) {
    switch (this) {
      case FollowType.follow:
        return that == 'f';
      case FollowType.unfollow:
        return that == 'u';
      case FollowType.block:
        return that == 'b';
    }
  }

  bool get following {
    switch (this) {
      case FollowType.follow:
        return true;
      case FollowType.unfollow:
        return false;
      case FollowType.block:
        return false;
    }
  }
}
