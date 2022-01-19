import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:haja/content/content.dart';

import 'core.dart';
import 'auth.dart';

class FirestoreApi {
  static bool restrictUploads = false;
  static bool _denyUpload() {
    return FirebaseApi.disabled || restrictUploads;
  }

  static bool restrictDeletions = false;
  static bool _denyDelete() {
    return FirebaseApi.disabled || restrictDeletions;
  }

  static bool restrictDownloads = false;
  static bool _denyDownload() {
    return FirebaseApi.disabled || restrictDownloads;
  }

  static void _grab({
    required dynamic query,
    required int limit,
    required void Function(dynamic) populate,
  }) {
    query.limit(limit).get().then(
      (QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        for (var doc in querySnapshot.docs) {
          if (!doc.exists) return;

          Map<String, dynamic> data = doc.data();
          data['id'] = doc.id;

          if (data['id'] == 'info') return;

          populate(data);
        }
      },
    );
  }

  static dynamic _filter({
    required Query query,
    required List<FirestoreFilter> filters,
  }) {
    for (var filter in filters) {
      query = filter.process(query);
    }

    return query;
  }

  static void _getPrivateData({
    required void Function(dynamic) populate,
    required String type,
    required String access,
    required String collection,
    required List<FirestoreFilter> filters,
    required int limit,
  }) {
    _grab(
      query: _filter(
        query: FirebaseFirestore.instance
            .collection(type)
            .doc(access)
            .collection(collection),
        filters: filters,
      ),
      limit: limit,
      populate: populate,
    );
  }

  static void _getContent({
    required void Function(dynamic) populate,
    required String collection,
    required List<FirestoreFilter> filters,
    required int limit,
  }) {
    _grab(
      query: _filter(
        query: FirebaseFirestore.instance.collection(collection),
        filters: filters,
      ),
      limit: limit,
      populate: populate,
    );
  }

  static void download(
    String collection, {
    required void Function(dynamic) populate,
    String? id,
    bool isTeam = false,
    List<FirestoreFilter> filters = const [],
    int limit = 10,
  }) {
    if (_denyDownload()) return;

    if (id != null) {
      _getPrivateData(
        type: isTeam ? 'teams' : 'users',
        access: id,
        collection: collection,
        filters: filters,
        limit: limit,
        populate: populate,
      );
    } else {
      _getContent(
        collection: collection,
        filters: filters,
        limit: limit,
        populate: populate,
      );
    }
  }

  static Widget future({
    required String field,
    required String id,
    String? collection,
    String? document,
    bool isTeam = false,
    required Widget Function(BuildContext, dynamic) builder,
    required Widget Function(String) onError,
  }) {
    if (_denyDownload()) {
      return onError('downloads currently FirebaseApi.disabled');
    }

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      future: FirestoreApi.get(
        field: field,
        id: id,
        collection: collection,
        document: document,
        isTeam: isTeam,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return onError('FirestoreApi->future Error: ${snapshot.error}');
        }

        if (!snapshot.data!.exists || snapshot.data!.data()![field] == null) {
          return onError('FirestoreApi->future Error: data does not exist');
        }

        return builder(context, snapshot.data!.data()![field]);
      },
    );
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>?> get({
    required String field,
    required String id,
    String? collection,
    String? document,
    bool isTeam = false,
  }) async {
    if (_denyDownload()) return null;

    var query = FirebaseFirestore.instance
        .collection(isTeam ? 'teams' : 'users')
        .doc(id);

    if (collection != null && document != null) {
      query = query.collection(collection).doc(document);
    }

    return query.get();
  }

  static Stream<DocumentSnapshot>? stream(
    String collection, {
    String? id,
    String? document,
    bool isTeam = false,
  }) {
    if (_denyDownload()) return null;

    return FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .snapshots();
  }

  static void upload(
    ContentContainer content, {
    String? id,
    bool isTeam = false,
    void Function(ContentContainer)? onComplete,
    void Function(String, ContentContainer)? onError,
  }) async {
    if (_denyUpload()) {
      if (onError != null) {
        onError('Upload denied by FirebaseAPI', content);
      }
      return;
    }

    if (id == null) {
      id = AuthApi.activeUser;

      if (id == null) {
        if (onError != null) {
          onError('Uploader ID could not be auto-generated', content);
        }
        return;
      }
    }

    dynamic docRef =
        FirebaseFirestore.instance.collection(isTeam ? 'teams' : 'users');

    if (content.privateData) {
      docRef = docRef.doc(id).collection(content.collection);

      if (!content.synchedWithDatabase) {
        docRef = docRef.add(content.toJson());
      } else {
        docRef = docRef.doc(content.id).update(content.toJson());
      }
    } else {
      if (!content.synchedWithDatabase) {
        if (isTeam) {
          docRef = docRef.add(content.toJson());
        } else {
          docRef = docRef.doc(id).set(content.toJson());
        }
      } else {
        docRef = docRef.doc(id).update(content.toJson());
      }
    }

    docRef.then((value) {
      if (onComplete != null) onComplete(content);

      if (content.synchedWithDatabase) return;

      content.synchedWithDatabase = true;
      content.id = value.id ?? '';

      dynamic docRef =
          FirebaseFirestore.instance.collection(isTeam ? 'teams' : 'users');

      if (content.privateData) {
        docRef = docRef.doc(id).collection(content.collection);
      }

      docRef = docRef.doc('info');

      docRef.update({'numOfDocs': FieldValue.increment(1)}).catchError((error) {
        docRef
            .set({'numOfDocs': 1}, SetOptions(merge: true)).catchError((error) {
          if (onError != null) onError('$error', content);
        });
      });
    }).catchError((error) {
      if (onError != null) onError('$error', content);
    });
  }

  static void delete(
    ContentContainer content, {
    String? id,
    bool isTeam = false,
    void Function(ContentContainer)? onComplete,
    void Function(String, ContentContainer)? onError,
  }) async {
    if (!content.synchedWithDatabase) return;

    if (_denyDelete()) {
      if (onError != null) {
        onError('Delete denied by FirebaseAPI', content);
      }
      return;
    }

    if (id == null) {
      id = AuthApi.activeUser;

      if (id == null) {
        if (onError != null) {
          onError('Uploader ID could not be auto-generated', content);
        }
        return;
      }
    }

    dynamic docRef = FirebaseFirestore.instance
        .collection(isTeam ? 'teams' : 'users')
        .doc(id);

    if (content.privateData) {
      docRef = docRef.collection(content.collection).doc(content.id);
    }

    docRef.delete().then((value) {
      if (onComplete != null) onComplete(content);

      content.synchedWithDatabase = false;

      dynamic docRef =
          FirebaseFirestore.instance.collection(isTeam ? 'teams' : 'users');

      if (content.privateData) {
        docRef = docRef.doc(id).collection(content.collection);
      }

      docRef = docRef.doc('info');

      docRef
          .update({'numOfDocs': FieldValue.increment(-1)}).catchError((error) {
        if (onError != null) onError('$error', content);
      });
    }).catchError((error) {
      if (onError != null) onError('$error', content);
    });
  }
}

class FirestoreFilter {
  late final FirestoreFilterTypes filter;
  late final dynamic data;

  FirestoreFilter({
    required this.filter,
    required this.data,
  });

  FirestoreFilter.activeUserTeams() {
    filter = FirestoreFilterTypes.activeUserTeams;
    data = AuthApi.activeUser;
  }

  FirestoreFilter.recent() {
    filter = FirestoreFilterTypes.timeFrame;
    data = [DateTime.now().subtract(const Duration(days: 30)), DateTime.now()];
  }

  FirestoreFilter.search(String search) {
    filter = FirestoreFilterTypes.search;
    data = search;
  }

  FirestoreFilter.singleId(String id) {
    filter = FirestoreFilterTypes.singleId;
    data = id;
  }

  FirestoreFilter.onlyTeam() {
    filter = FirestoreFilterTypes.onlyTeam;
    data = '';
  }

  FirestoreFilter.onlyFriends() {
    filter = FirestoreFilterTypes.onlyFriends;
    data = '';
  }

  FirestoreFilter.onlyNonFriends() {
    filter = FirestoreFilterTypes.onlyNonFriends;
    data = '';
  }

  Query process(Query query) => filter.process(query, data);
}

enum FirestoreFilterTypes {
  activeUserTeams,
  timeFrame,
  search,
  singleId,
  onlyTeam,
  onlyFriends,
  onlyNonFriends,
}

extension FirestoreFilterTypesExtension on FirestoreFilterTypes {
  Query process(Query query, dynamic data) {
    switch (this) {
      case FirestoreFilterTypes.search:
        return query.where(
          'title',
          isEqualTo: data,
        );
      case FirestoreFilterTypes.timeFrame:
        return query
            .where(
              'date',
              isGreaterThan: data[0],
            )
            .where(
              'date',
              isLessThan: data[1],
            );
      case FirestoreFilterTypes.activeUserTeams:
        return query.where(
          'users',
          arrayContains: AuthApi.activeUser,
        );
      default:
        return query;
    }
  }
}
