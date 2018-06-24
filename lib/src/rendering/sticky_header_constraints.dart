import 'package:flutter/rendering.dart';

/// Immutable layout constraints for sticky header
class StickyHeaderConstraints extends BoxConstraints {
  StickyHeaderConstraints({
    this.scrollPercentage,
    BoxConstraints boxConstraints,
  })  : assert(scrollPercentage != null),
        assert(boxConstraints != null),
        super(
          minWidth: boxConstraints.minWidth,
          maxWidth: boxConstraints.maxWidth,
          minHeight: boxConstraints.minHeight,
          maxHeight: boxConstraints.maxHeight,
        );

  final double scrollPercentage;

  @override
  bool get isNormalized =>
      scrollPercentage >= 0.0 && scrollPercentage <= 1.0 && super.isNormalized;

  @override
  bool operator ==(dynamic other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) return true;
    if (other is! StickyHeaderConstraints) return false;
    final StickyHeaderConstraints typedOther = other;
    assert(typedOther.debugAssertIsValid());
    return scrollPercentage == typedOther.scrollPercentage &&
        minWidth == typedOther.minWidth &&
        maxWidth == typedOther.maxWidth &&
        minHeight == typedOther.minHeight &&
        maxHeight == typedOther.maxHeight;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return hashValues(
        minWidth, maxWidth, minHeight, maxHeight, scrollPercentage);
  }
}
