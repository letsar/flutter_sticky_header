import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:value_layout_builder/value_layout_builder.dart';

/// A sliver with a [RenderBox] as header and a [RenderSliver] as child.
///
/// The [header] stays pinned when it hits the start of the viewport until
/// the [children] scrolls off the viewport.
class RenderSliverStickyHeader extends RenderSliver with RenderSliverHelpers {
  RenderSliverStickyHeader({
    RenderObject? header,
    List<RenderSliver?> children = const [],
    bool overlapsContent: false,
    bool sticky: true,
    StickyHeaderController? controller,
  })  : _overlapsContent = overlapsContent,
        _sticky = sticky,
        _controller = controller {
    this.header = header as RenderBox?;
    this.children = children;
  }

  SliverStickyHeaderState? _oldState;
  double? _headerExtent;
  late bool _isPinned;

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

  /// The render object's children
  List<RenderSliver?> get children => _children;
  List<RenderSliver?> _children = [];

  set children(List<RenderSliver?> value) {
    _children.forEach((c) {
      if (c != null) dropChild(c);
    });
    _children = value;
    _children.forEach((c) {
      if (c != null) adoptChild(c);
    });
  }

  void removeChild(int i) {
    assert(children.length > i);

    var child = children[i];
    if (child == null) return;
    dropChild(child);
    children[i] = null;
  }

  void addChild(int i, RenderSliver? newChild) {
    assert(children.length > i);

    var child = children[i];
    if (child != null) dropChild(child);
    children[i] = newChild;
    if (newChild != null) adoptChild(newChild);
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
    _children.forEach((c) => c?.attach(owner));
  }

  @override
  void detach() {
    super.detach();
    if (_header != null) _header!.detach();
    _children.forEach((c) => c?.detach());
  }

  @override
  void redepthChildren() {
    if (_header != null) redepthChild(_header!);
    _children.forEach((c) {
      if (c != null) redepthChild(c);
    });
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_header != null) visitor(_header!);
    _children.forEach((c) {
      if (c != null) visitor(c);
    });
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    List<DiagnosticsNode> result = <DiagnosticsNode>[];
    if (header != null) {
      result.add(header!.toDiagnosticsNode(name: 'header'));
    }

    var i = 0;
    for (var c in children) {
      if (c != null) result.add(c.toDiagnosticsNode(name: 'child$i'));
      i++;
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

  bool get noRenderChilds =>
      children.isEmpty || !children.any((c) => c != null);

  @override
  void performLayout() {
    if (header == null && noRenderChilds) {
      geometry = SliverGeometry.zero;
      return;
    }

    // One of them is not null.
    AxisDirection axisDirection = applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection);

    if (header != null) {
      header!.layout(
        BoxValueConstraints<SliverStickyHeaderState>(
          value: _oldState ?? SliverStickyHeaderState(0.0, false),
          constraints: constraints.asBoxConstraints(),
        ),
        parentUsesSize: true,
      );
      _headerExtent = computeHeaderExtent();
    }

    // Compute the header extent only one time.
    double headerExtent = headerLogicalExtent!;
    final double headerPaintExtent =
        calculatePaintOffset(constraints, from: 0.0, to: headerExtent);
    final double headerCacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: headerExtent);

    if (noRenderChilds) {
      geometry = SliverGeometry(
          scrollExtent: headerExtent,
          maxPaintExtent: headerExtent,
          paintExtent: headerPaintExtent,
          cacheExtent: headerCacheExtent,
          hitTestExtent: headerPaintExtent,
          hasVisualOverflow: headerExtent > constraints.remainingPaintExtent ||
              constraints.scrollOffset > 0.0);
    } else {
      List<SliverGeometry> geometries = [];

      for (var child in children) {
        var prev = geometries.length > 0
            ? geometries
                .map((g) => g.maxPaintExtent)
                .reduce((d1, d2) => d1 + d2)
            : 0;
        if (child != null) {
          child.layout(
            constraints.copyWith(
              scrollOffset: math.max(
                0.0,
                constraints.scrollOffset - headerExtent - prev,
              ),
              cacheOrigin: math.min(
                0.0,
                constraints.cacheOrigin + headerExtent + prev,
              ),
              overlap: math.min(
                math.max(
                  0.0,
                  constraints.scrollOffset - prev,
                ),
                headerExtent,
              ),
              remainingPaintExtent: math.max(
                0.0,
                constraints.remainingPaintExtent - headerPaintExtent,
              ),
              remainingCacheExtent: math.max(
                0.0,
                constraints.remainingCacheExtent - headerCacheExtent,
              ),
            ),
            parentUsesSize: true,
          );

          final SliverGeometry childLayoutGeometry = child.geometry!;
          if (childLayoutGeometry.scrollOffsetCorrection != null) {
            geometry = SliverGeometry(
              scrollOffsetCorrection:
                  childLayoutGeometry.scrollOffsetCorrection,
            );
            return;
          }
          geometries.add(childLayoutGeometry);
        }
      }

      final double childPaintExtent =
          geometries.map((c) => c.paintExtent).reduce((d1, d2) => d1 + d2);
      final double childLayoutExtent =
          geometries.map((c) => c.layoutExtent).reduce((d1, d2) => d1 + d2);
      final double childScrollExtent =
          geometries.map((c) => c.scrollExtent).reduce((d1, d2) => d1 + d2);
      final double childCacheExtent =
          geometries.map((c) => c.cacheExtent).reduce((d1, d2) => d1 + d2);
      final double childMaxPaintExtent =
          geometries.map((c) => c.maxPaintExtent).reduce((d1, d2) => d1 + d2);
      final double childHitTestExtent =
          geometries.map((c) => c.hitTestExtent).reduce((d1, d2) => d1 + d2);
      final bool childHasVisualOverflow =
          geometries.any((c) => c.hasVisualOverflow);

      final double paintExtent = math.min(
        headerPaintExtent +
            math.max(
              childPaintExtent,
              childLayoutExtent,
            ),
        constraints.remainingPaintExtent,
      );

      geometry = SliverGeometry(
        scrollExtent: headerExtent + childScrollExtent,
        paintExtent: paintExtent,
        layoutExtent:
            math.min(headerPaintExtent + childLayoutExtent, paintExtent),
        cacheExtent: math.min(headerCacheExtent + childCacheExtent,
            constraints.remainingCacheExtent),
        maxPaintExtent: headerExtent + childMaxPaintExtent,
        hitTestExtent: math.max(headerPaintExtent + childPaintExtent,
            headerPaintExtent + childHitTestExtent),
        hasVisualOverflow: childHasVisualOverflow,
      );

      double i = headerExtent;
      for (var child in children) {
        final SliverPhysicalParentData? childParentData =
            child?.parentData as SliverPhysicalParentData?;

        switch (axisDirection) {
          case AxisDirection.right:
            childParentData!.paintOffset = Offset(
                calculatePaintOffset(constraints, from: 0.0, to: i), 0.0);
            break;
          case AxisDirection.down:
            childParentData!.paintOffset = Offset(
                0.0, calculatePaintOffset(constraints, from: 0.0, to: i));
            break;
          case AxisDirection.up:
          case AxisDirection.left:
            childParentData!.paintOffset = Offset.zero;
            break;
        }
        i += child?.geometry?.maxPaintExtent ?? 0;
      }
    }

    if (header != null) {
      final SliverPhysicalParentData? headerParentData =
          header!.parentData as SliverPhysicalParentData?;
      final double childScrollExtent = noRenderChilds
          ? constraints.overlap
          : children
              .map((c) => c?.geometry?.scrollExtent ?? 0.0)
              .reduce((d1, d2) => d1 + d2);
      double headerPosition = sticky
          ? math.min(
              constraints.overlap,
              childScrollExtent -
                  constraints.scrollOffset -
                  (overlapsContent ? _headerExtent! : 0.0))
          : -constraints.scrollOffset;

      _isPinned = sticky &&
          ((constraints.scrollOffset + constraints.overlap) > 0.0 ||
              constraints.remainingPaintExtent ==
                  constraints.viewportMainAxisExtent);

      final double headerScrollRatio =
          ((headerPosition - constraints.overlap).abs() / _headerExtent!);
      if (_isPinned && headerScrollRatio <= 1) {
        controller?.stickyHeaderScrollOffset =
            constraints.precedingScrollExtent;
      }

      // second layout if scroll percentage changed and header is a
      // RenderStickyHeaderLayoutBuilder.
      if (header is RenderConstrainedLayoutBuilder<
          BoxValueConstraints<SliverStickyHeaderState>, RenderBox>) {
        double headerScrollRatioClamped = headerScrollRatio.clamp(0.0, 1.0);

        SliverStickyHeaderState state =
            SliverStickyHeaderState(headerScrollRatioClamped, _isPinned);
        if (_oldState != state) {
          _oldState = state;
          header!.layout(
            BoxValueConstraints<SliverStickyHeaderState>(
              value: _oldState ?? SliverStickyHeaderState(0.0, false),
              constraints: constraints.asBoxConstraints(),
            ),
            parentUsesSize: true,
          );
        }
      }

      switch (axisDirection) {
        case AxisDirection.up:
          headerParentData!.paintOffset = Offset(
              0.0, geometry!.paintExtent - headerPosition - _headerExtent!);
          break;
        case AxisDirection.down:
          headerParentData!.paintOffset = Offset(0.0, headerPosition);
          break;
        case AxisDirection.left:
          headerParentData!.paintOffset = Offset(
              geometry!.paintExtent - headerPosition - _headerExtent!, 0.0);
          break;
        case AxisDirection.right:
          headerParentData!.paintOffset = Offset(headerPosition, 0.0);
          break;
      }
    }
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    assert(geometry!.hitTestExtent > 0.0);
    if (header != null &&
        mainAxisPosition - constraints.overlap <= _headerExtent!) {
      var hitTestHeader = hitTestBoxChild(
        BoxHitTestResult.wrap(SliverHitTestResult.wrap(result)),
        header!,
        mainAxisPosition: mainAxisPosition - constraints.overlap,
        crossAxisPosition: crossAxisPosition,
      );

      if (hitTestHeader) return true;
      if (!(_overlapsContent && !noRenderChilds)) return false;
    }

    if (children.any((c) => (c?.geometry?.hitTestExtent ?? 0.0) > 0.0)) {
      return children.any((c) =>
          c?.hitTest(result,
              mainAxisPosition: mainAxisPosition - childMainAxisPosition(c),
              crossAxisPosition: crossAxisPosition) ??
          false);
    }
    return false;
  }

  @override
  double childMainAxisPosition(RenderObject? child) {
    if (child == header)
      return _isPinned
          ? 0.0
          : -(constraints.scrollOffset + constraints.overlap);
    if (children.contains(child))
      return calculatePaintOffset(constraints,
          from: 0.0, to: headerLogicalExtent!);
    return 0;
  }

  @override
  double? childScrollOffset(RenderObject child) {
    assert(child.parent == this);
    if (this.children.contains(child)) {
      return _headerExtent;
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
      Offset prev = offset;
      for (var child in children) {
        if (child != null && child.geometry!.visible) {
          final SliverPhysicalParentData childParentData =
              child.parentData as SliverPhysicalParentData;

          context.paintChild(child, prev + childParentData.paintOffset);
        }
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
