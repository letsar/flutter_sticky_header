# flutter_sticky_header

A Flutter implementation of sticky headers with a sliver as a child.

[![Pub](https://img.shields.io/pub/v/flutter_sticky_header.svg)](https://pub.dartlang.org/packages/flutter_sticky_header)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=QTT34M25RDNL6)

![Screenshot](https://raw.githubusercontent.com/letsar/flutter_sticky_header/master/doc/images/sticky_header_all.gif)

## Features

* Accepts one sliver as content.
* Header can overlap its sliver (useful for sticky side header for example).
* Notifies when the header scrolls outside the viewport.
* Can scroll in any direction.
* Supports overlapping (AppBars for example).
* Supports not sticky headers (with `sticky: false` parameter).
* Supports a controller which notifies the scroll offset of the current sticky header.
* Notifies when the state of a header changes (with the `onStateChanged` parameter).
* Supports headers at the end of their sliver, such as date headers in a reversed chat list or sticky footers (with the `stickToEnd` parameter).

## Do you need this package?

Since Flutter 3.13, you can create simple sticky headers with the framework alone: put a pinned header (for example a `PinnedHeaderSliver`, available since Flutter 3.24) and the content in a `SliverMainAxisGroup`. The header stays pinned until the end of its group:

```dart
CustomScrollView(
  slivers: [
    SliverMainAxisGroup(
      slivers: [
        PinnedHeaderSliver(child: Header()),
        SliverList.builder(itemBuilder: ...),
      ],
    ),
  ],
)
```

This package is still useful if you need:

* a header that overlaps its content, for example sticky side headers (`overlapsContent`);
* a header built from its state, whether it is pinned and how much it is scrolled out (`SliverStickyHeader.builder`), or notified when this state changes (`onStateChanged`);
* the scroll offset of the current sticky header (`StickyHeaderController`);
* a header at the end of its sliver, sticking to the end of the viewport (`stickToEnd`), for example in a reversed list.

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  flutter_sticky_header:
```

In your library add the following import:

```dart
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## SliverStickyHeader

You can place one or multiple `SliverStickyHeader`s inside a `CustomScrollView`.

```dart
SliverStickyHeader(
  header: Container(
    height: 60.0,
    color: Colors.lightBlue,
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    alignment: Alignment.centerLeft,
    child: Text(
      'Header #0',
      style: const TextStyle(color: Colors.white),
    ),
  ),
  sliver: SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, i) => ListTile(
            leading: CircleAvatar(
              child: Text('0'),
            ),
            title: Text('List tile #$i'),
          ),
      childCount: 4,
    ),
  ),
);
```

## SliverStickyHeader.builder

If you want to change the header layout during its scroll, you can use the `SliverStickyHeader.builder` constructor.

The example belows changes the opacity of the header as it scrolls off the viewport.

```dart
SliverStickyHeader.builder(
  builder: (context, state) => Container(
        height: 60.0,
        color: (state.isPinned ? Colors.pink : Colors.lightBlue)
            .withOpacity(1.0 - state.scrollPercentage),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'Header #1',
          style: const TextStyle(color: Colors.white),
        ),
      ),
  sliver: SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, i) => ListTile(
            leading: CircleAvatar(
              child: Text('0'),
            ),
            title: Text('List tile #$i'),
          ),
      childCount: 4,
    ),
  ),
);
```

## stickToEnd

By default, the header is displayed before its sliver and sticks to the start of the viewport. In a reversed list, the start is at the bottom, so the header is displayed at the bottom of its sliver.

With `stickToEnd: true`, the header is displayed after its sliver and sticks to the end of the viewport. In a reversed list, such as a chat, the header is then displayed at the top of its sliver and sticks to the top of the viewport:

```dart
CustomScrollView(
  reverse: true,
  slivers: [
    SliverStickyHeader(
      stickToEnd: true,
      header: DateHeader(),
      sliver: SliverList(...),
    ),
  ],
);
```

The same applies to the slivers before the `center` of a `CustomScrollView`, which grow upward. In a list which is not reversed, `stickToEnd: true` creates sticky footers.

Nesting a `SliverStickyHeader` with `stickToEnd: true` inside another one with `stickToEnd: true` is not supported: both headers would be pinned at the same place, the outer one hiding the inner one. Mixing both modes when nesting is supported.

## onStateChanged

If you want to be notified when the state of a header changes, for example to know which header is pinned, you can use the `onStateChanged` parameter, with both constructors. It is called after the frame, so you can call `setState` from it.

```dart
SliverStickyHeader(
  header: Header(),
  sliver: SliverList(...),
  onStateChanged: (state) {
    if (state.isPinned && state.scrollPercentage < 1) {
      setState(() => currentSection = index);
    }
  },
);
```

While a header is pushed out of the viewport by the end of its sliver, its scroll percentage changes, so `onStateChanged` is called on every frame.

You can find more examples in the [Example](https://github.com/letsar/flutter_sticky_header/tree/master/example) project.

## Sponsoring

I'm working on my packages on my free-time, but I don't have as much time as I would. If this package or any other package I created is helping you, please consider to sponsor me. By doing so, I will prioritize your issues or your pull-requests before the others. 

## Changelog

Please see the [Changelog](https://github.com/letsar/flutter_sticky_header/blob/master/CHANGELOG.md) page to know what's recently changed.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/letsar/flutter_sticky_header/issues).  
If you fixed a bug or implemented a new feature, please send a [pull request](https://github.com/letsar/flutter_sticky_header/pulls).

## Thanks

:clap: Thanks to [slightfoot](https://github.com/slightfoot) with it's RenderBox version (https://github.com/slightfoot/flutter_sticky_headers) which unintentionally challenged me to work in this RenderSliver version.
