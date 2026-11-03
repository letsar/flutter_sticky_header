import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget build({Widget? header, bool stickToEnd = false}) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CustomScrollView(
        slivers: [
          SliverStickyHeader(
            header: header,
            stickToEnd: stickToEnd,
            sliver: const SliverToBoxAdapter(
              child: SizedBox(height: 100, child: Text('Content')),
            ),
          ),
        ],
      ),
    );
  }

  testWidgets('content without header', (tester) async {
    await tester.pumpWidget(build());

    expect(tester.takeException(), isNull);
    expect(tester.getTopLeft(find.text('Content')), Offset.zero);
  });

  testWidgets('content without header when sticking to the end',
      (tester) async {
    await tester.pumpWidget(build(stickToEnd: true));

    expect(tester.takeException(), isNull);
    expect(tester.getTopLeft(find.text('Content')), Offset.zero);
  });

  testWidgets('content after the header is removed', (tester) async {
    await tester.pumpWidget(build(header: const SizedBox(height: 80)));
    expect(tester.getTopLeft(find.text('Content')), const Offset(0, 80));

    await tester.pumpWidget(build());

    expect(tester.takeException(), isNull);
    expect(tester.getTopLeft(find.text('Content')), Offset.zero);
  });
}
