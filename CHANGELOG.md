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
