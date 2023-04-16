import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../common.dart';

class ListExample extends StatelessWidget {
  const ListExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'List Example',
      slivers: [
        _StickyHeaderList(index: 0),
        _StickyHeaderList(index: 1),
        _StickyHeaderList(index: 2),
        _StickyHeaderList(index: 3),
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
            onTap: () {
              debugPrint('tile $i');
            },
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
