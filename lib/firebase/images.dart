import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, LostDataResponse, XFile;

class FirestoreImages {
  static Future<XFile?> gallery({
    required void Function(String) onError,
  }) async {
    List<XFile>? lostFiles = await FirestoreImages.handleLostDataBeforeNewCall(
      onError: onError,
    );

    if (lostFiles != null && lostFiles.isNotEmpty) {
      return lostFiles[0];
    }

    return ImagePicker().pickImage(source: ImageSource.gallery);
  }

  static Future<List<XFile>?> multiple({
    required void Function(String) onError,
  }) async {
    List<XFile>? lostFiles = await FirestoreImages.handleLostDataBeforeNewCall(
      onError: onError,
    );

    if (lostFiles != null && lostFiles.isNotEmpty) {
      return lostFiles;
    }

    return ImagePicker().pickMultiImage();
  }

  static Future<XFile?> camera({
    required void Function(String) onError,
  }) async {
    List<XFile>? lostFiles = await FirestoreImages.handleLostDataBeforeNewCall(
      onError: onError,
    );

    if (lostFiles != null && lostFiles.isNotEmpty) {
      return lostFiles[0];
    }

    return ImagePicker().pickImage(source: ImageSource.camera);
  }

  static Future<List<XFile>?> handleLostDataBeforeNewCall({
    required void Function(String) onError,
  }) async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      List<XFile> files = [];
      String? error;
      await FirestoreImages.handleLostData(
        onComplete: (XFile f) => files.add(f),
        onError: (String e) => error = e,
      );
      if (files.isNotEmpty) {
        return files;
      }
      if (error != null) {
        onError(error!);
      }
    }
  }

  static Future<void> handleLostData({
    required void Function(XFile) onComplete,
    required void Function(String) onError,
  }) async {
    final LostDataResponse response = await ImagePicker().retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.files != null) {
      for (final XFile file in response.files!) {
        onComplete(file);
      }
    } else {
      onError(response.exception!.code);
    }
  }
}
