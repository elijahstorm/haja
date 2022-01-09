import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class AnimationIncrementable extends StatelessWidget {
  final Widget child;

  const AnimationIncrementable({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Provider(
        lazy: true,
        create: (context) => Incrementer(),
        builder: (context, _) => AnimationLimiter(
          child: child,
        ),
      );
}

class FadeInIncrementable extends StatelessWidget {
  final Widget child;

  const FadeInIncrementable({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<Incrementer>(
        builder: (context, incrementer, _) {
          var index = incrementer.next;
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 475),
            child: FadeInAnimation(
              delay: const Duration(milliseconds: 100),
              child: child,
            ),
          );
        },
      );
}

class Incrementer {
  int increment = 0;

  int get next {
    return increment++;
  }
}
