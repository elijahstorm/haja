import 'package:flutter/material.dart';

import 'package:haja/display/components/widgets/backable_page.dart';

class BillingPage extends StatelessWidget {
  static const routeName = '/billing';

  const BillingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BackablePage(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(routeName),
        ],
      ),
    );
  }
}
