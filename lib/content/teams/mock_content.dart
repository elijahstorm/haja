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
      'title': 'Jennie',
      'caption':
          'Just a girl from the New Zealand who moved to Korea to follow my passion',
      'image': '/',
      'sex': 'female',
      'online': true,
      'verified': true,
      'created_on': Timestamp.fromDate(DateTime.parse('20210102')),
      'last_login': Timestamp.fromDate(DateTime.now()),
      'id': 'jennie1',
    },
    {
      'title': 'donghee',
      'caption': 'I\'m an actor, but I will never be fake with you ;)',
      'image': '/',
      'sex': 'male',
      'online': false,
      'verified': true,
      'created_on': Timestamp.fromDate(DateTime.parse('20210102')),
      'last_login': Timestamp.fromDate(DateTime.now()),
      'id': 'donghee1',
    },
    {
      'title': 'Lee Ji-eun',
      'caption': 'Some people call me IU, but you can call me love',
      'image': '/',
      'sex': 'female',
      'online': true,
      'verified': true,
      'created_on': Timestamp.fromDate(DateTime.parse('20210102')),
      'last_login': Timestamp.fromDate(DateTime.now()),
      'id': 'iu1',
    },
  ];
}
