import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_app/main.dart';

void main() {
  testWidgets(
    'Tabs keep control state and drive, charge, and route actions work',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Drive tab'));
      await tester.pumpAndSettle();
      expect(find.text('Let’s drive.'), findsOneWidget);
      await tester.tap(find.text('Start drive'));
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('DRIVING'), findsOneWidget);
      expect(find.text('0:03'), findsOneWidget);
      await tester.tap(find.byTooltip('Steer right'));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.tap(find.byTooltip('Controls tab'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Raise temperature'));
      await tester.pumpAndSettle();
      expect(find.text('22°'), findsOneWidget);
      await tester.tap(find.text('Windows'));
      await tester.pumpAndSettle();
      expect(find.text('Vented'), findsOneWidget);
      await tester.tap(find.byTooltip('Charge tab'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start charging'));
      await tester.pump(const Duration(seconds: 4));
      expect(find.text('21%'), findsOneWidget);
      await tester.tap(find.text('Stop charging'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Controls tab'));
      await tester.pumpAndSettle();
      expect(find.text('22°'), findsOneWidget);
      expect(find.text('Vented'), findsOneWidget);
      await tester.tap(find.byTooltip('Explore tab'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Start navigation'));
      await tester.pumpAndSettle();
      expect(find.text('Continue on Market St'), findsOneWidget);
      await tester.tap(find.text('Open driving view'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Park vehicle'), findsOneWidget);
      await tester.tap(find.text('Park vehicle'));
      await tester.pumpAndSettle();
      expect(find.text('PARKED'), findsOneWidget);
      expect(tester.takeException(), isNull);
      tester.view.physicalSize = const Size(320, 568);
      await tester.pumpAndSettle();
      for (final tab in [
        'Controls tab',
        'Charge tab',
        'Explore tab',
        'Info tab',
      ]) {
        await tester.tap(find.byTooltip(tab));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(const SizedBox());
    },
  );
}
