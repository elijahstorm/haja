import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:haja/display/components/animations/loading.dart';
import 'package:haja/firebase/firestore.dart';

class ContentStreamBuilder extends StatelessWidget {
  final Widget Function(Map<String, dynamic>) success;
  final Widget error, notFound;
  final String id, collection;

  const ContentStreamBuilder({
    required this.id,
    required this.collection,
    required this.error,
    required this.notFound,
    required this.success,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<DocumentSnapshot>(
        stream: FirestoreApi.stream(
          collection,
          id: id,
        ),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return error;
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }

          var document = snapshot.data!;

          if (!document.exists || document.data() == null) {
            return notFound;
          }

          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          data['id'] = id;

          return success(data);
        },
      );
}
