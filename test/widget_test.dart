import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:haja/main.dart';
import 'package:haja/language/language.dart';

void main() {
  testWidgets('Shows intro page on first open', (WidgetTester tester) async {
    await tester.pumpWidget(const HajaDoTogetherApp());
    expect(find.text(Language.firstAppSeenCallToAction), findsOneWidget);
    expect(find.text(Language.firstAppSeenSubtitle), findsOneWidget);
  });

  testWidgets('Shows login page on second open', (WidgetTester tester) async {
    await tester.pumpWidget(const HajaDoTogetherApp());
    expect(find.text(Language.loginScreenIntro), findsOneWidget);
    expect(find.text(Language.loginScreenButton), findsOneWidget);
  });
}
