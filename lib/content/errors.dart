import 'package:flutter/material.dart';

import 'package:haja/content/content.dart';
import 'package:haja/keys.dart';

class ContentErrors {
  static void retryContentUploadDialog(String error, ContentContainer content) {
    if (GlobalKeys.rootScaffoldMessengerKey.currentState == null) return;
    GlobalKeys.rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text('${content.title} upload failed. $error'),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {
          content.upload();
        },
      ),
    ));
  }

  static void retryContentDeleteDialog(String error, ContentContainer content) {
    if (GlobalKeys.rootScaffoldMessengerKey.currentState == null) return;
    GlobalKeys.rootScaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      content: Text('${content.title} delete failed. $error'),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {
          content.delete();
        },
      ),
    ));
  }
}
