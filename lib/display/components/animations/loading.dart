import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
        child: SpinKitDancingSquare(
          color: Theme.of(context).colorScheme.secondary,
          size: 50.0,
        ),
      );
}
