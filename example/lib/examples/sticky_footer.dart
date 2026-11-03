import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../common.dart';

class StickyFooterExample extends StatelessWidget {
  const StickyFooterExample({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sticky Footer Example',
      slivers: [
        for (int i = 0; i < 4; i++)
          SliverStickyHeader(
            stickToEnd: true,
            header: Header(title: 'Footer #$i'),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, j) => ListTile(
                  leading: CircleAvatar(
                    child: Text('$i'),
                  ),
                  title: Text('List tile #$j'),
                ),
                childCount: 10,
              ),
            ),
          ),
      ],
    );
  }
}
