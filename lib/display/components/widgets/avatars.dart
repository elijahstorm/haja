import 'package:flutter/material.dart';

import 'package:haja/language/constants.dart';

class CircleStoryAvatar extends StatelessWidget {
  final String label;
  final void Function(BuildContext) navigateTo;
  final Widget display;

  const CircleStoryAvatar({
    required this.label,
    required this.navigateTo,
    required this.display,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => navigateTo(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                ),
              ),
              width: Constants.defaultPadding * 2,
              height: Constants.defaultPadding * 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: display,
              ),
            ),
            const SizedBox(height: Constants.defaultPadding / 4),
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
}

class CircleOverlappableAvatar extends StatelessWidget {
  final Widget display;
  final double? size;

  const CircleOverlappableAvatar({
    required this.display,
    this.size = Constants.defaultPadding * 2,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 1,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        width: size ?? Constants.defaultPadding * 2,
        height: size ?? Constants.defaultPadding * 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(90),
          child: display,
        ),
      );
}
