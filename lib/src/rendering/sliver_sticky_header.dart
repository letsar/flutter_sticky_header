import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:value_layout_builder/value_layout_builder.dart';

/// A sliver with a [RenderBox] as header and a [RenderSliver] as child.
///
/// The [header] stays pinned when it hits the start of the viewport until
/// the [child] scrolls off the viewport.
class RenderSliverStickyHeader extends RenderSliver with RenderSliverHelpers {
  RenderSliverStickyHeader({
    RenderObject? header,
    RenderSliver? child,
    bool overlapsContent = false,
    bool sticky = true,
    StickyHeaderController? controller,
  })  : _overlapsContent = overlapsContent,
        _sticky = sticky,
        _controller = controller {
    this.header = header as RenderBox?;
    this.child = child;
  }

  /// The state the header was last laid out with.
  SliverStickyHeaderState? _lastHeaderState;
  double? _headerExtent;

  /// The position of the header along the main axis, from the leading edge of
  /// this sliver, in the growth direction.
  ///
  /// It is computed once during layout and used to paint and hit test the
  /// header.
  double _headerPosition = 0;

  bool get overlapsContent => _overlapsContent;
  bool _overlapsContent;

  set overlapsContent(bool value) {
    if (_overlapsContent == value) return;
    _overlapsContent = value;
    markNeedsLayout();
  }

  bool get sticky => _sticky;
  bool _sticky;

  set sticky(bool value) {
    if (_sticky == value) return;
    _sticky = value;
    markNeedsLayout();
  }

  StickyHeaderController? get controller => _controller;
  StickyHeaderController? _controller;

  set controller(StickyHeaderController? value) {
    if (_controller == value) return;
    if (_controller != null && value != null) {
      // We copy the state of the old controller.
      value.stickyHeaderScrollOffset = _controller!.stickyHeaderScrollOffset;
    }
    _controller = value;
  }

  /// The render object's header
  RenderBox? get header => _header;
  RenderBox? _header;

  set header(RenderBox? value) {
    if (_header != null) dropChild(_header!);
    _header = value;
    if (_header != null) adoptChild(_header!);
  }

  /// The render object's unique child
  RenderSliver? get child => _child;
  RenderSliver? _child;

  set child(RenderSliver? value) {
    if (_child != null) dropChild(_child!);
    _child = value;
    if (_child != null) adoptChild(_child!);
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData)
      child.parentData = SliverPhysicalParentData();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_header != null) _header!.attach(owner);
    if (_child != null) _child!.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    if (_header != null) _header!.detach();
    if (_child != null) _child!.detach();
  }

  @override
  void redepthChildren() {
    if (_header != null) redepthChild(_header!);
    if (_child != null) redepthChild(_child!);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_header != null) visitor(_header!);
    if (_child != null) visitor(_child!);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    List<DiagnosticsNode> result = <DiagnosticsNode>[];
    if (header != null) {
      result.add(header!.toDiagnosticsNode(name: 'header'));
    }
    if (child != null) {
      result.add(child!.toDiagnosticsNode(name: 'child'));
    }
    return result;
  }

  double computeHeaderExtent() {
    if (header == null) return 0.0;
    assert(header!.hasSize);
    switch (constraints.axis) {
      case Axis.vertical:
        return header!.size.height;
      case Axis.horizontal:
        return header!.size.width;
    }
  }

  double? get headerLogicalExtent => overlapsContent ? 0.0 : _headerExtent;

  @override
  void performLayout() {
    if (header == null && child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    if (!_layout()) {
      // The header changed its extent when it was laid out with its new state.
      // Lay out everything again with this state, only once to not loop if
      // the state keeps changing with the extent.
      _layout();
    }
  }

  /// Lays out the header and the child.
  ///
  /// Returns false if the header extent changed when it was laid out a second
  /// time with its new state, so that the geometry is outdated.
  bool _layout() {
    if (header != null) {
      _layoutHeader(_lastHeaderState ?? SliverStickyHeaderState(0.0, false));
      _headerExtent = computeHeaderExtent();
    }

    // The extent taken by the header in the scroll extent of this sliver.
    final double headerExtent = headerLogicalExtent!;
    final double headerPaintExtent =
        calculatePaintOffset(constraints, from: 0.0, to: headerExtent);
    final double headerCacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: headerExtent);

    if (child == null) {
      geometry = SliverGeometry(
          scrollExtent: headerExtent,
          maxPaintExtent: headerExtent,
          paintExtent: headerPaintExtent,
          cacheExtent: headerCacheExtent,
          hitTestExtent: headerPaintExtent,
          hasVisualOverflow: headerExtent > constraints.remainingPaintExtent ||
              constraints.scrollOffset > 0.0);
    } else {
      child!.layout(
        constraints.copyWith(
          scrollOffset: math.max(0.0, constraints.scrollOffset - headerExtent),
          cacheOrigin: math.min(0.0, constraints.cacheOrigin + headerExtent),
          overlap: math.min(headerExtent, constraints.scrollOffset) +
              (sticky ? constraints.overlap : 0),
          remainingPaintExtent:
              constraints.remainingPaintExtent - headerPaintExtent,
          remainingCacheExtent:
              constraints.remainingCacheExtent - headerCacheExtent,
        ),
        parentUsesSize: true,
      );
      final SliverGeometry childLayoutGeometry = child!.geometry!;
      if (childLayoutGeometry.scrollOffsetCorrection != null) {
        geometry = SliverGeometry(
          scrollOffsetCorrection: childLayoutGeometry.scrollOffsetCorrection,
        );
        return true;
      }

      final double paintExtent = math.min(
        headerPaintExtent +
            math.max(childLayoutGeometry.paintExtent,
                childLayoutGeometry.layoutExtent),
        constraints.remainingPaintExtent,
      );

      geometry = SliverGeometry(
        scrollExtent: headerExtent + childLayoutGeometry.scrollExtent,
        maxScrollObstructionExtent: sticky ? headerPaintExtent : 0,
        paintExtent: paintExtent,
        layoutExtent: math.min(
            headerPaintExtent + childLayoutGeometry.layoutExtent, paintExtent),
        cacheExtent: math.min(
            headerCacheExtent + childLayoutGeometry.cacheExtent,
            constraints.remainingCacheExtent),
        maxPaintExtent: headerExtent + childLayoutGeometry.maxPaintExtent,
        hitTestExtent: math.max(
            headerPaintExtent + childLayoutGeometry.paintExtent,
            headerPaintExtent + childLayoutGeometry.hitTestExtent),
        hasVisualOverflow: childLayoutGeometry.hasVisualOverflow,
      );

      _setChildPaintOffset(child!, childMainAxisPosition(child));
    }

    bool headerExtentChanged = false;
    if (header != null) {
      final double childScrollExtent = child?.geometry?.scrollExtent ?? 0.0;
      _headerPosition = sticky
          ? math.min(
              constraints.overlap,
              childScrollExtent -
                  constraints.scrollOffset -
                  (overlapsContent ? _headerExtent! : 0.0))
          : -constraints.scrollOffset;

      final bool isPinned = sticky &&
          ((constraints.scrollOffset + constraints.overlap) > 0.0 ||
              constraints.remainingPaintExtent ==
                  constraints.viewportMainAxisExtent);

      final double headerScrollRatio =
          ((_headerPosition - constraints.overlap).abs() / _headerExtent!);
      if (isPinned && headerScrollRatio <= 1) {
        controller?.stickyHeaderScrollOffset =
            constraints.precedingScrollExtent;
      }

      // Second layout if the state changed and the header depends on it.
      if (header is RenderAbstractLayoutBuilderMixin<
          BoxValueConstraints<SliverStickyHeaderState>, RenderBox>) {
        final SliverStickyHeaderState state = SliverStickyHeaderState(
          headerScrollRatio.clamp(0.0, 1.0),
          isPinned,
        );
        if (_lastHeaderState != state) {
          _layoutHeader(state);
          headerExtentChanged = computeHeaderExtent() != _headerExtent;
        }
      }

      _setChildPaintOffset(header!, childMainAxisPosition(header));
    }
    return !headerExtentChanged;
  }

  void _layoutHeader(SliverStickyHeaderState state) {
    _lastHeaderState = state;
    header!.layout(
      BoxValueConstraints<SliverStickyHeaderState>(
        value: state,
        constraints: constraints.asBoxConstraints(),
      ),
      parentUsesSize: true,
    );
  }

  /// Converts [mainAxisPosition], in the growth direction, to the physical
  /// paint offset of [renderObject].
  void _setChildPaintOffset(
      RenderObject renderObject, double mainAxisPosition) {
    final double paintExtent = renderObject is RenderBox
        ? (constraints.axis == Axis.vertical
            ? renderObject.size.height
            : renderObject.size.width)
        : (renderObject as RenderSliver).geometry!.paintExtent;
    final SliverPhysicalParentData parentData =
        renderObject.parentData as SliverPhysicalParentData;
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        parentData.paintOffset =
            Offset(0.0, geometry!.paintExtent - mainAxisPosition - paintExtent);
        break;
      case AxisDirection.down:
        parentData.paintOffset = Offset(0.0, mainAxisPosition);
        break;
      case AxisDirection.left:
        parentData.paintOffset =
            Offset(geometry!.paintExtent - mainAxisPosition - paintExtent, 0.0);
        break;
      case AxisDirection.right:
        parentData.paintOffset = Offset(mainAxisPosition, 0.0);
        break;
    }
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    assert(geometry!.hitTestExtent > 0.0);
    if (header != null &&
        mainAxisPosition >= _headerPosition &&
        mainAxisPosition - _headerPosition < _headerExtent!) {
      final didHitHeader = hitTestBoxChild(
        BoxHitTestResult.wrap(SliverHitTestResult.wrap(result)),
        header!,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition,
      );

      return didHitHeader ||
          (_overlapsContent &&
              _hitTestChild(result,
                  mainAxisPosition: mainAxisPosition,
                  crossAxisPosition: crossAxisPosition));
    }
    return _hitTestChild(result,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition);
  }

  bool _hitTestChild(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    return child != null &&
        child!.geometry!.hitTestExtent > 0.0 &&
        result.addWithAxisOffset(
          paintOffset:
              (child!.parentData as SliverPhysicalParentData).paintOffset,
          mainAxisOffset: childMainAxisPosition(child),
          crossAxisOffset: 0.0,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
          hitTest: child!.hitTest,
        );
  }

  @override
  double childMainAxisPosition(RenderObject? child) {
    if (child == header) return _headerPosition;
    if (child == this.child)
      return calculatePaintOffset(constraints,
          from: 0.0, to: headerLogicalExtent!);
    return 0;
  }

  @override
  double? childScrollOffset(RenderObject child) {
    assert(child.parent == this);
    if (child == this.child) {
      return headerLogicalExtent;
    } else {
      return super.childScrollOffset(child);
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    final SliverPhysicalParentData childParentData =
        child.parentData as SliverPhysicalParentData;
    childParentData.applyPaintTransform(transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (geometry!.visible) {
      if (child != null && child!.geometry!.visible) {
        final SliverPhysicalParentData childParentData =
            child!.parentData as SliverPhysicalParentData;
        context.paintChild(child!, offset + childParentData.paintOffset);
      }

      // The header must be drawn over the sliver.
      if (header != null) {
        final SliverPhysicalParentData headerParentData =
            header!.parentData as SliverPhysicalParentData;
        context.paintChild(header!, offset + headerParentData.paintOffset);
      }
    }
  }
}
