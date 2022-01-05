import '../cache.dart';
import 'content.dart';
import 'mock_content.dart';

import 'package:haja/firebase/firestore.dart';

class AdvertisementCache extends ContentCache<AdvertisementContent> {
  @override
  List<Map<String, dynamic>> get mockData => MockContent.all;

  @override
  AdvertisementContent fromJson(dynamic data) =>
      AdvertisementContent.fromJson(data);

  @override
  void download() => FirestoreApi.download(
        AdvertisementContent.collectionName,
        limit: 10,
        populate: (dynamic data) => populate(
          AdvertisementContent.fromJson(data),
        ),
      );
}
