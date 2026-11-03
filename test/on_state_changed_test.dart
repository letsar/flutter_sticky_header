import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  late Map<int, List<SliverStickyHeaderState>> changes;

  setUp(() => changes = {});
  void record(int section, SliverStickyHeaderState state) =>
      (changes[section] ??= []).add(state);

  testWidgets('reports the initial state of laid out headers', (tester) async {
    await pumpSections(tester, onStateChanged: record);

    expect(changes[0], [const SliverStickyHeaderState(0, true)]);
    expect(changes[1], [const SliverStickyHeaderState(0, false)]);
  });

  testWidgets('reports only changes', (tester) async {
    final controller = await pumpSections(tester, onStateChanged: record);

    controller.jumpTo(100);
    await tester.pump();
    controller.jumpTo(200);
    await tester.pump();

    expect(changes[0], [const SliverStickyHeaderState(0, true)]);
  });

  testWidgets('reports when the header is pushed and replaced', (tester) async {
    final controller = await pumpSections(tester, onStateChanged: record);

    controller.jumpTo(820);
    await tester.pump();
    controller.jumpTo(840);
    await tester.pump();
    controller.jumpTo(880);
    await tester.pump();

    expect(changes[0], [
      const SliverStickyHeaderState(0, true),
      const SliverStickyHeaderState(0.25, true),
      const SliverStickyHeaderState(0.5, true),
      const SliverStickyHeaderState(1, true),
    ]);
    expect(changes[1], [
      const SliverStickyHeaderState(0, false),
      const SliverStickyHeaderState(0, true),
    ]);
  });

  testWidgets('reports the state of a header built with a builder',
      (tester) async {
    final controller = await pumpSections(
      tester,
      onHeaderState: (_, __) {},
      onStateChanged: record,
    );

    controller.jumpTo(840);
    await tester.pump();

    expect(changes[0], [
      const SliverStickyHeaderState(0, true),
      const SliverStickyHeaderState(0.5, true),
    ]);
  });

  testWidgets('reports once per frame when the header is laid out again',
      (tester) async {
    await pumpSections(
      tester,
      headerExtentOf: (state) => state.isPinned ? 50 : 80,
      onStateChanged: record,
    );

    expect(changes[0], [const SliverStickyHeaderState(0, true)]);
  });

  testWidgets('can call setState from the callback', (tester) async {
    late StateSetter setState;
    int rebuilds = 0;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            rebuilds++;
            return CustomScrollView(
              slivers: [
                SliverStickyHeader(
                  header: const SizedBox(height: 80),
                  sliver: const SliverToBoxAdapter(
                    child: SizedBox(height: 1000),
                  ),
                  onStateChanged: (state) => setState(() {}),
                ),
              ],
            );
          },
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(rebuilds, 2);
  });
}
