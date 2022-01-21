import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:haja/content/todo/content.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/theme.dart';

class EventsFlowerBuilder extends StatelessWidget {
  final List<TodoContent> events;

  static const multipleEventCirclePadding = 10.0;
  final multipleEventCircleSize = 16.0;

  const EventsFlowerBuilder(
    this.events, {
    Key? key,
  }) : super(key: key);

  Widget allFinishedBuilder(BuildContext context) => const Icon(
        Icons.check,
        color: Constants.textColorDark,
      );

  bool allFinished(List<TodoContent> events) {
    for (var e in events) {
      if (e.status == TodoContent.unfinishedStatus) {
        return false;
      }
    }
    return events.isNotEmpty;
  }

  Widget eventCircleBuilder(
    BuildContext context,
    TodoContent event, {
    BlendMode? blend,
    String? color,
  }) =>
      Container(
        width: multipleEventCircleSize,
        height: multipleEventCircleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          backgroundBlendMode: blend,
          color: Constants.fromHex(color ?? event.color) ??
              Theme.of(context).primaryColor,
        ),
      );

  static const List<EdgeInsets> smallEventPaddings = [
    EdgeInsets.zero,
    EdgeInsets.only(
      right: multipleEventCirclePadding * 2,
    ),
    EdgeInsets.only(
      left: multipleEventCirclePadding * 2,
    ),
    EdgeInsets.zero,
  ];

  static const List<EdgeInsets> largeEventPaddings = [
    EdgeInsets.only(
      bottom: multipleEventCirclePadding,
      right: multipleEventCirclePadding,
    ),
    EdgeInsets.only(
      bottom: multipleEventCirclePadding,
      left: multipleEventCirclePadding,
    ),
    EdgeInsets.only(
      top: multipleEventCirclePadding,
      right: multipleEventCirclePadding,
    ),
    EdgeInsets.only(
      top: multipleEventCirclePadding,
      left: multipleEventCirclePadding,
    ),
    EdgeInsets.zero,
  ];

  bool isSmallEventsStack(List<TodoContent> events) => events.length <= 3;

  Widget eventsStackBuilder(
    BuildContext context,
    List<TodoContent> events,
  ) =>
      Padding(
        padding: events.length == 2
            ? EdgeInsets.only(left: multipleEventCircleSize / 2)
            : EdgeInsets.zero,
        child: Stack(
          children: List.generate(
            min(events.length, 4) + 2,
            (index) => Center(
              child: index == 0
                  ? eventCircleBuilder(
                      context,
                      events[index],
                      color: Constants.toHex(
                        Theme.of(context).scaffoldBackgroundColor,
                      ),
                    )
                  : index == events.length + 1 || index == 5
                      ? allFinished(events)
                          ? Padding(
                              padding: events.length == 2
                                  ? EdgeInsets.only(
                                      right: multipleEventCircleSize / 2,
                                    )
                                  : EdgeInsets.zero,
                              child: allFinishedBuilder(context),
                            )
                          : isSmallEventsStack(events)
                              ? Container()
                              : Text(
                                  events.length <= 9
                                      ? events.length.toString()
                                      : '9+',
                                  style: const TextStyle(
                                    color: Constants.textColorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                      : Container(
                          padding: isSmallEventsStack(events)
                              ? smallEventPaddings[index - 1]
                              : largeEventPaddings[index - 1],
                          child: StoreBuilder(
                            builder:
                                (BuildContext context, Store<AppState> app) =>
                                    eventCircleBuilder(
                              context,
                              events[index - 1],
                              blend: app.state.enableDarkMode
                                  ? BlendMode.lighten
                                  : BlendMode.multiply,
                            ),
                          ),
                        ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => eventsStackBuilder(context, events);
}

class EventsHouseBuilder extends StatelessWidget {
  final List<TodoContent> events;
  final DateTime date;
  final bool isSelected;

  final boxSize = 40.0;

  const EventsHouseBuilder(
    this.events,
    this.date, {
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  List<Color> colorGradient(
    List<TodoContent> events, {
    required Color fallback,
    required Color unfinished,
  }) {
    List<Color> colors = [];

    for (var event in events) {
      if (event.isNotDone) {
        colors.add(unfinished);
        continue;
      }
      Color color = Constants.fromHex(event.color) ?? fallback;

      if (colors.isNotEmpty && colors.last == color) continue;

      colors.add(color);
    }

    colors.add(colors[0]);

    return colors;
  }

  @override
  Widget build(BuildContext context) => Container(
        width: boxSize,
        height: boxSize,
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).iconTheme.color!,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(
            Constants.defaultBorderRadiusMedium,
          ),
          color: const Color(0xFFdbdbdb),
          gradient: SweepGradient(
            colors: colorGradient(
              events,
              fallback: Theme.of(context).primaryColor,
              unfinished: Theme.of(context).canvasColor,
            ),
            transform: const GradientRotation(5 * pi / 4),
          ),
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: const TextStyle(
              color: Constants.bgColorLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}
