import 'package:flutter/material.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';
import 'package:haja/content/dashboard/content.dart';

class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard(
    this.storageDetails, {
    Key? key,
  }) : super(key: key);

  final DashboardContent storageDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: Constants.defaultPadding),
      padding: const EdgeInsets.all(Constants.defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(Constants.defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Theme(
              data: ThemeData(
                iconTheme: Theme.of(context).iconTheme.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              child: storageDetails.icon,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storageDetails.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      // Constants.s
                      '${storageDetails.data['numOfFiles']} ${Language.filesName}',
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(storageDetails.data['totalStorage']),
        ],
      ),
    );
  }
}
