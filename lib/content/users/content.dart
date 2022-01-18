import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/firebase/auth.dart';

import 'display.dart';
import '../content.dart';

class UserContent extends ContentContainer {
  static const String collectionName = 'users';

  @override
  String get collection => collectionName;
  final contentType = CONTENT.user;

  String email, pic;
  List<String> pronouns, following;
  final bool online, verified;
  final DateTime createdOn, lastLogin;

  UserContent({
    required this.email,
    required this.pic,
    required this.pronouns,
    required this.following,
    required this.online,
    required this.verified,
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
        pic: data['pic'] ?? UserContent.defaultData['pic'],
        title: data['title'] ?? UserContent.defaultData['title'],
        caption: data['caption'] ?? UserContent.defaultData['caption'],
        pronouns: Constants.toStringList(data['pronouns']),
        following: Constants.toStringList(data['following']),
        online: data['online'] ?? UserContent.defaultData['online'],
        verified: data['verified'] ?? UserContent.defaultData['verified'],
        createdOn: (data['createdOn'] ?? UserContent.defaultData['createdOn'])
            .toDate(),
        lastLogin: (data['lastLogin'] ?? UserContent.defaultData['lastLogin'])
            .toDate(),
        id: data['id'] ?? UserContent.defaultData['id'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'caption': caption,
        'email': email,
        'pic': pic,
        'pronouns': pronouns,
        'following': following,
        'online': online,
        'verified': verified,
        'createdOn': Timestamp.fromDate(createdOn),
        'lastLogin': Timestamp.fromDate(lastLogin),
      };

  bool get isFollowing => following.contains(AuthApi.activeUser);

  Widget get icon => Hero(
        tag: id,
        child: pic == ''
            ? SvgPicture.network(
                Constants.liveSvgs + id + '.svg',
                fit: BoxFit.fill,
              )
            : Image.network(pic),
      );

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
    'pic': '',
    'pronouns': [],
    'following': [],
    'online': false,
    'verified': false,
    'createdOn': Timestamp.now(),
    'lastLogin': Timestamp.now(),
    'id': '',
  };

  @override
  UserContentDisplayPage navigator() {
    return UserContentDisplayPage(this);
  }
}
