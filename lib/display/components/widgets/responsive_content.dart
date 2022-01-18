import 'package:flutter/material.dart';
import 'package:haja/controllers/responsive.dart';

import 'package:haja/language/language.dart';
import 'package:haja/language/constants.dart';

class ResponsiveContent extends StatelessWidget {
  final String header;
  final Widget? primaryContent,
      secondaryContent,
      sideContent,
      mobileHeaderContent;
  final Widget Function(
    BuildContext,
    String, {
    Widget? primaryContent,
    Widget? secondaryContent,
    Widget? sideContent,
    Widget? mobileHeaderContent,
  }) _builder;

  const ResponsiveContent({
    this.header = '${Language.appName}: ${Language.appSubtitle}',
    this.primaryContent,
    this.secondaryContent,
    this.sideContent,
    this.mobileHeaderContent,
    Key? key,
  })  : _builder = drawPanels,
        super(key: key);

  const ResponsiveContent.thirds({
    this.header = '${Language.appName}: ${Language.appSubtitle}',
    this.primaryContent,
    this.secondaryContent,
    this.sideContent,
    this.mobileHeaderContent,
    Key? key,
  })  : _builder = drawThirds,
        super(key: key);

  const ResponsiveContent.landscapeFriendly({
    this.header = '${Language.appName}: ${Language.appSubtitle}',
    this.primaryContent,
    this.secondaryContent,
    this.sideContent,
    this.mobileHeaderContent,
    Key? key,
  })  : _builder = drawLandscape,
        super(key: key);

  static Widget drawPanels(
    BuildContext context,
    String header, {
    Widget? primaryContent,
    Widget? secondaryContent,
    Widget? sideContent,
    Widget? mobileHeaderContent,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        vertical: Constants.defaultPadding,
      ),
      child: Column(
        children: [
          if (Responsive.isMobile(context)) mobileHeaderContent ?? Container(),
          if (Responsive.isMobile(context))
            const SizedBox(height: Constants.defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      primaryContent ?? Container(),
                      const SizedBox(height: Constants.defaultPadding),
                      secondaryContent ?? Container(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: Constants.defaultPadding),
                      if (Responsive.isMobile(context))
                        sideContent ?? Container(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: Constants.defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: sideContent ?? Container(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget drawLandscape(
    BuildContext context,
    String header, {
    Widget? primaryContent,
    Widget? secondaryContent,
    Widget? sideContent,
    Widget? mobileHeaderContent,
  }) {
    return MediaQuery.of(context).orientation == Orientation.landscape
        ? Padding(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 150,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              if (Responsive.isMobile(context))
                                mobileHeaderContent ?? Container(),
                              if (Responsive.isMobile(context))
                                const SizedBox(
                                    height: Constants.defaultPadding),
                              primaryContent ?? Container(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: Constants.defaultPadding,
                      ),
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: secondaryContent ?? Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : drawPanels(
            context,
            header,
            primaryContent: primaryContent,
            secondaryContent: secondaryContent,
            sideContent: sideContent,
            mobileHeaderContent: mobileHeaderContent,
          );
  }

  static Widget drawThirds(
    BuildContext context,
    String header, {
    Widget? primaryContent,
    Widget? secondaryContent,
    Widget? sideContent,
    Widget? mobileHeaderContent,
  }) {
    if (Responsive.isMobile(context)) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: Constants.defaultPadding,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.defaultPadding,
              ),
              child: mobileHeaderContent ?? Container(),
            ),
            const SizedBox(height: Constants.defaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.defaultPadding,
              ),
              child: primaryContent ?? Container(),
            ),
            const SizedBox(height: Constants.defaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.defaultPadding,
              ),
              child: secondaryContent ?? Container(),
            ),
            const SizedBox(height: Constants.defaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.defaultPadding,
              ),
              child: sideContent ?? Container(),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: primaryContent ?? Container(),
                ),
              ),
              const SizedBox(width: Constants.defaultPadding),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: secondaryContent ?? Container(),
                ),
              ),
              const SizedBox(width: Constants.defaultPadding),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: sideContent ?? Container(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _builder(
      context,
      header,
      primaryContent: primaryContent,
      secondaryContent: secondaryContent,
      sideContent: sideContent,
      mobileHeaderContent: mobileHeaderContent,
    );
  }
}
