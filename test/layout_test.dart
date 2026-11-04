import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('vertical', () {
    testWidgets('header is at the top of its section at rest', (tester) async {
      await pumpSections(tester);

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 0, 400, 80));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 80, 400, 120));
      expect(
          rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 880, 400, 960));
    });

    testWidgets('header is pinned while its section is scrolled',
        (tester) async {
      final controller = await pumpSections(tester);

      controller.jumpTo(100);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 0, 400, 80));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, -20, 400, 20));
    });

    testWidgets('header is pushed by the end of its section', (tester) async {
      final controller = await pumpSections(tester);

      controller.jumpTo(840);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, -40, 400, 40));
      expect(rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 40, 400, 120));
    });

    testWidgets('next header takes over at the end of the section',
        (tester) async {
      final controller = await pumpSections(tester);

      controller.jumpTo(1000);
      await tester.pump();

      expect(find.text('Header #0'), findsNothing);
      expect(rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 0, 400, 80));
    });

    testWidgets('not sticky header scrolls with its section', (tester) async {
      final controller = await pumpSections(tester, sticky: false);

      controller.jumpTo(50);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, -50, 400, 30));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 30, 400, 70));
    });

    testWidgets('header over the content at rest', (tester) async {
      await pumpSections(tester, overlapsContent: true);

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 0, 400, 80));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 0, 400, 40));
      expect(
          rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 800, 400, 880));
    });

    testWidgets('header over the content is pinned while scrolled',
        (tester) async {
      final controller = await pumpSections(tester, overlapsContent: true);

      controller.jumpTo(100);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 0, 400, 80));
      expect(
          rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, -100, 400, -60));
    });

    testWidgets('header over the content is pushed by the end of its section',
        (tester) async {
      final controller = await pumpSections(tester, overlapsContent: true);

      controller.jumpTo(760);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, -40, 400, 40));
      expect(rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 40, 400, 120));
    });

    testWidgets('header is pinned below a pinned SliverAppBar', (tester) async {
      final controller = await pumpSections(
        tester,
        leading: const SliverAppBar(pinned: true, toolbarHeight: 50),
      );

      controller.jumpTo(100);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 50, 400, 130));
    });

    testWidgets('header follows its section when overscrolling at the start',
        (tester) async {
      final controller = await pumpSections(
        tester,
        physics: const BouncingScrollPhysics(),
      );

      controller.jumpTo(-60);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 60, 400, 140));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 140, 400, 180));
    });

    testWidgets(
        'header over the content follows its section when overscrolling at '
        'the start', (tester) async {
      final controller = await pumpSections(
        tester,
        overlapsContent: true,
        physics: const BouncingScrollPhysics(),
      );

      controller.jumpTo(-60);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 60, 400, 140));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 60, 400, 100));
    });
  });

  group('vertical reversed', () {
    testWidgets('header is at the bottom of its section at rest',
        (tester) async {
      await pumpSections(tester, reverse: true);

      expect(
          rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 720, 400, 800));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 680, 400, 720));
    });

    testWidgets('header is pinned while its section is scrolled',
        (tester) async {
      final controller = await pumpSections(tester, reverse: true);

      controller.jumpTo(100);
      await tester.pump();

      expect(
          rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 720, 400, 800));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 780, 400, 820));
    });

    testWidgets('header is pushed by the end of its section', (tester) async {
      final controller = await pumpSections(tester, reverse: true);

      controller.jumpTo(840);
      await tester.pump();

      expect(
          rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 760, 400, 840));
      expect(
          rectOf(tester, 'Header #1'), const Rect.fromLTRB(0, 680, 400, 760));
    });

    testWidgets('header follows its section when overscrolling at the start',
        (tester) async {
      final controller = await pumpSections(
        tester,
        reverse: true,
        physics: const BouncingScrollPhysics(),
      );

      controller.jumpTo(-60);
      await tester.pump();

      expect(
          rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 660, 400, 740));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(0, 620, 400, 660));
    });
  });

  group('horizontal', () {
    testWidgets('header is at the start of its section at rest',
        (tester) async {
      await pumpSections(tester, axis: Axis.horizontal);

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 0, 80, 800));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(80, 0, 120, 800));
    });

    testWidgets('header is pinned while its section is scrolled',
        (tester) async {
      final controller = await pumpSections(tester, axis: Axis.horizontal);

      controller.jumpTo(100);
      await tester.pump();

      expect(rectOf(tester, 'Header #0'), const Rect.fromLTRB(0, 0, 80, 800));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(-20, 0, 20, 800));
    });

    testWidgets('header is pinned while its section is scrolled - reverse',
        (tester) async {
      final controller =
          await pumpSections(tester, axis: Axis.horizontal, reverse: true);

      controller.jumpTo(100);
      await tester.pump();

      expect(
          rectOf(tester, 'Header #0'), const Rect.fromLTRB(320, 0, 400, 800));
      expect(rectOf(tester, 'Item 0.0'), const Rect.fromLTRB(380, 0, 420, 800));
    });
  });

  testWidgets('Scrollable.ensureVisible scrolls to an item', (tester) async {
    final controller = await pumpSections(tester);

    Scrollable.ensureVisible(
      tester.element(find.text('Item 1.2', skipOffstage: false)),
    );
    await tester.pump();

    // Section #1 starts at 880, its content at 960.
    expect(controller.offset, 960 + 2 * 40);
  });

  testWidgets(
      'Scrollable.ensureVisible scrolls to an item of a visible section '
      '(#59)', (tester) async {
    final controller = await pumpSections(tester);

    Scrollable.ensureVisible(
      tester.element(find.text('Item 0.5', skipOffstage: false)),
    );
    await tester.pump();

    expect(controller.offset, 80 + 5 * 40);

    // Header #0 is pinned and Section #1 is visible.
    controller.jumpTo(200);
    await tester.pump();
    Scrollable.ensureVisible(
      tester.element(find.text('Item 1.2', skipOffstage: false)),
    );
    await tester.pump();

    expect(controller.offset, 960 + 2 * 40);
  });

  testWidgets('Scrollable.ensureVisible scrolls to a visible section (#59)',
      (tester) async {
    final controller = await pumpSections(tester);
    controller.jumpTo(200);
    await tester.pump();

    Scrollable.ensureVisible(
      tester.element(
        find.ancestor(
          of: find.text('Header #1', skipOffstage: false),
          matching: find.byType(SliverStickyHeader, skipOffstage: false),
        ),
      ),
    );
    await tester.pump();

    expect(controller.offset, 880);
  });

  testWidgets(
      'Scrollable.ensureVisible scrolls to an item when the header overlaps '
      'the content', (tester) async {
    final controller = await pumpSections(tester, overlapsContent: true);

    Scrollable.ensureVisible(
      tester.element(find.text('Item 1.2', skipOffstage: false)),
    );
    await tester.pump();

    // Section #1 starts at 800 and its content starts with it.
    expect(controller.offset, 800 + 2 * 40);
    expect(rectOf(tester, 'Item 1.2'), const Rect.fromLTRB(0, 0, 400, 40));
  });
}
