import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:haja/constants.dart';
import 'package:haja/theme.dart';

enum ShimmerDesign {
  profile,
  squareCards,
  tallCards,
}

class SkeletonLoader extends StatelessWidget {
  final int amount;
  final ShimmerDesign design;

  const SkeletonLoader({
    this.amount = 10,
    this.design = ShimmerDesign.profile,
    Key? key,
  }) : super(key: key);

  Widget _buildSkinnyProfile(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              color: Themes.isDark
                  ? Constants.darkShimmerWidget
                  : Constants.lightShimmerWidget,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Themes.isDark
                        ? Constants.darkShimmerWidget
                        : Constants.lightShimmerWidget,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Themes.isDark
                        ? Constants.darkShimmerWidget
                        : Constants.lightShimmerWidget,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Container(
                    width: 40.0,
                    height: 8.0,
                    color: Themes.isDark
                        ? Constants.darkShimmerWidget
                        : Constants.lightShimmerWidget,
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget _determineLoaderStyle(BuildContext context) {
    switch (design) {
      case ShimmerDesign.profile:
        return _buildSkinnyProfile(context);
      case ShimmerDesign.squareCards:
        return _buildSkinnyProfile(context);
      case ShimmerDesign.tallCards:
        return _buildSkinnyProfile(context);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Themes.isDark
            ? Constants.darkShimmerLowlight
            : Constants.lightShimmerLowlight,
        highlightColor: Themes.isDark
            ? Constants.darkShimmerHighlight
            : Constants.lightShimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            amount,
            (_) => _determineLoaderStyle(context),
            growable: false,
          ),
        ),
      );
}
