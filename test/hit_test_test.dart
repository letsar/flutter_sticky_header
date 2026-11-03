import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('vertical', () {
    testWidgets('header at rest', (tester) async {
      final taps = <String>[];
      await pumpSections(tester, taps: taps);

      await tester.tapAt(const Offset(200, 40));
      await tester.tapAt(const Offset(200, 100));

      expect(taps, ['Header #0', 'Item 0.0']);
    });

    testWidgets('pinned header', (tester) async {
      final taps = <String>[];
      final controller = await pumpSections(tester, taps: taps);

      controller.jumpTo(100);
      await tester.pump();
      await tester.tapAt(const Offset(200, 40));
      await tester.tapAt(const Offset(200, 100));

      expect(taps, ['Header #0', 'Item 0.3']);
    });

    testWidgets('pushed header', (tester) async {
      final taps = <String>[];
      final controller = await pumpSections(tester, taps: taps);

      controller.jumpTo(840);
      await tester.pump();
      await tester.tapAt(const Offset(200, 20));
      await tester.tapAt(const Offset(200, 60));

      expect(taps, ['Header #0', 'Header #1']);
    });

    testWidgets('header over the content at rest', (tester) async {
      final taps = <String>[];
      await pumpSections(tester, overlapsContent: true, taps: taps);

      await tester.tapAt(const Offset(200, 40));
      await tester.tapAt(const Offset(200, 100));

      expect(taps, ['Header #0', 'Item 0.2']);
    });

    testWidgets('pinned header over the content', (tester) async {
      final taps = <String>[];
      final controller =
          await pumpSections(tester, overlapsContent: true, taps: taps);

      controller.jumpTo(100);
      await tester.pump();
      await tester.tapAt(const Offset(200, 40));
      await tester.tapAt(const Offset(200, 100));

      expect(taps, ['Header #0', 'Item 0.5']);
    });

    testWidgets('header pinned below a pinned SliverAppBar', (tester) async {
      final taps = <String>[];
      final controller = await pumpSections(
        tester,
        leading: const SliverAppBar(pinned: true, toolbarHeight: 50),
        taps: taps,
      );

      controller.jumpTo(100);
      await tester.pump();
      await tester.tapAt(const Offset(200, 90));
      await tester.tapAt(const Offset(200, 150));

      // The content starts at 80 - 50 = 30, so 150 is 120 into it.
      expect(taps, ['Header #0', 'Item 0.3']);
    });
  });

  group('vertical reversed', () {
    testWidgets('header at rest', (tester) async {
      final taps = <String>[];
      await pumpSections(tester, reverse: true, taps: taps);

      await tester.tapAt(const Offset(200, 760));
      await tester.tapAt(const Offset(200, 700));

      expect(taps, ['Header #0', 'Item 0.0']);
    });

    testWidgets('pinned header', (tester) async {
      final taps = <String>[];
      final controller = await pumpSections(tester, reverse: true, taps: taps);

      controller.jumpTo(100);
      await tester.pump();
      await tester.tapAt(const Offset(200, 760));
      await tester.tapAt(const Offset(200, 710));

      // Item 0.0 is at 780, so 710 is in Item 0.2.
      expect(taps, ['Header #0', 'Item 0.2']);
    });
  });

  group('horizontal', () {
    testWidgets('header at rest', (tester) async {
      final taps = <String>[];
      await pumpSections(tester, axis: Axis.horizontal, taps: taps);

      await tester.tapAt(const Offset(40, 400));
      await tester.tapAt(const Offset(100, 400));

      expect(taps, ['Header #0', 'Item 0.0']);
    });

    testWidgets('pinned header', (tester) async {
      final taps = <String>[];
      final controller =
          await pumpSections(tester, axis: Axis.horizontal, taps: taps);

      controller.jumpTo(100);
      await tester.pump();
      await tester.tapAt(const Offset(40, 400));
      await tester.tapAt(const Offset(100, 400));

      expect(taps, ['Header #0', 'Item 0.3']);
    });
  });
}
