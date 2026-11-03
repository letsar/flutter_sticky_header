import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../common.dart';

class OnStateChangedExample extends StatefulWidget {
  const OnStateChangedExample({
    Key? key,
  }) : super(key: key);

  @override
  State<OnStateChangedExample> createState() => _OnStateChangedExampleState();
}

class _OnStateChangedExampleState extends State<OnStateChangedExample> {
  static const int _sectionCount = 6;

  final Map<int, SliverStickyHeaderState> _states = {};
  int _calls = 0;

  void _onStateChanged(int index, SliverStickyHeaderState state) {
    // Called after the frame, so we can call setState.
    setState(() {
      _states[index] = state;
      _calls++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<int> pinned = [
      for (final entry in _states.entries)
        if (entry.value.isPinned && entry.value.scrollPercentage < 1) entry.key,
    ]..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pinned.isEmpty
              ? 'No pinned header'
              : 'Pinned: #${pinned.join(', #')}',
        ),
      ),
      body: Column(
        children: [
          _StatesPanel(states: _states, calls: _calls),
          Expanded(
            child: CustomScrollView(
              slivers: [
                for (int i = 0; i < _sectionCount; i++)
                  SliverStickyHeader(
                    header: Header(index: i),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, j) => ListTile(
                          leading: CircleAvatar(
                            child: Text('$i'),
                          ),
                          title: Text('List tile #$j'),
                        ),
                        childCount: 8,
                      ),
                    ),
                    onStateChanged: (state) => _onStateChanged(i, state),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatesPanel extends StatelessWidget {
  const _StatesPanel({
    Key? key,
    required this.states,
    required this.calls,
  }) : super(key: key);

  final Map<int, SliverStickyHeaderState> states;
  final int calls;

  @override
  Widget build(BuildContext context) {
    final List<int> indexes = states.keys.toList()..sort();
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(8),
      child: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'monospace', color: Colors.black87),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('onStateChanged calls: $calls'),
            for (final index in indexes)
              Text(
                '#$index  isPinned: ${states[index]!.isPinned ? 'true ' : 'false'}'
                '  scrollPercentage: '
                '${states[index]!.scrollPercentage.toStringAsFixed(2)}',
              ),
          ],
        ),
      ),
    );
  }
}
