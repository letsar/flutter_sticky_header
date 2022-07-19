import 'package:example/examples/nested.dart';
import 'package:flutter/material.dart';

import 'examples/animated_header.dart';
import 'examples/grid.dart';
import 'examples/list.dart';
import 'examples/mix_slivers.dart';
import 'examples/not_sticky.dart';
import 'examples/reverse.dart';
import 'examples/reverse2.dart';
import 'examples/side_header.dart';

void main() {
  // debugPaintPointersEnabled = true;
  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sticky Headers',
      home: const _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Sticky Headers'),
      ),
      body: ListView(
        children: <Widget>[
          _Item(
            text: 'List Example',
            builder: (_) => const ListExample(),
          ),
          _Item(
            text: 'Grid Example',
            builder: (_) => const GridExample(),
          ),
          _Item(
            text: 'Not Sticky Example',
            builder: (_) => const NotStickyExample(),
          ),
          _Item(
            text: 'Side Header Example',
            builder: (_) => const SideHeaderExample(),
          ),
          _Item(
            text: 'Animated Header Example',
            builder: (_) => const AnimatedHeaderExample(),
          ),
          _Item(
            text: 'Reverse List Example',
            builder: (_) => const ReverseExample(),
          ),
          _Item(
            text: 'Reverse List Example 2',
            builder: (_) => const ReverseExample2(),
          ),
          _Item(
            text: 'Mixing other slivers',
            builder: (_) => const MixSliversExample(),
          ),
          _Item(
            text: 'Nested sticky headers',
            builder: (_) => const NestedExample(),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key? key,
    required this.text,
    required this.builder,
  }) : super(key: key);

  final String text;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: InkWell(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: builder)),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
