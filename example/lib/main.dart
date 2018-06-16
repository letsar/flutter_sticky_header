import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sticky Header example',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = new List<Widget>();

    slivers.addAll(_buildLists(0, 3));
    slivers.addAll(_buildGrids(3, 3));
    slivers.addAll(_buildSideHeaderGrids(6, 3));
    slivers.addAll(_buildHeaderBuilderLists(9, 5));

    return new SimpleScaffold(
      title: 'Flutter Sticky Header example',
      child: new CustomScrollView(slivers: slivers),
    );
  }

  List<Widget> _buildLists(int firstIndex, int count) {
    return List.generate(count, (sliverIndex) {
      sliverIndex += firstIndex;
      return new SliverStickyHeader(
        header: _buildHeader(sliverIndex),
        sliver: new SliverList(
          delegate: new SliverChildBuilderDelegate(
            (context, i) => new ListTile(
                  leading: new CircleAvatar(
                    child: new Text('$sliverIndex'),
                  ),
                  title: new Text('List tile #$i'),
                ),
            childCount: 4,
          ),
        ),
      );
    });
  }

  List<Widget> _buildHeaderBuilderLists(int firstIndex, int count) {
    return List.generate(count, (sliverIndex) {
      sliverIndex += firstIndex;
      return new SliverStickyHeaderBuilder(
        builder: (context, scrollPercentage) =>
            _buildAnimatedHeader(sliverIndex, scrollPercentage),
        sliver: new SliverList(
          delegate: new SliverChildBuilderDelegate(
            (context, i) => new ListTile(
                  leading: new CircleAvatar(
                    child: new Text('$sliverIndex'),
                  ),
                  title: new Text('List tile #$i'),
                ),
            childCount: 4,
          ),
        ),
      );
    });
  }

  List<Widget> _buildGrids(int firstIndex, int count) {
    return List.generate(count, (sliverIndex) {
      sliverIndex += firstIndex;
      return new SliverStickyHeader(
        header: _buildHeader(sliverIndex),
        sliver: new SliverGrid(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          delegate: new SliverChildBuilderDelegate(
            (context, i) => new GridTile(
                  child: Card(
                    child: new Container(
                      color: Colors.green,
                    ),
                  ),
                  footer: new Container(
                    color: Colors.white.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        'Grid tile #$i',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
            childCount: 9,
          ),
        ),
      );
    });
  }

  List<Widget> _buildSideHeaderGrids(int firstIndex, int count) {
    return List.generate(count, (sliverIndex) {
      sliverIndex += firstIndex;
      return new SliverStickyHeader(
        overlapsContent: true,
        header: _buildSideHeader(sliverIndex),
        sliver: new SliverPadding(
          padding: new EdgeInsets.only(left: 60.0),
          sliver: new SliverGrid(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 1.0),
            delegate: new SliverChildBuilderDelegate(
              (context, i) => new GridTile(
                    child: Card(
                      child: new Container(
                        color: Colors.orange,
                      ),
                    ),
                    footer: new Container(
                      color: Colors.white.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Text(
                          'Grid tile #$i',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
              childCount: 12,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(int index, {String text}) {
    return new Container(
      height: 60.0,
      color: Colors.lightBlue,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: new Text(
        text ?? 'Header #$index',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildSideHeader(int index, {String text}) {
    return new Container(
      height: 60.0,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: new CircleAvatar(
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        child: new Text('$index'),
      ),
    );
  }

  Widget _buildAnimatedHeader(int index, double scrollPercentage) {
    return new Container(
      height: 60.0,
      color: Colors.lightBlue.withOpacity(1.0 - scrollPercentage),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: new Text(
        'Header #$index',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class SimpleScaffold extends StatelessWidget {
  const SimpleScaffold({
    Key key,
    this.title,
    this.child,
  }) : super(key: key);

  final String title;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: child,
    );
  }
}
