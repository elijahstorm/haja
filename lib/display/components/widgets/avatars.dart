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
              child: display,
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
