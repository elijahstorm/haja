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
      'link': '/',
      'id': 'jennie',
    },
    {
      'title': 'donghee',
      'caption': 'I\'m an actor, but I will never be fake with you ;)',
      'link': '/',
      'id': 'donghee',
    },
    {
      'title': 'Lee Ji-eun',
      'caption': 'Some people call me IU, but you can call me love',
      'link': '/',
      'id': 'iu',
    },
    {
      'title': 'Jack Black',
      'caption': 'We came to ROCK!',
      'link': '/',
      'id': 'jackblack',
    },
    {
      'title': 'Snoop Doggy Dog',
      'caption':
          'if you dont bring some smoke to the golf course... dont worry ill bring it',
      'link': '/',
      'id': 'snoop',
    },
    {
      'title': 'Tiger Woods',
      'caption': 'I know you know who I am',
      'link': '/',
      'id': 'tigerwoods',
    },
    {
      'title': 'Dorothy Oz',
      'caption': 'I don\'t think I\'m in Kansas anymore...',
      'link': '/',
      'id': 'dorothy',
    },
  ];
}
