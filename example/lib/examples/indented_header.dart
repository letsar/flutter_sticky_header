import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../common.dart';

class IndentedHeaderExample extends StatelessWidget {
  const IndentedHeaderExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
      slivers: [
        SliverStickyHeader(
          header: Header(title: "Subheader #1"),
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
        ),
        SliverStickyHeader(
          header: Header(title: "Subheader #2"),
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
        ),
        SliverStickyHeader(
          header: Header(title: "Subheader #3"),
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
        ),
      ],
    );
  }
}
