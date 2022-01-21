import '../cache.dart';
import 'content.dart';
import 'mock_content.dart';

import 'package:haja/firebase/firestore.dart';
import 'package:haja/firebase/auth.dart';

class TodoCache extends ContentCache<TodoContent> {
  @override
  List<Map<String, dynamic>> get mockData => MockContent.all;
  @override
  TodoContent fromJson(dynamic data) => TodoContent.fromJson(data);

  TodoSort sortStyle = TodoSort.none;
  bool isTeam = false;

  TodoCache.team() {
    isTeam = true; // TODO: pull from correct firestore document
    sortStyle = TodoSort.recent;
    filters = [FirestoreFilter.recent()];
    download();
  }
  TodoCache.recent() {
    sortStyle = TodoSort.recent;
    filters = [FirestoreFilter.recent()];
    download();
  }
  TodoCache.oldest() {
    sortStyle = TodoSort.oldest;
    filters = [FirestoreFilter.recent()];
    download();
  }
  TodoCache.search(String searchTerms) {
    sortStyle = TodoSort.oldest;
    filters = [FirestoreFilter.search(searchTerms)];
    download();
  }

  @override
  void download({
    String? id,
  }) async =>
      FirestoreApi.download(
        TodoContent.collectionName,
        isTeam: isTeam,
        limit: 500,
        filters: filters,
        id: id ?? AuthApi.activeUser,
        populate: (dynamic data) => populate(
          TodoContent.fromJson(data),
        ),
      );

  List<TodoContent> filterByDates(DateTime start, DateTime end) {
    List<TodoContent> running = [];

    for (var todo in items) {
      if (todo.date.isAtSameMomentAs(start) ||
          (start.isBefore(todo.date) && end.isAfter(todo.date))) {
        running.add(todo);
      }
    }

    return running;
  }

  @override
  int Function(TodoContent, TodoContent)? sorter() => sortStyle.sortFunction();
}

enum TodoSort {
  none,
  recent,
  oldest,
}

extension TodoSortExtension on TodoSort {
  int Function(TodoContent, TodoContent)? sortFunction() {
    switch (this) {
      case TodoSort.recent:
        return (a, b) => a.date.compareTo(b.date);
      case TodoSort.oldest:
        return (a, b) => b.date.compareTo(a.date);
      default:
        return null;
    }
  }
}
