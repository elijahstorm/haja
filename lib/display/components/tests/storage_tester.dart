import 'package:flutter/material.dart';

import 'package:haja/firebase/storage.dart';

class StorageTester extends StatelessWidget {
  const StorageTester({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          IconButton(
            onPressed: () async {
              await StorageApi.upload.images.gallery(
                    onError: (err) {
                      // print('we errored: $err');
                    },
                  ) ??
                  'null url';
              // print('we succeded with url $url');
            },
            icon: const Icon(
              Icons.cloud_upload_outlined,
              size: 50,
            ),
          ),
          IconButton(
            onPressed: () {
              StorageApi.downloadURLExample(
                id: 'id',
                onComplete: (value) {
                  // print('we succedded $value');
                },
                onError: (err) {
                  // print('we errored: $err');
                },
              );
            },
            icon: const Icon(
              Icons.cloud_download_outlined,
              size: 50,
            ),
          ),
        ],
      );
}
