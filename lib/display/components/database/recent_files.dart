import 'package:flutter/material.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';
import 'package:haja/content/files/content.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Language.appScreenHeaderRecentFiles,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            width: double.infinity,
            child: Text(Language.inDevelopmentApology),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(FileContent fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: fileInfo.icon,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding),
              child: Text(fileInfo.title),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          Language.timeSinceDate(fileInfo.editedOn),
        ),
      ),
      DataCell(Text(fileInfo.caption)),
    ],
  );
}
