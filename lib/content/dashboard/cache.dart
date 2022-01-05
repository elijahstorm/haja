import '../cache.dart';
import 'content.dart';
import 'mock_content.dart';

import 'package:haja/firebase/firestore.dart';
import 'package:haja/firebase/auth.dart';

class DashboardCache extends ContentCache<DashboardContent> {
  @override
  List<Map<String, dynamic>> get mockData => MockContent.all;

  @override
  DashboardContent fromJson(dynamic data) => DashboardContent.fromJson(data);

  @override
  void download() async => FirestoreApi.download(
        DashboardContent.collectionName,
        limit: 10,
        id: AuthApi.activeUser,
        // id: await AuthApi.active_team,
        populate: (dynamic data) => populate(
          DashboardContent.fromJson(data),
        ),
      );
}
