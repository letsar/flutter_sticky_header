import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_test/flutter_test.dart';

// Viewport: 400x800. Each section is a header of 80 followed by 20 items of
// 40, so a section is 880 long (800 when the header overlaps the content).

/// Returns the global rect of the box displaying [text], even if it is only
/// in the cache extent.
Rect rectOf(WidgetTester tester, String text) {
  return tester.getRect(
    find
        .ancestor(
          of: find.text(text, skipOffstage: false),
          matching: find.byType(SizedBox, skipOffstage: false),
        )
        .first,
  );
}

/// Pumps a [CustomScrollView] with 3 sections named 'Header #s' and
/// 'Item s.i'.
///
/// Tapping a header or an item adds its text to [taps].
/// When [onHeaderState] is set, headers are built with
/// [SliverStickyHeader.builder] and report each state they are built with.
Future<ScrollController> pumpSections(
  WidgetTester tester, {
  bool sticky = true,
  bool overlapsContent = false,
  bool reverse = false,
  Axis axis = Axis.vertical,
  Widget? leading,
  List<String>? taps,
  void Function(int section, SliverStickyHeaderState state)? onHeaderState,
}) async {
  tester.view.physicalSize = const Size(400, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final controller = ScrollController();
  addTearDown(controller.dispose);

  final bool vertical = axis == Axis.vertical;
  Widget box(String text, double extent) => GestureDetector(
        onTap: () => taps?.add(text),
        child: SizedBox(
          width: vertical ? null : extent,
          height: vertical ? extent : null,
          child: Text(text),
        ),
      );

  Widget section(int s) {
    final sliver = SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => box('Item $s.$i', 40),
        childCount: 20,
      ),
    );
    if (onHeaderState != null) {
      return SliverStickyHeader.builder(
        sticky: sticky,
        overlapsContent: overlapsContent,
        builder: (context, state) {
          onHeaderState(s, state);
          return box('Header #$s', 80);
        },
        sliver: sliver,
      );
    }
    return SliverStickyHeader(
      sticky: sticky,
      overlapsContent: overlapsContent,
      header: box('Header #$s', 80),
      sliver: sliver,
    );
  }

  await tester.pumpWidget(
    MaterialApp(
      home: CustomScrollView(
        controller: controller,
        scrollDirection: axis,
        reverse: reverse,
        slivers: <Widget>[
          if (leading != null) leading,
          for (int s = 0; s < 3; s++) section(s),
        ],
      ),
    ),
  );
  return controller;
}
