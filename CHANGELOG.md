## 0.10.0
### Added
* `onStateChanged` parameter on `SliverStickyHeader` and `SliverStickyHeader.builder`, called after a frame when the `SliverStickyHeaderState` of the header changes (https://github.com/letsar/flutter_sticky_header/pull/120).

### Changed
* The package no longer depends on the material library, only on the widgets library (https://github.com/letsar/flutter_sticky_header/pull/119).

### Fixed
* The header now follows its sliver when the viewport is overscrolled at the start, instead of staying at the start of the viewport and leaving a gap above the content (https://github.com/letsar/flutter_sticky_header/pull/121). As a consequence, a header below a pinned `SliverAppBar` now moves away from the app bar during this overscroll, like the content does.

## 0.9.0
### Fixed
* Hit testing of headers. Taps now reach:
  * a scrolled not sticky header;
  * a not sticky header below a pinned sliver, such as a pinned `SliverAppBar`;
  * the content painted above a header pinned below a sliver which doesn't absorb taps;
  * the content on the first pixel after a header.
* The `localPosition` received by a header pushed by the end of its section, or pinned below another pinned sliver.
* The `localPosition` received by the content, which was shifted by the header extent. If you compensated for this offset in your code, remove the compensation.
* `Scrollable.ensureVisible` when the header overlaps the content (https://github.com/letsar/flutter_sticky_header/pull/60).
* Headers built with `SliverStickyHeader.builder` whose extent depends on their state: the content no longer keeps the previous extent until the next layout.

### Added
* An example with a header smaller when pinned.
* A section in the README about `SliverMainAxisGroup`.

## 0.8.0
### Changed
* Update Flutter constraints.
* Update version of value_layout_builder.
  
### Fixed
* Flutter 3.32 breaking changes issue.

## 0.7.0
### Changed
* Update Flutter and Dart SDK constraints.
* Update usage of hashValues (https://github.com/letsar/flutter_sticky_header/pull/100)
* Update version of value_layout_builder.

## 0.6.5
### Fixed
* Tap offset when overlaps is > 0.

## 0.6.4
### Fixed
* Not passing right overlap contraints to sliver child. Now we can create nested sticky headers!

## 0.6.3
### Fixed
* Hit Test on not sticky header

## 0.6.2
### Fixed
* Hit Test on not sticky header

## 0.6.1
### Fixed
* Error due to null-safety migration.

## 0.6.0
### Changed
* Migrated to sound null-safety.
* Increase the minimum version of Flutter.
* Increase the minimum version of Dart SDK.

## 0.5.0
### Changed
* The minimum version of Flutter.

## 0.4.6
### Added
* A new SliverStickyHeader.builder constructor instead of the deprecated SliverStickyHeaderBuilder.
* A dependency to value_layout_builder in order to manage the SliverStickyHeader.builder.

### Removed
* Custom code to make SliverStickyHeader.builder work.

## 0.4.5
### Fixed
* Null references issues in debug mode.

## 0.4.4
### Fixed
* Static analysis issues.

## 0.4.3
### Fixed
* Static analysis issues.

## 0.4.2
### Added
* A StickyHeaderController to get the scroll offset of the current sticky header.

## 0.4.1
### Added
* A sticky parameter to specify whether the header is sticky or not.

## 0.4.0

* Updated SDK constraint to support new error message formats. 
* Updated error message formats

## 0.3.4
### Removed
* Print call for headerPosition

## 0.3.3
### Added
* Overlap support

## 0.3.2
### Added
* Dart 2 support

## 0.3.1
### Fixed
* Hit test implementation (https://github.com/letsar/flutter_sticky_header/issues/7)

## 0.3.0
### Added
* `SliverStickyHeaderState` class. This state has `scrollPercentage` and `isPinned` properties and it's passed to the `SliverStickyHeaderBuilder` when it changes.

### Changed
* The second parameter for `SliverStickyHeaderWidgetBuilder` takes now a `SliverStickyHeaderState` instead of a double.

## 0.2.0
### Removed
* `sliverStickyHeaderScrollNotifier` argument in `SliverStickyHeader` constructor.

### Changed
* Rewrite how to notify the scroll percentage, so that the it does not lag by one frame.

## 0.1.0
* Initial Open Source release.
