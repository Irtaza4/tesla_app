import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tesla_app/main.dart';

void main() {
  testWidgets(
    'Acceleration, steering, hidden-tab pause, and braking are gradual',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Future<void> frames(int count) async {
        for (int i = 0; i < count; i++) {
          await tester.pump(const Duration(milliseconds: 16));
        }
      }

      int speed({bool hidden = false}) => int.parse(
        tester
            .widget<Text>(
              find.byKey(const ValueKey('actual-speed'), skipOffstage: !hidden),
            )
            .data!,
      );
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Drive tab'));
      await tester.pumpAndSettle();
      expect(speed(), 0);
      final trafficBefore = tester
          .widget<Positioned>(find.byKey(const ValueKey('traffic-1')))
          .top;
      await tester.tap(find.text('Start drive'));
      await frames(120);
      expect(speed(), inExclusiveRange(0, 48));
      expect(
        tester.widget<Positioned>(find.byKey(const ValueKey('traffic-1'))).top,
        isNot(trafficBefore),
      );
      await tester.tap(find.byTooltip('Steer right'));
      await frames(12);
      final intermediate = tester
          .widget<Positioned>(find.byKey(const ValueKey('ego-car')))
          .left!;
      expect(intermediate, inExclusiveRange(160.0, 205.0));
      await frames(110);
      expect(
        tester.widget<Positioned>(find.byKey(const ValueKey('ego-car'))).left,
        205,
      );
      await tester.tap(find.byTooltip('Info tab'));
      await tester.pumpAndSettle();
      final pausedSpeed = speed(hidden: true);
      await tester.pump(const Duration(seconds: 5));
      expect(speed(hidden: true), pausedSpeed);
      await tester.tap(find.byTooltip('Drive tab'));
      await frames(120);
      await tester.tap(find.text('Park vehicle'));
      await frames(10);
      expect(find.text('BRAKING'), findsOneWidget);
      expect(speed(), greaterThan(0));
      await tester.pumpAndSettle();
      expect(speed(), 0);
      expect(find.text('PARKED'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
