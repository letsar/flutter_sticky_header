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
    return new SimpleScaffold(
      title: 'Test',
      child: new CustomScrollView(
        slivers: List.generate(50, (index) => buildItem(context, index)),
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    if (index == 3) {
      return new SliverStickyHeader(
        header: new Container(
          height: 60.0,
          color: index.isEven ? Colors.orange : Colors.green,
          padding: new EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.centerLeft,
          child: new Text(
            'Header #$index',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }else if(index ==6) {
      return new SliverStickyHeader(
        sliver: new SliverList(
          delegate: new SliverChildBuilderDelegate(
                (c, i) => new Container(
              height: 40.0,
              color: Colors.lightBlue,
              padding: new EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: new Text(
                'Tile #$i',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            childCount: 5,
          ),
        ),
      );
    } else {
      return buildHeaderAndContent(context, index);
    }
  }

  Widget buildHeaderAndContent(BuildContext context, int index) {
    return new SliverStickyHeader(
      overlapsContent: index == 8,
      header: new Container(
        height: 60.0,
        color: index == 8 ? Colors.deepOrange.withOpacity(0.6) : (index.isEven ? Colors.orange : Colors.green),
        padding: new EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: new Text(
          'Header #$index',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      sliver: new SliverList(
        delegate: new SliverChildBuilderDelegate(
          (c, i) => new Container(
                height: 40.0,
                color: Colors.lightBlue,
                padding: new EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                  'Tile #$i',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          childCount: 8,
        ),
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
