import 'package:flutter/material.dart';

import 'package:haja/display/components/widgets/error.dart';
import 'package:haja/language/language.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const ErrorPage(
        header: Language.pageNotFoundError,
        help: '',
      );
}
