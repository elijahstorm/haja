import '../cache.dart';
import 'content.dart';
import 'mock_content.dart';

import 'package:haja/firebase/firestore.dart';
import 'package:haja/firebase/auth.dart';

class NotificationCache extends ContentCache<NotificationContent> {
  @override
  List<Map<String, dynamic>> get mockData => MockContent.all;

  NotificationCache.friends();
  NotificationCache();

  @override
  NotificationContent fromJson(dynamic data) =>
      NotificationContent.fromJson(data);

  @override
  void download() async => FirestoreApi.download(
        NotificationContent.collectionName,
        limit: 10,
        id: AuthApi.activeUser,
        // id: await AuthApi.active_team,
        populate: (dynamic data) => populate(
          NotificationContent.fromJson(data),
        ),
      );
}
