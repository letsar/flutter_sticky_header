import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

/// A chat where the newest messages are at the bottom.
///
/// The list is reversed, so each day uses stickToEnd to display its date at
/// the top of its messages, and to stick it to the top of the viewport.
class ChatExample extends StatelessWidget {
  const ChatExample({
    Key? key,
  }) : super(key: key);

  static const List<String> _days = [
    'Today',
    'Yesterday',
    'Monday',
    'Sunday',
    'Saturday',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Example'),
      ),
      body: CustomScrollView(
        reverse: true,
        slivers: [
          for (int d = 0; d < _days.length; d++)
            SliverStickyHeader(
              stickToEnd: true,
              overlapsContent: true,
              header: _DateChip(day: _days[d]),
              sliver: SliverPadding(
                // Leave room for the date chip above the oldest message.
                padding: const EdgeInsets.only(top: 48),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _Message(
                      text: 'Message #$i of ${_days[d].toLowerCase()}',
                      isMine: (i + d).isEven,
                    ),
                    childCount: 8,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    Key? key,
    required this.day,
  }) : super(key: key);

  final String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(day, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    Key? key,
    required this.text,
    required this.isMine,
  }) : super(key: key);

  final String text;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMine ? Colors.lightGreen.shade200 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text),
      ),
    );
  }
}
