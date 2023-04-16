import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../common.dart';

class GridExample extends StatelessWidget {
  const GridExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Grid Example',
      slivers: [
        _StickyHeaderGrid(index: 0),
        _StickyHeaderGrid(index: 1),
        _StickyHeaderGrid(index: 2),
        _StickyHeaderGrid(index: 3),
      ],
    );
  }
}

class _StickyHeaderGrid extends StatelessWidget {
  const _StickyHeaderGrid({
    Key? key,
    this.index,
  }) : super(key: key);

  final int? index;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Header(index: index),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        delegate: SliverChildBuilderDelegate(
          (context, i) => GridTile(
            footer: Container(
              color: Colors.white.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Grid tile #$i',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            child: Card(
              child: Container(
                color: Colors.green,
              ),
            ),
          ),
          childCount: 9,
        ),
      ),
    );
  }
}
