import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/src/rendering/sticky_header_constraints.dart';
import 'package:flutter_sticky_header/src/rendering/sticky_header_layout_builder.dart';

typedef Widget StickyHeaderLayoutWidgetBuilder(
    BuildContext context, StickyHeaderConstraints constraints);

/// Builds a widget tree that can depend on the [StickyHeaderConstraints].
///
/// This is used by [SliverStickyHeaderBuilder] to change the header layout
/// while it starts to scroll off the viewport.
class StickyHeaderLayoutBuilder extends RenderObjectWidget {
  /// Creates a widget that defers its building until layout.
  ///
  /// The [builder] argument must not be null.
  const StickyHeaderLayoutBuilder({
    Key key,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  /// Called at layout time to construct the widget tree. The builder must not
  /// return null.
  final StickyHeaderLayoutWidgetBuilder builder;

  @override
  RenderObjectElement createElement() =>
      new _StickyHeaderLayoutBuilderElement(this);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      new RenderStickyHeaderLayoutBuilder();

  // updateRenderObject is redundant with the logic in the _StickyHeaderLayoutBuilderElement below.
}

class _StickyHeaderLayoutBuilderElement extends RenderObjectElement {
  _StickyHeaderLayoutBuilderElement(StickyHeaderLayoutBuilder widget)
      : super(widget);

  @override
  StickyHeaderLayoutBuilder get widget => super.widget;

  @override
  RenderStickyHeaderLayoutBuilder get renderObject => super.renderObject;

  Element _child;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_child != null) visitor(_child);
  }

  @override
  void forgetChild(Element child) {
    assert(child == _child);
    _child = null;
  }

  @override
  void mount(Element parent, dynamic newSlot) {
    super.mount(parent, newSlot); // Creates the renderObject.
    renderObject.callback = _layout;
  }

  @override
  void update(StickyHeaderLayoutBuilder newWidget) {
    assert(widget != newWidget);
    super.update(newWidget);
    assert(widget == newWidget);
    renderObject.callback = _layout;
    renderObject.markNeedsLayout();
  }

  @override
  void performRebuild() {
    // This gets called if markNeedsBuild() is called on us.
    // That might happen if, e.g., our builder uses Inherited widgets.
    renderObject.markNeedsLayout();
    super
        .performRebuild(); // Calls widget.updateRenderObject (a no-op in this case).
  }

  @override
  void unmount() {
    renderObject.callback = null;
    super.unmount();
  }

  void _layout(StickyHeaderConstraints constraints) {
    owner.buildScope(this, () {
      Widget built;
      if (widget.builder != null) {
        try {
          built = widget.builder(this, constraints);
          debugWidgetBuilderValue(widget, built);
        } catch (e, stack) {
          built = ErrorWidget.builder(
              _debugReportException('building $widget', e, stack));
        }
      }
      try {
        _child = updateChild(_child, built, null);
        assert(_child != null);
      } catch (e, stack) {
        built = ErrorWidget.builder(
            _debugReportException('building $widget', e, stack));
        _child = updateChild(null, built, slot);
      }
    });
  }

  @override
  void insertChildRenderObject(RenderObject child, slot) {
    final RenderObjectWithChildMixin<RenderObject> renderObject =
        this.renderObject;
    assert(slot == null);
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveChildRenderObject(RenderObject child, slot) {
    assert(false);
  }

  @override
  void removeChildRenderObject(RenderObject child) {
    final RenderStickyHeaderLayoutBuilder renderObject = this.renderObject;
    assert(renderObject.child == child);
    renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}

FlutterErrorDetails _debugReportException(
  dynamic context,
  dynamic exception,
  StackTrace stack,
) {
  final FlutterErrorDetails details = new FlutterErrorDetails(
    exception: exception,
    stack: stack,
    library: 'flutter_sticky_header widgets library',
    context: ErrorDescription('context'),
  );
  FlutterError.reportError(details);
  return details;
}
