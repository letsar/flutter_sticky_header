import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  late Map<int, SliverStickyHeaderState> states;

  setUp(() => states = {});
  void record(int section, SliverStickyHeaderState state) =>
      states[section] = state;

  testWidgets('header at the top of the viewport is pinned at rest',
      (tester) async {
    await pumpSections(tester, onHeaderState: record);

    expect(states[0], const SliverStickyHeaderState(0, true));
    expect(states[1], const SliverStickyHeaderState(0, false));
  });

  testWidgets('pinned header has a scroll percentage of 0', (tester) async {
    final controller = await pumpSections(tester, onHeaderState: record);

    controller.jumpTo(100);
    await tester.pump();

    expect(states[0], const SliverStickyHeaderState(0, true));
  });

  testWidgets('scroll percentage follows how much the header is pushed',
      (tester) async {
    final controller = await pumpSections(tester, onHeaderState: record);

    controller.jumpTo(820);
    await tester.pump();
    expect(states[0], const SliverStickyHeaderState(0.25, true));

    controller.jumpTo(840);
    await tester.pump();
    expect(states[0], const SliverStickyHeaderState(0.5, true));
    expect(states[1], const SliverStickyHeaderState(0, false));
  });

  testWidgets('scroll percentage when the header overlaps the content',
      (tester) async {
    final controller = await pumpSections(
      tester,
      overlapsContent: true,
      onHeaderState: record,
    );

    controller.jumpTo(760);
    await tester.pump();

    expect(states[0], const SliverStickyHeaderState(0.5, true));
  });

  testWidgets('not sticky header is never pinned', (tester) async {
    final controller = await pumpSections(
      tester,
      sticky: false,
      onHeaderState: record,
    );

    expect(states[0]!.isPinned, isFalse);

    controller.jumpTo(40);
    await tester.pump();

    expect(states[0], const SliverStickyHeaderState(0.5, false));
  });

  testWidgets('scroll percentage follows the header in reverse',
      (tester) async {
    final controller = await pumpSections(
      tester,
      reverse: true,
      onHeaderState: record,
    );

    controller.jumpTo(840);
    await tester.pump();

    expect(states[0], const SliverStickyHeaderState(0.5, true));
  });

  group('header whose extent depends on its state', () {
    double extentOf(SliverStickyHeaderState state) => state.isPinned ? 50 : 80;

    testWidgets('content starts after the header on the first frame',
        (tester) async {
      await pumpSections(tester, headerExtentOf: extentOf);

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 0, 400, 50));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 50, 400, 90));
      expect(
          rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 850, 400, 930));
    });

    testWidgets('content starts after the header when it becomes pinned',
        (tester) async {
      final controller = await pumpSections(tester, headerExtentOf: extentOf);

      // Section #0 is 50 + 800 long, so Header #1 is pinned at 850.
      controller.jumpTo(850);
      await tester.pump();

      expect(rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 0, 400, 50));
      expect(rectOf(tester, 'Item 1.0'), const Rect.fromLTRB(0, 50, 400, 90));
    });
  });
}
