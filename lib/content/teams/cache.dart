import '../cache.dart';
import 'content.dart';

import 'package:haja/firebase/firestore.dart';

class TeamsCache extends ContentCache<TeamContent> {
  @override
  TeamContent fromJson(dynamic data) => TeamContent.fromJson(data);

  TeamsCache.activeUserTeams() {
    filters = [FirestoreFilter.activeUserTeams()];
    download();
  }
  TeamsCache.fromActiveUsersNetwork() {
    filters = [FirestoreFilter.onlyNonFriends()];
    download();
  }
  TeamsCache.search(String searchTerms) {
    filters = [FirestoreFilter.search(searchTerms)];
    download();
  }

  @override
  void download() => FirestoreApi.download(
        TeamContent.collectionName,
        limit: 25,
        isTeam: true,
        filters: filters,
        populate: (dynamic data) => populate(
          TeamContent.fromJson(data),
        ),
      );
}
