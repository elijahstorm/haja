import 'package:haja/firebase/firestore.dart';

// seems potentially not useful?
class DelayedContentData<T> {
  T? _data;
  String id, field;
  bool isTeam;
  String? collection, document;

  DelayedContentData({
    required this.id,
    required this.field,
    this.isTeam = false,
    this.collection,
    this.document,
  });

  Future<T?> request() async {
    var snapshot = await FirestoreApi.get(
      id: id,
      isTeam: isTeam,
      collection: collection,
      document: document,
    );

    if (!snapshot!.exists) {
      return null;
    }

    _data = snapshot.data()![field];

    return _data;
  }

  Future<T?> get data async {
    return await request();
  }
}
