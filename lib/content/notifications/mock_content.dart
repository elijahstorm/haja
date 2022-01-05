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
      'date': Timestamp.fromDate(DateTime.parse('20210225')),
      'status': 'read',
      'id': 'jennie',
    },
    {
      'title': 'Message from Admin',
      'caption': '',
      'type': 'message',
      'date': Timestamp.fromDate(DateTime.parse('20210225')),
      'status': 'read',
      'id': 'linkMessage',
    },
    {
      'title': 'New Task from Admin',
      'caption': 'Init Training Model',
      'type': 'important',
      'date': Timestamp.fromDate(DateTime.parse('20210223')),
      'status': 'read',
      'id': 'linkNew',
    },
    {
      'title': 'Message from Phil',
      'caption': 'Imaging',
      'type': 'message',
      'date': Timestamp.fromDate(DateTime.parse('20210221')),
      'status': 'unread',
      'id': 'linkMessage2',
    },
    {
      'title': 'Task Completed',
      'caption': 'Init Training Model',
      'type': 'success',
      'date': Timestamp.fromDate(DateTime.parse('20210223')),
      'status': 'unread',
      'id': 'linkTask',
    },
    {
      'title': 'Reply to your Comment',
      'caption': '[The new cameras are great...]',
      'type': 'message',
      'date': Timestamp.fromDate(DateTime.parse('20210227')),
      'status': 'unread',
      'id': 'linkReply',
    },
    {
      'title': 'Activity Report Submitted',
      'caption': '',
      'type': 'document',
      'date': Timestamp.fromDate(DateTime.parse('20210301')),
      'status': 'read',
      'id': 'linkActivity',
    },
  ];
}
