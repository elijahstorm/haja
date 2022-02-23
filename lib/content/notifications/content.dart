import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:haja/content/users/content.dart';
import 'package:haja/firebase/auth.dart';

import 'display.dart';
import '../content.dart';

class NotificationContent extends ContentContainer {
  static const String collectionName = 'notos';

  @override
  String get collection => collectionName;
  final contentType = CONTENT.notification;

  @override
  bool get privateData => true;

  final DateTime date;
  final String type, status;

  String get name => title;
  Widget? get postImage => icon;
  bool get hasStory => true;
  String fromId;

  NotificationContent({
    required this.date,
    required this.type,
    required this.status,
    required this.fromId,
    required title,
    required caption,
    required id,
  }) : super(
          title: title,
          caption: caption,
          id: id,
        );

  factory NotificationContent.fromJson(dynamic data) => NotificationContent(
        title: data['title'],
        caption: data['caption'],
        date: data['date'].toDate(),
        type: data['type'],
        status: data['status'],
        fromId: data['fromId'],
        id: data['id'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'caption': caption,
        'date': Timestamp.fromDate(date),
        'type': type,
        'status': status,
        'fromId': fromId,
      };

  @override
  NotificationContentDisplayPage navigator() {
    return NotificationContentDisplayPage(this);
  }

  Future<UserContent?> get from async =>
      await UserContent.fromId(sourceId ?? AuthApi.activeUser);

  Widget get icon {
    Color color = Colors.blue;
    String asset = 'assets/icons/google-docs.svg';

    switch (type) {
      case 'account':
        asset = 'assets/icons/user.svg';
        color = Colors.yellow;
        break;
      case 'message':
        asset = 'assets/icons/email.svg';
        color = Colors.purple;
        break;
      case 'important':
        asset = 'assets/icons/danger.svg';
        color = Colors.red;
        break;
      case 'success':
        asset = 'assets/icons/checked.svg';
        color = Colors.green;
        break;
      case 'document':
        asset = 'assets/icons/google-docs.svg';
        color = Colors.blue;
        break;
      default:
        asset = 'assets/icons/google-docs.svg';
        color = Colors.blue;
        break;
    }

    return Container(
      color: color.withOpacity(0.3),
      padding: const EdgeInsets.all(6),
      child: SvgPicture.asset(
        asset,
        color: color.withOpacity(0.7),
      ),
    );
  }

  static String todoLikedType = 'tl';
  static String todoCompleteType = 'tc';
  static String unreadStatus = 'ur';
  static String readStatus = 'r';
}
