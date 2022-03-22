import 'package:haja/controllers/responsive.dart';
import 'package:flutter/material.dart';
import 'package:haja/display/components/widgets/alerts.dart';
import 'package:provider/provider.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';
import 'package:haja/content/dashboard/cache.dart';
import 'package:haja/display/components/animations/loading.dart';
import 'package:haja/display/components/database/file_info_card.dart';

class DashboardFiles extends StatelessWidget {
  const DashboardFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Language.appScreenHeaderMyFiles,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding * 1.5,
                  vertical: Constants.defaultPadding /
                      (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () => AlertTextDialog.run(
                context,
                const AlertTextDialog(
                  alert: 'needs to be fixed',
                  subtext: 'OurTeamMembers',
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text(Language.addButton),
            ),
          ],
        ),
        const SizedBox(height: Constants.defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: const FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardCache>(
      builder: (context, cache, child) {
        var overview = cache.filter('overview');

        if (overview.isEmpty) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: overview.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: Constants.defaultPadding,
              mainAxisSpacing: Constants.defaultPadding,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) => const Loading(),
          );
        }

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: overview.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: Constants.defaultPadding,
            mainAxisSpacing: Constants.defaultPadding,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) => FileInfoCard(info: overview[index]),
        );
      },
    );
  }
}
