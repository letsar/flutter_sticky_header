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
    testWidgets('scrolled not sticky header', (tester) async {
      final taps = <String>[];
      final controller = await pumpSections(tester, sticky: false, taps: taps);

      controller.jumpTo(50);
      await tester.pump();
      await tester.tapAt(const Offset(200, 10));
      await tester.tapAt(const Offset(200, 50));

      expect(taps, ['Header #0', 'Item 0.0']);
    });

    testWidgets('scrolled not sticky header over the content', (tester) async {
      final taps = <String>[];
      final controller = await pumpSections(
        tester,
        sticky: false,
        overlapsContent: true,
        taps: taps,
      );

      controller.jumpTo(50);
      await tester.pump();
      await tester.tapAt(const Offset(200, 10));

      expect(taps, ['Header #0']);
    });

    testWidgets('not sticky header partly below a pinned SliverAppBar',
        (tester) async {
      final taps = <String>[];
      final positions = <Offset>[];
      final controller = await pumpSections(
        tester,
        sticky: false,
        leading: const SliverAppBar(pinned: true, toolbarHeight: 50),
        taps: taps,
        tapPositions: positions,
      );

      // The app bar is scrolled by 20 but still painted on 50, so the header
      // is laid out at 30 and starts below the app bar.
      controller.jumpTo(20);
      await tester.pump();
      await tester.tapAt(const Offset(200, 80));

      expect(taps, ['Header #0']);
      expect(positions, [const Offset(200, 50)]);
    });

    testWidgets('local position in a pushed header', (tester) async {
      final positions = <Offset>[];
      final controller = await pumpSections(tester, tapPositions: positions);

      // Header #0 is between -40 and 40.
      controller.jumpTo(840);
      await tester.pump();
      await tester.tapAt(const Offset(200, 20));

      expect(positions, [const Offset(200, 60)]);
    });

    testWidgets('local position in a header pinned below a pinned SliverAppBar',
        (tester) async {
      final positions = <Offset>[];
      final controller = await pumpSections(
        tester,
        leading: const SliverAppBar(pinned: true, toolbarHeight: 50),
        tapPositions: positions,
      );

      // Header #0 is between 50 and 130.
      controller.jumpTo(100);
      await tester.pump();
      await tester.tapAt(const Offset(200, 90));

      expect(positions, [const Offset(200, 40)]);
    });

    testWidgets('content above a header pinned below a transparent sliver',
        (tester) async {
      final taps = <String>[];
      final controller = await pumpSections(
        tester,
        leading: const PinnedHeaderSliver(child: SizedBox(height: 50)),
        taps: taps,
      );

      // Header #0 is between 50 and 130, Item 0.0 between 30 and 70.
      controller.jumpTo(100);
      await tester.pump();
      await tester.tapAt(const Offset(200, 40));

      expect(taps, ['Item 0.0']);
    });

    testWidgets('content right after the header', (tester) async {
      final taps = <String>[];
      await pumpSections(tester, taps: taps);

      await tester.tapAt(const Offset(200, 80));

      expect(taps, ['Item 0.0']);
    });

    testWidgets('header when overscrolling at the start', (tester) async {
      final taps = <String>[];
      final positions = <Offset>[];
      final controller = await pumpSections(
        tester,
        physics: const BouncingScrollPhysics(),
        taps: taps,
        tapPositions: positions,
      );

      // Header #0 is between 60 and 140.
      controller.jumpTo(-60);
      await tester.pump();
      await tester.tapAt(const Offset(200, 100));

      expect(taps, ['Header #0']);
      expect(positions, [const Offset(200, 40)]);
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

    testWidgets('scrolled not sticky header', (tester) async {
      final taps = <String>[];
      final controller = await pumpSections(
        tester,
        sticky: false,
        reverse: true,
        taps: taps,
      );

      controller.jumpTo(50);
      await tester.pump();
      await tester.tapAt(const Offset(200, 790));
      await tester.tapAt(const Offset(200, 750));

      expect(taps, ['Header #0', 'Item 0.0']);
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

  group('local position in the content', () {
    testWidgets('at rest', (tester) async {
      final positions = <Offset>[];
      await pumpSections(tester, tapPositions: positions);

      // Item 0.0 is between 80 and 120.
      await tester.tapAt(const Offset(200, 100));

      expect(positions, [const Offset(200, 20)]);
    });

    testWidgets('below a pinned header', (tester) async {
      final positions = <Offset>[];
      final controller = await pumpSections(tester, tapPositions: positions);

      // Item 0.3 is between 100 and 140.
      controller.jumpTo(100);
      await tester.pump();
      await tester.tapAt(const Offset(200, 110));

      expect(positions, [const Offset(200, 10)]);
    });

    testWidgets('reversed', (tester) async {
      final positions = <Offset>[];
      await pumpSections(tester, reverse: true, tapPositions: positions);

      // Item 0.0 is between 680 and 720.
      await tester.tapAt(const Offset(200, 690));

      expect(positions, [const Offset(200, 10)]);
    });

    testWidgets('horizontal', (tester) async {
      final positions = <Offset>[];
      await pumpSections(
        tester,
        axis: Axis.horizontal,
        tapPositions: positions,
      );

      // Item 0.0 is between 80 and 120.
      await tester.tapAt(const Offset(100, 400));

      expect(positions, [const Offset(20, 400)]);
    });
  });
}
