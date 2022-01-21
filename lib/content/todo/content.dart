import 'package:cloud_firestore/cloud_firestore.dart';

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

  void toggleFinished() {
    if (status == TodoContent.finishedStatus) {
      status = TodoContent.unfinishedStatus;
    } else {
      status = TodoContent.finishedStatus;
    }
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
