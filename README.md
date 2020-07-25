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

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  flutter_sticky_header: "^0.4.5"
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

## SliverStickyHeaderBuilder

If you want to change the header layout during its scroll, you can use the `SliverStickyHeaderBuilder`.

The example belows changes the opacity of the header as it scrolls off the viewport.

```dart
SliverStickyHeaderBuilder(
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

You can find more examples in the [Example](https://github.com/letsar/flutter_sticky_header/tree/master/example) project.

## Changelog

Please see the [Changelog](https://github.com/letsar/flutter_sticky_header/blob/master/CHANGELOG.md) page to know what's recently changed.

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/letsar/flutter_sticky_header/issues).  
If you fixed a bug or implemented a new feature, please send a [pull request](https://github.com/letsar/flutter_sticky_header/pulls).

## Thanks

:clap: Thanks to [slightfoot](https://github.com/slightfoot) with it's RenderBox version (https://github.com/slightfoot/flutter_sticky_headers) which unintentionally challenged me to work in this RenderSliver version.
