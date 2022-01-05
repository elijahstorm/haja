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
      'title': 'Documents',
      'caption': '',
      'type': 'overview',
      'data': {
        'file_source': 'document',
        'num_of_files': 1328,
        'total_storage': '1.9GB',
        'percentage': 35,
      },
      'id': 'id0',
    },
    {
      'title': 'Google Drive',
      'caption': '',
      'type': 'overview',
      'data': {
        'file_source': 'google',
        'num_of_files': 1328,
        'total_storage': '2.9GB',
        'percentage': 35,
      },
      'id': 'id1',
    },
    {
      'title': 'One Drive',
      'caption': '',
      'type': 'overview',
      'data': {
        'file_source': 'one drive',
        'num_of_files': 1328,
        'total_storage': '1GB',
        'percentage': 10,
      },
      'id': 'id2',
    },
    {
      'title': 'Documents',
      'caption': '',
      'type': 'overview',
      'data': {
        'file_source': 'dropbox',
        'num_of_files': 5328,
        'total_storage': '7.3GB',
        'percentage': 78,
      },
      'id': 'id3',
    },
    {
      'title': 'Document Files',
      'caption': '',
      'type': 'storage',
      'data': {
        'file_source': 'document',
        'num_of_files': 1328,
        'total_storage': '1.3GB',
        'percentage': 25,
      },
      'id': 'id4',
    },
    {
      'title': 'Media Files',
      'caption': '',
      'type': 'storage',
      'data': {
        'file_source': 'media',
        'num_of_files': 1328,
        'total_storage': '1.3GB',
        'percentage': 25,
      },
      'id': 'id5',
    },
    {
      'title': 'Other Files',
      'caption': '',
      'type': 'storage',
      'data': {
        'file_source': 'other',
        'num_of_files': 1328,
        'total_storage': '1.3GB',
        'percentage': 25,
      },
      'id': 'id6',
    },
    {
      'title': 'Unknown',
      'caption': '',
      'type': 'storage',
      'data': {
        'file_source': 'unknown',
        'num_of_files': 140,
        'total_storage': '1.3GB',
        'percentage': 25,
      },
      'id': 'id7',
    },
    {
      'title': '29.1',
      'caption': 'of 128GB',
      'type': 'storage pie',
      'data': {
        'pie': [
          {
            'value': 25,
            'radius': 25,
          },
          {
            'value': 20,
            'radius': 22,
          },
          {
            'value': 10,
            'radius': 19,
          },
          {
            'value': 15,
            'radius': 16,
          },
          {
            'value': 25,
            'radius': 13,
          },
        ],
      },
      'id': 'id8',
    },
  ];
}
