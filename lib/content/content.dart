import 'package:flutter/material.dart';

import 'package:haja/firebase/firestore.dart';
import 'package:haja/content/errors.dart';

enum CONTENT {
  none,
  dashboard,
  todo,
  notification,
  file,
  team,
  user,
  ad,
}

class ContentContainer {
  static const String collectionName = '';
  String get collection => collectionName;
  bool get privateData => false;
  bool get isTeam => false;

  String title, caption, id;
  bool synchedWithDatabase = false;

  ContentContainer({
    required this.title,
    required this.caption,
    required this.id,
  });

  ContentContainer.fromJson(dynamic data)
      : title = data['title'],
        caption = data['caption'],
        id = data['id'] ?? '';

  Map<String, dynamic> toJson() => {
        'title': title,
        'caption': caption,
      };

  bool find(String query) {
    return title.contains(query) || caption.contains(query) || id == query;
  }

  void upload() {
    FirestoreApi.upload(
      this,
      isTeam: isTeam,
      onError: ContentErrors.retryContentUploadDialog,
    );
  }

  void delete() {
    FirestoreApi.delete(
      this,
      isTeam: isTeam,
      onError: ContentErrors.retryContentDeleteDialog,
    );
  }

  void navigateTo(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Material(child: navigator()),
      fullscreenDialog: true,
    ));
    (context as Element).markNeedsBuild();
  }

  void navigateToEditor(BuildContext context) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Material(child: navigatorEditor()),
      fullscreenDialog: true,
    ));
    (context as Element).markNeedsBuild();
  }

  Widget navigator() => const Scaffold();
  Widget navigatorEditor() => const Scaffold();
}
