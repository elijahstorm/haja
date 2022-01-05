import '../cache.dart';
import 'content.dart';
import 'mock_content.dart';

import 'package:haja/firebase/firestore.dart';
import 'package:haja/firebase/auth.dart';

class UserCache extends ContentCache<UserContent> {
  @override
  List<Map<String, dynamic>> get mockData => MockContent.all;

  @override
  UserContent fromJson(dynamic data) => UserContent.fromJson(data);

  UserCache.friends(String? id) {
    filters = [
      FirestoreFilter.singleId(id ?? AuthApi.activeUser ?? ''),
      FirestoreFilter.onlyFriends(),
    ];
    download();
  }
  UserCache.nonFriends(String? id) {
    filters = [
      FirestoreFilter.singleId(id ?? AuthApi.activeUser ?? ''),
      FirestoreFilter.onlyNonFriends(),
    ];
    download();
  }
  UserCache.team(String? id) {
    filters = [
      FirestoreFilter.singleId(id ?? AuthApi.activeUser ?? ''),
      FirestoreFilter.onlyTeam(),
    ];
    download();
  }
  UserCache.search(String searchTerms) {
    filters = [FirestoreFilter.search(searchTerms)];
    download();
  }

  @override
  void download() => FirestoreApi.download(
        UserContent.collectionName,
        limit: 10,
        filters: filters,
        populate: (dynamic data) => populate(
          UserContent.fromJson(data),
        ),
      );
}
