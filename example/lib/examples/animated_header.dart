import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../common.dart';

class AnimatedHeaderExample extends StatelessWidget {
  const AnimatedHeaderExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Animated header Example',
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
    return SliverStickyHeader.builder(
      builder: (context, state) => _AnimatedHeader(
        state: state,
        index: index,
      ),
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

class _AnimatedHeader extends StatelessWidget {
  const _AnimatedHeader({
    Key? key,
    this.state,
    this.index,
  }) : super(key: key);

  final int? index;
  final SliverStickyHeaderState? state;

  @override
  Widget build(BuildContext context) {
    return Header(
      index: index,
      color: Colors.lightBlue.withOpacity(1 - state!.scrollPercentage),
    );
  }
}
