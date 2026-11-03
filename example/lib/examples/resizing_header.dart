import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../common.dart';

class ResizingHeaderExample extends StatelessWidget {
  const ResizingHeaderExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Resizing header Example',
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
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader.builder(
      builder: (context, state) => _ResizingHeader(
        state: state,
        index: index,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => ListTile(
            tileColor: i.isEven ? Colors.amber.shade100 : Colors.amber.shade200,
            leading: CircleAvatar(
              child: Text('$index'),
            ),
            title: Text('List tile #$i'),
          ),
          childCount: 10,
        ),
      ),
    );
  }
}

/// A header which is smaller when it is pinned.
class _ResizingHeader extends StatelessWidget {
  const _ResizingHeader({
    Key? key,
    required this.state,
    required this.index,
  }) : super(key: key);

  final int index;
  final SliverStickyHeaderState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: state.isPinned ? 48 : 96,
      color: state.isPinned ? Colors.indigo : Colors.lightBlue,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        'Header #$index (${state.isPinned ? 'pinned' : 'not pinned'})',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
