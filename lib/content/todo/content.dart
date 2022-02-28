import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:haja/firebase/auth.dart';
import 'package:haja/firebase/firestore.dart';
import 'package:haja/language/constants.dart';

import 'display.dart';
import '../content.dart';

class TodoContent extends ContentContainer {
  static const String collectionName = 'todo';
  @override
  String get collection => collectionName;
  final contentType = CONTENT.todo;
  @override
  bool get privateData => true;

  DateTime date;
  String type, status, color;
  bool editing;

  TodoContent({
    required this.date,
    required this.type,
    required this.status,
    required this.color,
    required title,
    required caption,
    required id,
    this.editing = false,
  }) : super(
          title: title,
          caption: caption,
          id: id,
        );

  factory TodoContent.fromJson(dynamic data) => TodoContent(
        title: data['title'],
        caption: data['caption'],
        date: data['date'].toDate(),
        color: data['color'],
        type: data['type'],
        status: data['status'],
        id: data['id'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'caption': caption,
        'date': Timestamp.fromDate(date),
        'color': color,
        'type': type,
        'status': status,
      };

  @override
  TodoContentDisplayPage navigator() {
    return TodoContentDisplayPage(this);
  }

  String get shareLink =>
      '${Constants.linkUri}$collectionName?owner=${isTeam ? sourceId : AuthApi.activeUser}&id=$id&isTeam=$isTeam';

  Future<bool> toggleLiked() async {
    like = !await liked;
    return liked;
  }

  bool? _likeHandler;
  Future<bool> get liked async {
    if (AuthApi.activeUser == null) return false;

    if (_likeHandler != null) {
      return _likeHandler!;
    }

    _likeHandler = await FirestoreApi.feelings(
          type: 'feelings',
          id: '${AuthApi.activeUser}:$id',
          field: 'todoLiked',
        ) ??
        false;

    return _likeHandler!;
  }

  set like(bool value) {
    if (AuthApi.activeUser == null) return;

    FirestoreApi.feel<bool>(
      type: 'feelings',
      id: '${AuthApi.activeUser}:$id',
      field: 'todoLiked',
      value: value,
    );

    _likeHandler = value;
  }

  bool toggleFinished() {
    if (status == TodoContent.finishedStatus) {
      status = TodoContent.unfinishedStatus;
    } else {
      status = TodoContent.finishedStatus;
    }

    return status == TodoContent.finishedStatus;
  }

  bool get isDone {
    return status == TodoContent.finishedStatus;
  }

  bool get isNotDone {
    return status == TodoContent.unfinishedStatus;
  }

  static const String finishedStatus = 'done';
  static const String unfinishedStatus = 'todo';
  static const String typeMessageFromHajaTeam = 'from_haja';
}
