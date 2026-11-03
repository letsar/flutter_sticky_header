import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

void main() {
  runApp(MaterialApp(home: TabHeaderExample()));
}

class TabHeaderExample extends StatefulWidget {
  const TabHeaderExample({Key? key}) : super(key: key);

  @override
  State<TabHeaderExample> createState() => _TabHeaderExampleState();
}

class _TabHeaderExampleState extends State<TabHeaderExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab List Example'),
      ),
      body: CustomScrollView(
        slivers: [
          _StickyHeaderList(index: 0),
          _StickyHeaderList(index: 1),
          _StickyHeaderList(index: 2),
          _StickyHeaderList(index: 3),
        ],
      ),
    );
  }
}

class _StickyHeaderList extends StatefulWidget {
  final int index;
  const _StickyHeaderList({Key? key, required this.index}) : super(key: key);

  @override
  State<_StickyHeaderList> createState() => _StickyHeaderListState();
}

class _StickyHeaderListState extends State<_StickyHeaderList>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Container(
        color: Colors.white,
        height: 47,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: const Color(0xFF216DDF),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2,
                indicatorPadding: EdgeInsets.only(bottom: 10),
                unselectedLabelColor: const Color(0xFF888888),
                unselectedLabelStyle: TextStyle(fontSize: 17),
                labelColor: const Color(0xFF216DDF),
                labelStyle:
                    TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                tabs: _createTabs(),
                onTap: (index) {
                  print(index);
                },
              ),
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 8,
                      offset: Offset(-20, 0),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(left: 5, right: 12),
                child: Row(
                  children: [
                    Text(
                      "全部",
                      style: TextStyle(
                          color: const Color(0xFF101010), fontSize: 17),
                    ),
                  ],
                ),
              ),
              onTap: () {
                // Can not response
                print("1234567");
              },
            ),
          ],
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => ListTile(
            onTap: () {
              print('tile $i');
            },
            leading: CircleAvatar(
              child: Text('${widget.index}'),
            ),
            title: Text('List tile #$i'),
          ),
          childCount: 6,
        ),
      ),
    );
  }

  /// 创建Tabs
  List<Widget> _createTabs() {
    return [
      "我是tab",
      "我是tab",
      "我是tab",
      "我是tab",
      "我是tab",
      "我是tab",
      "我是tab",
      "我是tab",
      "我是tab",
      "我是tab"
    ].map((e) => Tab(text: e)).toList();
  }
}
