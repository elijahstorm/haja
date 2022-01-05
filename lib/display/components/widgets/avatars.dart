import 'package:flutter/material.dart';

import 'package:haja/constants.dart';

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
                // color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(
                  // color: Theme,
                  width: 2,
                ),
              ),
              width: Constants.defaultPadding * 2,
              height: Constants.defaultPadding * 2,
              child: display,
            ),
            const SizedBox(height: Constants.defaultPadding / 2),
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

class BigBox extends StatefulWidget {
  final String image;
  final VoidCallback? onTap;

  const BigBox({
    Key? key,
    required this.image,
    this.onTap,
  }) : super(key: key);

  @override
  _BigBoxState createState() => _BigBoxState();
}

class _BigBoxState extends State<BigBox> {
  @override
  Widget build(BuildContext context) => PressableCard(
        upElevation: 4,
        downElevation: 2,
        child: Image.asset(
          widget.image,
          fit: BoxFit.cover,
        ),
        onTap: widget.onTap,
      );
}

class PressableCard extends StatefulWidget {
  const PressableCard({
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.upElevation = 2,
    this.downElevation = 0,
    this.shadowColor = Colors.grey,
    this.duration = const Duration(milliseconds: 100),
    this.color = Colors.grey,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;

  final Widget child;

  final Color color;

  final BorderRadius borderRadius;

  final double upElevation;

  final double downElevation;

  final Color shadowColor;

  final Duration duration;

  @override
  _PressableCardState createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool cardIsDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => cardIsDown = false);

        if (widget.onTap == null) return;
        widget.onTap!();
      },
      onTapDown: (details) => setState(() => cardIsDown = true),
      onTapCancel: () => setState(() => cardIsDown = false),
      child: AnimatedPhysicalModel(
        elevation: cardIsDown ? widget.downElevation : widget.upElevation,
        borderRadius: widget.borderRadius,
        shape: BoxShape.rectangle,
        shadowColor: widget.shadowColor,
        duration: widget.duration,
        color: widget.color,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: widget.child,
        ),
      ),
    );
  }
}

class PressableCircle extends StatefulWidget {
  const PressableCircle({
    required this.child,
    this.radius = 30,
    this.upElevation = 2,
    this.downElevation = 0,
    this.shadowColor = Colors.black,
    this.duration = const Duration(milliseconds: 100),
    this.onTap,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onTap;

  final Widget child;

  final double radius;

  final double upElevation;

  final double downElevation;

  final Color shadowColor;

  final Duration duration;

  @override
  _PressableCircleState createState() => _PressableCircleState();
}

class _PressableCircleState extends State<PressableCircle> {
  bool cardIsDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => cardIsDown = false);
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onTapDown: (details) => setState(() => cardIsDown = true),
      onTapCancel: () => setState(() => cardIsDown = false),
      child: AnimatedPhysicalModel(
        elevation: cardIsDown ? widget.downElevation : widget.upElevation,
        borderRadius: const BorderRadius.all(Radius.circular(9999)),
        shape: BoxShape.rectangle,
        shadowColor: widget.shadowColor,
        duration: widget.duration,
        color: Colors.grey,
        child: Transform.scale(
          scale: cardIsDown ? 0.95 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
