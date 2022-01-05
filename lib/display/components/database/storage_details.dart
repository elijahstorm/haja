import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:haja/constants.dart';
import 'package:haja/display/components/charts/charts.dart';
import 'package:haja/content/dashboard/cache.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardCache>(
      builder: (context, cache, child) {
        var storage = cache.filter('storage', limit: 4);

        return Container(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Storage Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: Constants.defaultPadding),
              StorageChart(cache.at('storage pie')),
              Column(
                children: List.generate(
                  storage.length,
                  (i) => StorageInfoCard(storage[i]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
