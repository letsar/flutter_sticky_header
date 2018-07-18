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
