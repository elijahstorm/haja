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
      'title': 'XD File',
      'caption': '3.5mb',
      'file_type': 0,
      'cloud_link': '/',
      'created_on': Timestamp.fromDate(DateTime.parse('20210301')),
      'edited_on': Timestamp.fromDate(DateTime.now()),
      'id': 'id0',
    },
    {
      'title': 'Figma File',
      'caption': '19.0mb',
      'file_type': 1,
      'cloud_link': '/',
      'created_on': Timestamp.fromDate(DateTime.parse('20210227')),
      'edited_on': Timestamp.fromDate(DateTime.now()),
      'id': 'id1',
    },
    {
      'title': 'Document',
      'caption': '32.5mb',
      'file_type': 2,
      'cloud_link': '/',
      'created_on': Timestamp.fromDate(DateTime.parse('20210223')),
      'edited_on': Timestamp.fromDate(DateTime.now()),
      'id': 'id2',
    },
    {
      'title': 'Sound File',
      'caption': '3.5mb',
      'file_type': 3,
      'cloud_link': '/',
      'created_on': Timestamp.fromDate(DateTime.parse('20210221')),
      'edited_on': Timestamp.fromDate(DateTime.now()),
      'id': 'id3',
    },
    {
      'title': 'Media File',
      'caption': '2.5gb',
      'file_type': 4,
      'cloud_link': '/',
      'created_on': Timestamp.fromDate(DateTime.parse('20210223')),
      'edited_on': Timestamp.fromDate(DateTime.now()),
      'id': 'id4',
    },
    {
      'title': 'Sales PDF',
      'caption': '3.5mb',
      'file_type': 5,
      'cloud_link': '/',
      'created_on': Timestamp.fromDate(DateTime.parse('20210225')),
      'edited_on': Timestamp.fromDate(DateTime.now()),
      'id': 'id5',
    },
    {
      'title': 'Excel File',
      'caption': '34.5mb',
      'file_type': 6,
      'cloud_link': '/',
      'created_on': Timestamp.fromDate(DateTime.parse('20210225')),
      'edited_on': Timestamp.fromDate(DateTime.now()),
      'id': 'id6',
    },
  ];
}
