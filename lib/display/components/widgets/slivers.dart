import 'package:flutter/material.dart';

import 'package:haja/language/constants.dart';

class DramaticAppbarWithContent extends StatelessWidget {
  final String background;
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
          background: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  background,
                  errorBuilder: (context, _, __) => Image.asset(
                    Constants.errorImage,
                    fit: BoxFit.contain,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(.3),
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
            ],
          ),
        ),
      );
}

class CenteredAppbarWithContent extends StatelessWidget {
  final Widget? background;
  final List<Widget> children;

  const CenteredAppbarWithContent({
    this.background,
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverAppBar(
        expandedHeight: 300,
        backgroundColor: Colors.transparent,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Stack(
            children: [
              if (background != null)
                Positioned.fill(
                  child: background!,
                ),
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: children,
                  ),
                ),
              ),
            ],
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

class NoPaddingContentSliver extends StatelessWidget {
  final List<Widget> children;

  const NoPaddingContentSliver({
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildListDelegate(
          [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ],
        ),
      );
}
