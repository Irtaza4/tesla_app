import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_app/main.dart';

void main() {
  testWidgets(
    'Dashboard controls and pressure navigation work at phone sizes',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.text('Model3'), findsOneWidget);
      expect(find.text('Charge'), findsNWidgets(2));
      expect(find.text('86 mph', findRichText: true), findsOneWidget);
      await tester.tap(find.byTooltip('Toggle vehicle power'));
      await tester.pumpAndSettle();
      expect(find.text('0 mph', findRichText: true), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Unlock vehicle'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Lock vehicle'), findsOneWidget);
      await tester.tap(find.text('Wheel pressure'));
      await tester.pumpAndSettle();
      expect(find.text('Wheels'), findsOneWidget);
      expect(find.text('25 atm'), findsOneWidget);
      expect(find.text('23 atm'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Back to dashboard'));
      await tester.pumpAndSettle();
      expect(find.text('Model3'), findsOneWidget);
      await tester.tap(find.text('Charge').first);
      await tester.pumpAndSettle();
      expect(find.text('Battery charge'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(320, 568);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
