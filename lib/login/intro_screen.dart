import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:haja/language/constants.dart';

class IntroScreen extends StatelessWidget {
  final VoidCallback onFinished;

  const IntroScreen({
    required this.onFinished,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressableContent(
        list: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share and connect with each other easily',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 38,
                    color: Constants.bgColorLight,
                  ),
                ),
                const SizedBox(height: Constants.defaultPadding / 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'The power of being together',
                      style: TextStyle(
                        fontSize: 16,
                        color: Constants.bgColorLight,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Constants.primaryColorDark,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      padding: const EdgeInsets.all(
                        Constants.defaultPadding / 4,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_right_alt,
                          size: Constants.defaultPadding * 1.5,
                          color: Constants.bgColorLight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Constants.defaultPadding / 2),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.defaultPadding * 2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Constants.logoTitleAssetWhite,
                  ),
                ],
              ),
            ),
          ),
        ],
        bgs: [
          Image.asset(
            'assets/images/intro/first.jpg',
            fit: BoxFit.cover,
          ),
          null,
        ],
        onFinished: onFinished,
      ),
    );
  }
}

class ProgressableContent extends StatefulWidget {
  final VoidCallback onFinished;
  final List<Widget> list;
  final List<Widget?> bgs;

  const ProgressableContent({
    required this.onFinished,
    required this.list,
    required this.bgs,
    Key? key,
  }) : super(key: key);

  @override
  _ProgressableContentState createState() => _ProgressableContentState();
}

class _ProgressableContentState extends State<ProgressableContent> {
  int index = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (index == widget.list.length - 1) {
            widget.onFinished();
          } else {
            setState(() => index++);
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                    colors: [
                      Constants.primaryColorLight,
                      Constants.secondaryColorLight,
                    ],
                  ),
                ),
                child: widget.bgs[index],
              ),
            ),
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.defaultPadding,
                    vertical: Constants.defaultPadding * 2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.list[index],
                      const SizedBox(height: Constants.defaultPadding * 2),
                      ProgressIndictator(
                        index: index,
                        length: widget.list.length,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class ProgressIndictator extends StatelessWidget {
  final int index, length;

  const ProgressIndictator({
    required this.index,
    required this.length,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: List<Widget>.generate(
          length,
          (i) => Expanded(
            child: Opacity(
              opacity: i == index ? 1 : .3,
              child: Container(
                height: Constants.defaultPadding / 4,
                color: Constants.bgColorLight,
              ),
            ),
          ),
        ),
      );
}
