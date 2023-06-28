import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../common.dart';

class ActivityHandlerExample extends StatefulWidget {
  const ActivityHandlerExample({
    Key? key,
  }) : super(key: key);

  @override
  State<ActivityHandlerExample> createState() => _ActivityHandlerExampleState();
}

class _ActivityHandlerExampleState extends State<ActivityHandlerExample> {
  int pinnedHeaderIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      reverse: false,
      title: 'Header #$pinnedHeaderIndex is pinned',
      slivers: [
        _StickyHeaderList(index: 0, onHeaderPinned: onHeaderPinned),
        _StickyHeaderList(index: 1, onHeaderPinned: onHeaderPinned),
        _StickyHeaderList(index: 2, onHeaderPinned: onHeaderPinned),
        _StickyHeaderList(index: 3, onHeaderPinned: onHeaderPinned),
      ],
    );
  }

  void onHeaderPinned(int index) {
    setState(() {
      pinnedHeaderIndex = index;
    });
  }
}

class _StickyHeaderList extends StatelessWidget {
  const _StickyHeaderList({
    Key? key,
    this.index,
    required this.onHeaderPinned,
  }) : super(key: key);

  final int? index;
  final void Function(int index) onHeaderPinned;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      activityHandler: (activity) {
        debugPrint("[Header#$index] $activity");
        if (activity == SliverStickyHeaderActivity.pinned) {
          onHeaderPinned(index!);
        }
      },
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
