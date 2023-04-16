import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../common.dart';

class MixSliversExample extends StatelessWidget {
  const MixSliversExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'List Example',
      slivers: [
        const SliverAppBar(
          backgroundColor: Colors.orange,
          title: Text('SliverAppBar'),
          automaticallyImplyLeading: false,
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            color: Colors.red,
          ),
        ),
        const _StickyHeaderList(index: 0),
        const _StickyHeaderList(index: 1),
        const _StickyHeaderList(index: 2),
        const _StickyHeaderList(index: 3),
      ],
    );
  }
}

class _StickyHeaderList extends StatelessWidget {
  const _StickyHeaderList({
    Key? key,
    this.index,
  }) : super(key: key);

  final int? index;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Header(index: index),
      sliver: SliverList(
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
    );
  }
}
