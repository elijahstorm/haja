import 'package:flutter/material.dart';

import 'package:haja/display/components/widgets/error.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const ErrorPage(
        header: 'We have no Terms of Service yet :)',
        help: 'We are just testing out this feature',
      );
}
