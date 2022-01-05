import 'package:flutter/material.dart';

import 'package:haja/constants.dart';

class DramaticAppbarWithContent extends StatelessWidget {
  final ImageProvider background;
  final List<Widget> children;

  const DramaticAppbarWithContent({
    required this.background,
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverAppBar(
        expandedHeight: 450,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: background,
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(.3),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Constants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      );
}

class PaddedContentSliver extends StatelessWidget {
  final List<Widget> children;

  const PaddedContentSliver({
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      );
}
