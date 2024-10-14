import 'package:example/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:sliver_tools/sliver_tools.dart';

class NestedExample extends StatelessWidget {
  const NestedExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Nested Sticky Headers',
      slivers: [
        SliverStickyHeader(
          header: const Header(title: '1'),
          sliver: MultiSliver(
            children: [
              const SliverStickyHeader(
                header: Header(title: '1.1'),
                sliver: _SliverLeaf(),
              ),
              SliverStickyHeader(
                header: const Header(title: '1.2'),
                sliver: MultiSliver(
                  children: const [
                    SliverStickyHeader(
                      header: Header(title: '1.2.1'),
                      sliver: _SliverLeaf(),
                    ),
                    SliverStickyHeader(
                      header: Header(title: '1.2.2'),
                      sliver: _SliverLeaf(),
                    ),
                    SliverStickyHeader(
                      header: Header(title: '1.2.3'),
                      sliver: _SliverLeaf(),
                    ),
                  ],
                ),
              ),
              const SliverStickyHeader(
                header: Header(title: '1.3'),
                sliver: _SliverLeaf(),
              ),
            ],
          ),
        ),
        SliverStickyHeader(
          header: const Header(title: '2'),
          sliver: MultiSliver(
            children: [
              const SliverStickyHeader(
                header: Header(title: '2.1'),
                sliver: _SliverLeaf(),
              ),
              SliverStickyHeader(
                header: const Header(title: '2.2'),
                sliver: MultiSliver(
                  children: const [
                    SliverStickyHeader(
                      header: Header(title: '2.2.1'),
                      sliver: _SliverLeaf(),
                    ),
                    SliverStickyHeader(
                      header: Header(title: '2.2.2'),
                      sliver: _SliverLeaf(),
                    ),
                    SliverStickyHeader(
                      header: Header(title: '2.2.3'),
                      sliver: _SliverLeaf(),
                    ),
                  ],
                ),
              ),
              const SliverStickyHeader(
                header: Header(title: '2.3'),
                sliver: _SliverLeaf(),
              ),
            ],
          ),
        ),
        const SliverStickyHeader(
          header: Header(title: '3'),
          sliver: _SliverLeaf(),
        ),
        SliverStickyHeader(
          header: const Header(title: '4'),
          sliver: MultiSliver(
            children: const [
              SliverStickyHeader(
                header: Header(title: '4.1'),
                sliver: _SliverLeaf(),
              ),
              SliverStickyHeader(
                header: Header(title: '4.2'),
                sliver: _SliverLeaf(),
              ),
              SliverStickyHeader(
                header: Header(title: '4.3'),
                sliver: _SliverLeaf(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SliverLeaf extends StatelessWidget {
  const _SliverLeaf();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 200,
        color: Colors.amber,
      ),
    );
  }
}
