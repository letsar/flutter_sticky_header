import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/src/widgets/sliver_sticky_header.dart';

/// Immutable layout constraints for sticky header
class StickyHeaderConstraints extends BoxConstraints {
  StickyHeaderConstraints({
    this.state,
    BoxConstraints boxConstraints,
  })  : assert(state != null),
        assert(boxConstraints != null),
        super(
          minWidth: boxConstraints.minWidth,
          maxWidth: boxConstraints.maxWidth,
          minHeight: boxConstraints.minHeight,
          maxHeight: boxConstraints.maxHeight,
        );

  final SliverStickyHeaderState state;

  @override
  bool get isNormalized =>
      state.scrollPercentage >= 0.0 &&
      state.scrollPercentage <= 1.0 &&
      super.isNormalized;

  @override
  bool operator ==(dynamic other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) return true;
    if (other is! StickyHeaderConstraints) return false;
    final StickyHeaderConstraints typedOther = other;
    assert(typedOther.debugAssertIsValid());
    return state == typedOther.state &&
        minWidth == typedOther.minWidth &&
        maxWidth == typedOther.maxWidth &&
        minHeight == typedOther.minHeight &&
        maxHeight == typedOther.maxHeight;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return hashValues(minWidth, maxWidth, minHeight, maxHeight, state);
  }
}
