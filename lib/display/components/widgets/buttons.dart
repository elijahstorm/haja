import 'package:flutter/material.dart';

import 'package:haja/constants.dart';

class GenericFloatingButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const GenericFloatingButton({
    required this.onTap,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding,
          ),
          height: Constants.defaultPadding * 3,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(Constants.defaultCardRadius * 4),
            color: Theme.of(context).primaryColor,
          ),
          child: Align(
            child: Text(
              label,
            ),
          ),
        ),
      );
}
