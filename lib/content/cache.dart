import 'package:flutter/foundation.dart';

import 'package:haja/firebase/firestore.dart';

import 'content.dart';

class ContentCache<T extends ContentContainer> extends ChangeNotifier {
  final List<T> _items = [];
  List<T> get items => List.unmodifiable(_items);
  void download() {}
  T? fromJson(dynamic data) => null;

  List<FirestoreFilter> filters = [];

  ContentCache({
    bool haltDownload = false,
  }) {
    if (haltDownload) return;
    download();
  }

  void populate(T content) {
    content.synchedWithDatabase = true;
    add(content);
  }

  void add(T content) {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].id == content.id) return;
    }

    _items.add(content);

    notify();
  }

  void remove(T item) {
    _items.removeWhere((check) => check.id == item.id);

    notify();
  }

  void removeAll() {
    _items.clear();

    notify();
  }

  void notify() {
    _performSort();
    notifyListeners();
  }

  void _performSort() {
    var sortStyle = sorter();

    if (sortStyle == null) return;

    _items.sort(sortStyle);
  }

  int Function(T, T)? sorter() => null;

  List<T> filter(
    String query, {
    int limit = 10,
  }) {
    List<T> content = [];
    var list = items;

    for (int i = 0; i < list.length && content.length < limit; i++) {
      if (list[i].find(query)) {
        content.add(list[i]);
      }
    }

    return content;
  }

  T? at(String query) {
    var list = items;

    for (int i = 0; i < list.length; i++) {
      if (list[i].find(query)) {
        return list[i];
      }
    }

    return null;
  }
}
