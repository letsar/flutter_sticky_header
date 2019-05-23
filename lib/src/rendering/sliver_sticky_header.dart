import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_sticky_header/src/rendering/sticky_header_constraints.dart';
import 'package:flutter_sticky_header/src/rendering/sticky_header_layout_builder.dart';

/// A sliver with a [RenderBox] as header and a [RenderSliver] as child.
///
/// The [header] stays pinned when it hits the start of the viewport until
/// the [child] scrolls off the viewport.
class RenderSliverStickyHeader extends RenderSliver with RenderSliverHelpers {
  RenderSliverStickyHeader({
    RenderObject header,
    RenderSliver child,
    overlapsContent: false,
  })  : assert(overlapsContent != null),
        _overlapsContent = overlapsContent {
    this.header = header;
    this.child = child;
  }

  SliverStickyHeaderState _oldState;
  double _headerExtent;
  bool _isPinned;

  bool get overlapsContent => _overlapsContent;
  bool _overlapsContent;
  set overlapsContent(bool value) {
    assert(value != null);
    if (_overlapsContent == value) return;
    _overlapsContent = value;
    markNeedsLayout();
  }

  /// The render object's header
  RenderBox get header => _header;
  RenderBox _header;
  set header(RenderBox value) {
    if (_header != null) dropChild(_header);
    _header = value;
    if (_header != null) adoptChild(_header);
  }

  /// The render object's unique child
  RenderSliver get child => _child;
  RenderSliver _child;
  set child(RenderSliver value) {
    if (_child != null) dropChild(_child);
    _child = value;
    if (_child != null) adoptChild(_child);
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData)
      child.parentData = new SliverPhysicalParentData();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_header != null) _header.attach(owner);
    if (_child != null) _child.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    if (_header != null) _header.detach();
    if (_child != null) _child.detach();
  }

  @override
  void redepthChildren() {
    if (_header != null) redepthChild(_header);
    if (_child != null) redepthChild(_child);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_header != null) visitor(_header);
    if (_child != null) visitor(_child);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    List<DiagnosticsNode> result = <DiagnosticsNode>[];
    if (header != null) {
      result.add(header.toDiagnosticsNode(name: 'header'));
    }
    if (child != null) {
      result.add(child.toDiagnosticsNode(name: 'child'));
    }
    return result;
  }

  double computeHeaderExtent() {
    if (header == null) return 0.0;
    assert(header.hasSize);
    assert(constraints.axis != null);
    switch (constraints.axis) {
      case Axis.vertical:
        return header.size.height;
      case Axis.horizontal:
        return header.size.width;
    }
    return null;
  }

  double get headerLogicalExtent => overlapsContent ? 0.0 : _headerExtent;

  @override
  void performLayout() {
    if (header == null && child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    // One of them is not null.
    AxisDirection axisDirection = applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection);

    if (header != null) {
      header.layout(
        new StickyHeaderConstraints(
          state: _oldState ?? new SliverStickyHeaderState(0.0, false),
          boxConstraints: constraints.asBoxConstraints(),
        ),
        parentUsesSize: true,
      );
      _headerExtent = computeHeaderExtent();
    }

    // Compute the header extent only one time.
    double headerExtent = headerLogicalExtent;
    final double headerPaintExtent =
        calculatePaintOffset(constraints, from: 0.0, to: headerExtent);
    final double headerCacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: headerExtent);

    if (child == null) {
      geometry = new SliverGeometry(
          scrollExtent: headerExtent,
          maxPaintExtent: headerExtent,
          paintExtent: headerPaintExtent,
          cacheExtent: headerCacheExtent,
          hitTestExtent: headerPaintExtent,
          hasVisualOverflow: headerExtent > constraints.remainingPaintExtent ||
              constraints.scrollOffset > 0.0);
    } else {
      child.layout(
        constraints.copyWith(
          scrollOffset: math.max(0.0, constraints.scrollOffset - headerExtent),
          cacheOrigin: math.min(0.0, constraints.cacheOrigin + headerExtent),
          overlap: 0.0,
          remainingPaintExtent:
              constraints.remainingPaintExtent - headerPaintExtent,
          remainingCacheExtent:
              constraints.remainingCacheExtent - headerCacheExtent,
        ),
        parentUsesSize: true,
      );
      final SliverGeometry childLayoutGeometry = child.geometry;
      if (childLayoutGeometry.scrollOffsetCorrection != null) {
        geometry = new SliverGeometry(
          scrollOffsetCorrection: childLayoutGeometry.scrollOffsetCorrection,
        );
        return;
      }

      final double paintExtent = math.min(
          headerPaintExtent +
              math.max(childLayoutGeometry.paintExtent,
                  childLayoutGeometry.layoutExtent),
          constraints.remainingPaintExtent);

      geometry = new SliverGeometry(
        scrollExtent: headerExtent + childLayoutGeometry.scrollExtent,
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

      final SliverPhysicalParentData childParentData = child.parentData;
      assert(constraints.axisDirection != null);
      assert(constraints.growthDirection != null);
      switch (axisDirection) {
        case AxisDirection.up:
          childParentData.paintOffset = Offset.zero;
          break;
        case AxisDirection.right:
          childParentData.paintOffset = new Offset(
              calculatePaintOffset(constraints, from: 0.0, to: headerExtent),
              0.0);
          break;
        case AxisDirection.down:
          childParentData.paintOffset = new Offset(0.0,
              calculatePaintOffset(constraints, from: 0.0, to: headerExtent));
          break;
        case AxisDirection.left:
          childParentData.paintOffset = Offset.zero;
          break;
      }
    }

    if (header != null) {
      final SliverPhysicalParentData headerParentData = header.parentData;
      final childScrollExtent = child?.geometry?.scrollExtent ?? 0.0;
      double headerPosition = math.min(
          constraints.overlap,
          childScrollExtent -
              constraints.scrollOffset -
              (overlapsContent ? _headerExtent : 0.0));

      _isPinned = (constraints.scrollOffset + constraints.overlap) > 0.0 ||
          constraints.remainingPaintExtent ==
              constraints.viewportMainAxisExtent;
      // second layout if scroll percentage changed and header is a RenderStickyHeaderLayoutBuilder.
      if (header is RenderStickyHeaderLayoutBuilder) {
        double scrollPercentage =
            ((headerPosition - constraints.overlap).abs() / _headerExtent)
                .clamp(0.0, 1.0);

        SliverStickyHeaderState state =
            new SliverStickyHeaderState(scrollPercentage, _isPinned);
        if (_oldState != state) {
          _oldState = state;
          header.layout(
            new StickyHeaderConstraints(
              state: _oldState,
              boxConstraints: constraints.asBoxConstraints(),
            ),
            parentUsesSize: true,
          );
        }
      }

      switch (axisDirection) {
        case AxisDirection.up:
          headerParentData.paintOffset = new Offset(
              0.0, geometry.paintExtent - headerPosition - _headerExtent);
          break;
        case AxisDirection.down:
          headerParentData.paintOffset = new Offset(0.0, headerPosition);
          break;
        case AxisDirection.left:
          headerParentData.paintOffset = new Offset(
              geometry.paintExtent - headerPosition - _headerExtent, 0.0);
          break;
        case AxisDirection.right:
          headerParentData.paintOffset = new Offset(headerPosition, 0.0);
          break;
      }
    }
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {@required double mainAxisPosition, @required double crossAxisPosition}) {
    assert(geometry.hitTestExtent > 0.0);
    if (header != null &&
        mainAxisPosition - constraints.overlap <= _headerExtent) {
      return hitTestBoxChild(
              BoxHitTestResult.wrap(SliverHitTestResult.wrap(result)), header,
              mainAxisPosition: mainAxisPosition - constraints.overlap,
              crossAxisPosition: crossAxisPosition) ||
          (_overlapsContent &&
              child != null &&
              child.geometry.hitTestExtent > 0.0 &&
              child.hitTest(result,
                  mainAxisPosition:
                      mainAxisPosition - childMainAxisPosition(child),
                  crossAxisPosition: crossAxisPosition));
    } else if (child != null && child.geometry.hitTestExtent > 0.0) {
      return child.hitTest(result,
          mainAxisPosition: mainAxisPosition - childMainAxisPosition(child),
          crossAxisPosition: crossAxisPosition);
    }
    return false;
  }

  @override
  double childMainAxisPosition(RenderObject child) {
    if (child == header)
      return _isPinned
          ? 0.0
          : -(constraints.scrollOffset + constraints.overlap);
    if (child == this.child)
      return calculatePaintOffset(constraints,
          from: 0.0, to: headerLogicalExtent);
    return null;
  }

  @override
  double childScrollOffset(RenderObject child) {
    assert(child.parent == this);
    if (child == this.child) {
      return _headerExtent;
    } else {
      return super.childScrollOffset(child);
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    assert(child != null);
    final SliverPhysicalParentData childParentData = child.parentData;
    childParentData.applyPaintTransform(transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (geometry.visible) {
      if (child != null && child.geometry.visible) {
        final SliverPhysicalParentData childParentData = child.parentData;
        context.paintChild(child, offset + childParentData.paintOffset);
      }

      // The header must be draw over the sliver.
      if (header != null) {
        final SliverPhysicalParentData headerParentData = header.parentData;
        context.paintChild(header, offset + headerParentData.paintOffset);
      }
    }
  }
}
