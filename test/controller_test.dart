import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_sticky_header/flutter_sticky_header.dart';

void main() {
  setUp(() {
    WidgetsBinding.instance.renderView.configuration = TestViewConfiguration(size: Size(400, 800));
  });

  testWidgets('StickyHeaderController.stickyHeaderScrollOffset', (WidgetTester tester) async {
    final StickyHeaderController stickyHeaderController = StickyHeaderController();
    final ScrollController scrollController = ScrollController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            cacheExtent: 0,
            controller: scrollController,
            slivers: <Widget>[
              SliverStickyHeader(
                header: _Header(index: 0),
                sliver: const _Sliver(),
                controller: stickyHeaderController,
              ),
              SliverStickyHeader(
                header: _Header(index: 1),
                sliver: const _Sliver(),
                controller: stickyHeaderController,
              ),
              SliverStickyHeader(
                header: _Header(index: 2),
                sliver: const _Sliver(),
                controller: stickyHeaderController,
              ),
            ],
          ),
        ),
      ),
    );

    final header00Finder = find.text('Header #0');
    final header01Finder = find.text('Header #1');
    final header02Finder = find.text('Header #2');

    expect(header00Finder, findsOneWidget);
    expect(header01Finder, findsNothing);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(0));

    final gesture = await tester.startGesture(Offset(200, 100));

    // We scroll just before the Header #1.
    await gesture.moveBy(Offset(0, -80));
    await tester.pump();

    expect(header00Finder, findsOneWidget);
    expect(header01Finder, findsNothing);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(0));

    // We scroll just after the Header #1 so that it is visible.
    await gesture.moveBy(Offset(0, -80));
    await tester.pump();

    expect(header00Finder, findsOneWidget);
    expect(header01Finder, findsOneWidget);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(0));

    // We scroll in a way that Headers 0 and 1 are side by side.
    await gesture.moveBy(Offset(0, -640));
    await tester.pump();

    expect(header00Finder, findsOneWidget);
    expect(header01Finder, findsOneWidget);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(0));

    // We scroll in a way that Header #1 is at the top of the screen.
    await gesture.moveBy(Offset(0, -80));
    await tester.pump();

    expect(header00Finder, findsNothing);
    expect(header01Finder, findsOneWidget);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(880));

    // We scroll in a way that Header #1 is not visible.
    await gesture.moveBy(Offset(0, -80));
    await tester.pump();

    expect(header00Finder, findsNothing);
    expect(header01Finder, findsOneWidget);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(880));
  });

  testWidgets('StickyHeaderController.stickyHeaderScrollOffset - reverse', (WidgetTester tester) async {
    final StickyHeaderController stickyHeaderController = StickyHeaderController();
    final ScrollController scrollController = ScrollController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            controller: scrollController,
            cacheExtent: 0,
            reverse: true,
            slivers: <Widget>[
              SliverStickyHeader(
                header: _Header(index: 0),
                sliver: const _Sliver(),
                controller: stickyHeaderController,
              ),
              SliverStickyHeader(
                header: _Header(index: 1),
                sliver: const _Sliver(),
                controller: stickyHeaderController,
              ),
              SliverStickyHeader(
                header: _Header(index: 2),
                sliver: const _Sliver(),
                controller: stickyHeaderController,
              ),
            ],
          ),
        ),
      ),
    );

    final header00Finder = find.text('Header #0');
    final header01Finder = find.text('Header #1');
    final header02Finder = find.text('Header #2');

    expect(header00Finder, findsOneWidget);
    expect(header01Finder, findsNothing);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(0));

    final gesture = await tester.startGesture(Offset(200, 100));

    // We scroll just before the Header #1.
    await gesture.moveBy(Offset(0, 80));
    await tester.pump();

    expect(header00Finder, findsOneWidget);
    expect(header01Finder, findsNothing);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(0));

    // We scroll just after the Header #1 so that it is visible.
    await gesture.moveBy(Offset(0, 80));
    await tester.pump();

    expect(header00Finder, findsOneWidget);
    expect(header01Finder, findsOneWidget);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(0));

    // We scroll in a way that Headers 0 and 1 are side by side.
    await gesture.moveBy(Offset(0, 640));
    await tester.pump();

    expect(header00Finder, findsOneWidget);
    expect(header01Finder, findsOneWidget);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(0));

    // We scroll in a way that Header #1 is at the top of the screen.
    await gesture.moveBy(Offset(0, 80));
    await tester.pump();

    expect(header00Finder, findsNothing);
    expect(header01Finder, findsOneWidget);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(880));

    // We scroll in a way that Header #1 is no longer visible.
    await gesture.moveBy(Offset(0, 80));
    await tester.pump();

    expect(header00Finder, findsNothing);
    expect(header01Finder, findsOneWidget);
    expect(header02Finder, findsNothing);
    expect(stickyHeaderController.stickyHeaderScrollOffset, equals(880));
  });
}

class _Header extends StatelessWidget {
  const _Header({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Text('Header #$index'),
      height: 80,
    );
  }
}

class _Sliver extends StatelessWidget {
  const _Sliver({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => const _SliverItem(),
        childCount: 20,
      ),
    );
  }
}

class _SliverItem extends StatelessWidget {
  const _SliverItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 40);
  }
}
