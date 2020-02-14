import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/src/rendering/sticky_header_constraints.dart';

class RenderStickyHeaderLayoutBuilder extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  RenderStickyHeaderLayoutBuilder({
    LayoutCallback<StickyHeaderConstraints> callback,
  }) : _callback = callback;

  LayoutCallback<StickyHeaderConstraints> get callback => _callback;
  LayoutCallback<StickyHeaderConstraints> _callback;
  set callback(LayoutCallback<StickyHeaderConstraints> value) {
    if (value == _callback) return;
    _callback = value;
    markNeedsLayout();
  }

  // layout input
  @override
  StickyHeaderConstraints get constraints => super.constraints;

  bool _debugThrowIfNotCheckingIntrinsics() {
    assert(() {
      if (!RenderObject.debugCheckingIntrinsics) {
        throw FlutterError('StickyHeaderLayoutBuilder does not support returning intrinsic dimensions.\n'
            'Calculating the intrinsic dimensions would require running the layout '
            'callback speculatively, which might mutate the live render object tree.');
      }
      return true;
    }());
    return true;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  void performLayout() {
    assert(callback != null);
    invokeLayoutCallback(callback);
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child.size);
    } else {
      size = constraints.biggest;
    }
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) {
    return child?.hitTest(result, position: position) ?? false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) context.paintChild(child, offset);
  }
}
