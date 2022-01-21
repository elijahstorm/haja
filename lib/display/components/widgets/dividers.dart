import 'package:flutter/material.dart';

import 'package:haja/language/constants.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: Constants.defaultPadding),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding * 5,
            ),
            width: double.infinity,
            height: 1,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: Constants.defaultPadding),
        ],
      );
}
