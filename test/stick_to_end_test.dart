import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

// With stickToEnd, a section is its items followed by its header, and the
// header sticks to the end of the viewport.
//
// In a reversed list, the sections grow from the bottom: Item s.0 is at the
// bottom of section #s and Header #s at its top.

void main() {
  group('reversed list', () {
    testWidgets('header is pinned at the top at rest', (tester) async {
      await pumpSections(tester, reverse: true, stickToEnd: true);

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 0, 400, 80));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 760, 400, 800));
    });

    testWidgets('header stays pinned while its section crosses the top',
        (tester) async {
      final controller =
          await pumpSections(tester, reverse: true, stickToEnd: true);

      controller.jumpTo(40);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 0, 400, 80));
    });

    testWidgets('header follows its section, next header is pushed',
        (tester) async {
      final controller =
          await pumpSections(tester, reverse: true, stickToEnd: true);

      // Section #0 ends 20 below the top, section #1 starts there.
      controller.jumpTo(100);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 20, 400, 100));
      expect(rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, -60, 400, 20));
    });

    testWidgets('next header takes over', (tester) async {
      final controller =
          await pumpSections(tester, reverse: true, stickToEnd: true);

      controller.jumpTo(160);
      await tester.pump();

      expect(rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 0, 400, 80));
      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 80, 400, 160));
    });

    testWidgets('not sticky header scrolls with its section', (tester) async {
      final controller = await pumpSections(
        tester,
        reverse: true,
        stickToEnd: true,
        sticky: false,
      );

      controller.jumpTo(120);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 40, 400, 120));
    });

    testWidgets('header over the content', (tester) async {
      final controller = await pumpSections(
        tester,
        reverse: true,
        stickToEnd: true,
        overlapsContent: true,
      );

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 0, 400, 80));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 760, 400, 800));

      // Section #0 is 800 long and ends 100 below the top.
      controller.jumpTo(100);
      await tester.pump();

      expect(
          rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 100, 400, 180));
      expect(rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 0, 400, 80));
    });

    testWidgets('Scrollable.ensureVisible scrolls to an item', (tester) async {
      final controller =
          await pumpSections(tester, reverse: true, stickToEnd: true);

      Scrollable.ensureVisible(
        tester.element(find.text('Item 1.0', skipOffstage: false)),
      );
      await tester.pump();

      // Section #1 starts at 880, with its items.
      expect(controller.offset, 880);
      expect(rectOf(tester, 'Item 1.0'), const Rect.fromLTRB(0, 760, 400, 800));
    });
  });

  group('sticky footer', () {
    testWidgets('header is pinned at the bottom at rest', (tester) async {
      await pumpSections(tester, stickToEnd: true);

      expect(
          rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 720, 400, 800));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 0, 400, 40));
    });

    testWidgets('header follows its section, next header is pushed',
        (tester) async {
      final controller = await pumpSections(tester, stickToEnd: true);

      controller.jumpTo(100);
      await tester.pump();

      expect(
          rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 700, 400, 780));
      expect(
          rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 780, 400, 860));
    });

    testWidgets('horizontal', (tester) async {
      await pumpSections(tester, stickToEnd: true, axis: Axis.horizontal);

      expect(
          rectOf(tester, 'Header #0'), const Rect.fromLTRB(320, 0, 400, 800));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 0, 40, 800));
    });
  });

  testWidgets('header is pinned at the top before the center sliver',
      (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final controller = ScrollController();
    addTearDown(controller.dispose);

    Widget section(String name, {Key? key, bool stickToEnd = false}) {
      return SliverStickyHeader(
        key: key,
        stickToEnd: stickToEnd,
        header: SizedBox(height: 80, child: Text('Header $name')),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => SizedBox(height: 40, child: Text('Item $name.$i')),
            childCount: 20,
          ),
        ),
      );
    }

    const center = ValueKey('center');
    await tester.pumpWidget(
      MaterialApp(
        home: CustomScrollView(
          controller: controller,
          center: center,
          slivers: [
            // Grows upward from the center.
            section('before', stickToEnd: true),
            section('after', key: center),
          ],
        ),
      ),
    );

    // The bottom 100 of the section before the center are visible.
    controller.jumpTo(-100);
    await tester.pump();

    expect(rectOf(tester, 'Header before'), const Rect.fromLTRB(0, 0, 400, 80));
    expect(
        rectOf(tester, 'Item before.0'), const Rect.fromLTRB(0, 60, 400, 100));
    expect(
        rectOf(tester, 'Header after'), const Rect.fromLTRB(0, 100, 400, 180));
  });

  group('hit testing', () {
    testWidgets('pinned header and content', (tester) async {
      final taps = <String>[];
      await pumpSections(tester, reverse: true, stickToEnd: true, taps: taps);

      await tester.tapAt(const Offset(200, 40));
      await tester.tapAt(const Offset(200, 780));

      expect(taps, ['Header #0', 'Item 0.0']);
    });

    testWidgets('pushed header and header following its section',
        (tester) async {
      final taps = <String>[];
      final positions = <Offset>[];
      final controller = await pumpSections(
        tester,
        reverse: true,
        stickToEnd: true,
        taps: taps,
        tapPositions: positions,
      );

      // Header #1 is between -60 and 20, Header #0 between 20 and 100.
      controller.jumpTo(100);
      await tester.pump();
      await tester.tapAt(const Offset(200, 10));
      await tester.tapAt(const Offset(200, 60));

      expect(taps, ['Header #1', 'Header #0']);
      expect(positions, [const Offset(200, 70), const Offset(200, 40)]);
    });
  });

  group('state', () {
    testWidgets('builder and onStateChanged', (tester) async {
      final built = <int, SliverStickyHeaderState>{};
      final changed = <int, SliverStickyHeaderState>{};
      final controller = await pumpSections(
        tester,
        reverse: true,
        stickToEnd: true,
        onHeaderState: (s, state) => built[s] = state,
        onStateChanged: (s, state) => changed[s] = state,
      );

      expect(built[0], const SliverStickyHeaderState(0, true));
      expect(changed[0], const SliverStickyHeaderState(0, true));

      controller.jumpTo(100);
      await tester.pump();

      expect(built[0], const SliverStickyHeaderState(0, false));
      expect(built[1], const SliverStickyHeaderState(0.75, true));
      expect(changed[0], const SliverStickyHeaderState(0, false));
      expect(changed[1], const SliverStickyHeaderState(0.75, true));
    });

    testWidgets('controller', (tester) async {
      final stickyHeaderController = StickyHeaderController();
      final controller = await pumpSections(
        tester,
        reverse: true,
        stickToEnd: true,
        stickyHeaderController: stickyHeaderController,
      );

      expect(stickyHeaderController.stickyHeaderScrollOffset, 0);

      controller.jumpTo(160);
      await tester.pump();

      expect(stickyHeaderController.stickyHeaderScrollOffset, 880);
    });
  });
}
