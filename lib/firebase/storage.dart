import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import 'package:haja/firebase/auth.dart';
import 'package:haja/firebase/images.dart';

class StorageApi {
  static StorageOptions set({
    bool? isTeam,
    String? id,
    String? type,
    String? fileExtension,
  }) {
    return StorageOptions(
      isTeam: isTeam,
      id: id,
      type: type,
      fileExtension: fileExtension,
    );
  }

  static _StorageUploader get upload {
    return _StorageUploader(StorageOptions());
  }

  static Future<void> downloadURLExample({
    required String id,
    bool isTeam = false,
    String type = 'profile',
    String fileExtension = 'png',
    required void Function(String) onComplete,
    required void Function(String) onError,
  }) async {
    String route = isTeam ? 'teams' : 'users';

    try {
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('$route/$id/$type.$fileExtension')
          .getDownloadURL();

      onComplete(downloadURL);
    } on firebase_core.FirebaseException catch (e) {
      onError('Upload ${e.code}');
    }
  }

  static Future<String?> uploadFileWithMetadata(
    File file, {
    required String id,
    required bool isTeam,
    required String type,
    required String fileExtension,
    void Function(String)? onComplete,
    required void Function(String) onError,
  }) async {
    String route = isTeam ? 'teams' : 'users';

    final refLocation = '$route/$id/$type.$fileExtension';

    firebase_storage.SettableMetadata metadata =
        firebase_storage.SettableMetadata(
      cacheControl: 'max-age=60',
      customMetadata: <String, String>{
        'userId': id,
        'type': type,
      },
    );

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(refLocation)
          .putFile(file, metadata)
          .then(
        (_) {
          if (onComplete != null) {
            onComplete(refLocation);
          }
        },
      ).onError(
        (e, stackTrace) {
          onError('Upload Error -> (StorageApi.uploadFileWithMetadata)');
        },
      );

      return refLocation;
    } on firebase_core.FirebaseException catch (e) {
      onError('Upload Error (StorageApi.uploadFileWithMetadata): ${e.code}');
    }

    return null;
  }
}

class StorageOptions {
  bool? isTeam;
  String? id, type, fileExtension;

  StorageOptions({
    this.isTeam,
    this.id,
    this.type,
    this.fileExtension,
  });

  _StorageUploader get upload {
    return _StorageUploader(this);
  }
}

class _StorageUploader {
  StorageOptions options;

  _StorageUploader(this.options);

  _StoreageImageHandler get images {
    return _StoreageImageHandler(
      onComplete: ({
        required File file,
        required void Function(String) onError,
      }) async {
        if (AuthApi.activeUser == null) {
          onError('Currently not logged in.');
          return null;
        }

        String id = options.id ?? AuthApi.activeUser!;

        String? refLocation = await StorageApi.uploadFileWithMetadata(
          file,
          id: id,
          isTeam: options.isTeam ?? false,
          type: options.type ?? 'profile',
          fileExtension: options.fileExtension ?? 'png',
          onError: onError,
        );

        if (refLocation == null) {
          onError('File could not be referenced successfully.');
          return null;
        }

        return await firebase_storage.FirebaseStorage.instance
            .ref(refLocation)
            .getDownloadURL();
      },
    );
  }
}

class _StoreageImageHandler {
  final Future<String?> Function({
    required File file,
    required void Function(String) onError,
  }) onComplete;

  _StoreageImageHandler({
    required this.onComplete,
  });

  Future<String?> gallery({
    required void Function(String) onError,
  }) async {
    var temp = await FirestoreImages.gallery(onError: onError);

    if (temp == null) return null;

    return onComplete(
      file: File(temp.path),
      onError: onError,
    );
  }
}
