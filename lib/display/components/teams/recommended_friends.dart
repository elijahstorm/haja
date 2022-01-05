import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:haja/responsive.dart';
import 'package:haja/content/users/cache.dart';
import 'package:haja/constants.dart';

import 'package:haja/display/components/teams/person_card_info.dart';

class RecommendedFriends extends StatelessWidget {
  const RecommendedFriends({
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
              'In Your Circle',
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
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Find More'),
            ),
          ],
        ),
        const SizedBox(height: Constants.defaultPadding),
        Responsive(
          mobile: PersonCardInfoGridView(
            crossAxisCount: _size.width < 650 ? 2 : 2,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: const PersonCardInfoGridView(),
          desktop: PersonCardInfoGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class PersonCardInfoGridView extends StatelessWidget {
  const PersonCardInfoGridView({
    Key? key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserCache>(
      builder: (context, cache, child) {
        List filter = [];
        var items = cache.items;

        for (int i = 0; i < items.length; i++) {
          if (!items[i].isFollowing) {
            filter.add(items[i]);
          }
        }

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: Constants.defaultPadding,
            mainAxisSpacing: Constants.defaultPadding,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: min(8, filter.length),
          itemBuilder: (context, index) => PersonCardInfo(filter[index]),
        );
      },
    );
  }
}
