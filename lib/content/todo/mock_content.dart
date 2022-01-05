import 'package:cloud_firestore/cloud_firestore.dart';

class MockContent {
  static List<Map<String, dynamic>> get all {
    List<Map<String, dynamic>> list = [];

    for (int i = 0; i < data.length; i++) {
      list.add(data[i]);
    }

    return list;
  }

  static List<Map<String, dynamic>> data = [
    {
      'title': 'New Account',
      'caption': '',
      'type': 'account',
      'status': 'done',
      'color': 'blue',
      'date': Timestamp.fromDate(DateTime.parse('20210225')),
      'id': 'jennie',
    },
    {
      'title': 'Message from Admin',
      'caption': '',
      'type': 'message',
      'status': 'done',
      'color': 'blue',
      'date': Timestamp.fromDate(DateTime.parse('20210225')),
      'id': 'linkMessage',
    },
    {
      'title': 'New Task from Admin',
      'caption': 'Init Training Model',
      'type': 'important',
      'status': 'done',
      'color': 'blue',
      'date': Timestamp.fromDate(DateTime.parse('20210223')),
      'id': 'linkNew',
    },
    {
      'title': 'Message from Phil',
      'caption': 'Imaging',
      'type': 'message',
      'status': 'todo',
      'color': 'blue',
      'date': Timestamp.fromDate(DateTime.parse('20210221')),
      'id': 'linkMessage2',
    },
    {
      'title': 'Task Completed',
      'caption': 'Init Training Model',
      'type': 'success',
      'status': 'todo',
      'color': 'blue',
      'date': Timestamp.fromDate(DateTime.parse('20210223')),
      'id': 'linkTask',
    },
    {
      'title': 'Reply to your Comment',
      'caption': '[The new cameras are great...]',
      'type': 'message',
      'status': 'todo',
      'color': 'blue',
      'date': Timestamp.fromDate(DateTime.parse('20210227')),
      'id': 'linkReply',
    },
    {
      'title': 'Activity Report Submitted',
      'caption': '',
      'type': 'document',
      'status': 'done',
      'color': 'blue',
      'date': Timestamp.fromDate(DateTime.parse('20210301')),
      'id': 'linkActivity',
    },
  ];
}
