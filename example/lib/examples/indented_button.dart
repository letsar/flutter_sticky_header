import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../common.dart';

class IndentedButton extends StatelessWidget {
  const IndentedButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'List Example',
      slivers: [
        _StickyHeaderListLevel1(index: 0),
        _StickyHeaderListLevel1(index: 1),
        _StickyHeaderListLevel1(index: 2),
        _StickyHeaderListLevel1(index: 3),
      ],
    );
  }
}

class _StickyHeaderListLevel1 extends StatelessWidget {
  const _StickyHeaderListLevel1({
    Key? key,
    this.index,
  }) : super(key: key);

  final int? index;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: HeaderWithButton(index: index),
      slivers: [
        _StickyHeaderListLevel2(index: 0),
        _StickyHeaderListLevel2(index: 1),
        _StickyHeaderListLevel2(index: 2),
        _StickyHeaderListLevel2(index: 3),
      ],
    );
  }
}

class _StickyHeaderListLevel2 extends StatelessWidget {
  const _StickyHeaderListLevel2({
    Key? key,
    this.index,
  }) : super(key: key);

  final int? index;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: HeaderWithButton(title: "Subheader $index"),
      slivers: [
        _StickyHeaderListLevel3(index: 0),
        _StickyHeaderListLevel3(index: 1),
        _StickyHeaderListLevel3(index: 2),
        _StickyHeaderListLevel3(index: 3),
      ],
    );
  }
}

class _StickyHeaderListLevel3 extends StatelessWidget {
  const _StickyHeaderListLevel3({
    Key? key,
    this.index,
  }) : super(key: key);

  final int? index;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: HeaderWithButton(title: "Subsubheader $index"),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) => ListTile(
              leading: CircleAvatar(
                child: Text('$index'),
              ),
              title: Text('List tile #$i'),
            ),
            childCount: 6,
          ),
        ),
      ],
    );
  }
}
