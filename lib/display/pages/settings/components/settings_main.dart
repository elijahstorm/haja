import 'package:flutter/material.dart';

import 'package:haja/display/components/widgets/skeleton.dart';
import 'package:haja/constants.dart';
import 'package:haja/theme.dart';

class DashSettingsMain extends StatelessWidget {
  const DashSettingsMain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Main Settings',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        const SizedBox(height: Constants.defaultPadding),
        Container(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Change visual brightness'),
                  ThemeSwitcher(),
                ],
              ),
              const SizedBox(height: Constants.defaultPadding),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding * 5,
                ),
                width: double.infinity,
                height: 1,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: Constants.defaultPadding * 0.5),
              const SkeletonLoader(
                amount: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
