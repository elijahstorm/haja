import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:haja/content/content.dart';
import 'package:haja/controllers/keys.dart';

class ContentErrors {
  static String lastRetriedId = '';

  static void retryContentUploadDialog(String error, ContentContainer content) {
    if (GlobalKeys.rootScaffoldMessengerKey.currentState == null) return;
    GlobalKeys.rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text('${content.title} upload failed. $error'),
      duration: kReleaseMode
          ? const Duration(seconds: 4)
          : const Duration(seconds: 20),
      action: lastRetriedId == content.id
          ? null
          : SnackBarAction(
              label: 'Retry',
              onPressed: () {
                lastRetriedId = content.id;
                content.upload();
              },
            ),
    ));
  }

  static void retryContentDeleteDialog(String error, ContentContainer content) {
    if (GlobalKeys.rootScaffoldMessengerKey.currentState == null) return;
    GlobalKeys.rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text('${content.title} delete failed. $error'),
      duration: kReleaseMode
          ? const Duration(seconds: 4)
          : const Duration(seconds: 20),
      action: lastRetriedId == content.id
          ? null
          : SnackBarAction(
              label: 'Retry',
              onPressed: () {
                lastRetriedId = content.id;
                content.delete();
              },
            ),
    ));
  }
}
