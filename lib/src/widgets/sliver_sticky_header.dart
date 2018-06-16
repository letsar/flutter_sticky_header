import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/src/rendering/sliver_sticky_header.dart';
import 'package:flutter_sticky_header/src/widgets/sliver_sticky_header_scroll_notifier.dart';

/// Signature used by [SliverStickyHeaderBuilder] to build the header
/// when the percentage of scroll of the header has changed.
typedef Widget SliverStickyHeaderWidgetBuilder(
    BuildContext context, double scrollPercentage);

/// A sliver that displays a header before its sliver.
/// The header scrolls off the viewport only when the sliver does.
///
/// Place this widget inside a [CustomScrollView] or similar.
class SliverStickyHeader extends RenderObjectWidget {
  /// Creates a sliver that displays the [header] before its [sliver], unless [overlapsContent] it's true.
  /// The [header] stays pinned when it hits the start of the viewport until
  /// the [sliver] scrolls off the viewport.
  ///
  /// The [overlapsContent] argument must not be null.
  SliverStickyHeader({
    Key key,
    this.header,
    this.sliver,
    this.overlapsContent: false,
    this.sliverStickyHeaderScrollNotifier,
  })  : assert(overlapsContent != null),
        super(key: key);

  /// The header to display before the sliver.
  final Widget header;

  /// The sliver to display after the header.
  final Widget sliver;

  /// Whether the header should be drawn on top of the sliver
  /// instead of before.
  final bool overlapsContent;

  /// The controller used to listen to the header's scroll percentage changes.
  ///
  /// Consider using the [SliverStickyHeaderBuilder] if you have to use this.
  final SliverStickyHeaderScrollNotifier sliverStickyHeaderScrollNotifier;

  @override
  RenderSliverStickyHeader createRenderObject(BuildContext context) {
    return new RenderSliverStickyHeader(
      overlapsContent: overlapsContent,
      sliverStickyHeaderScrollNotifier: sliverStickyHeaderScrollNotifier,
    );
  }

  @override
  SliverStickyHeaderRenderObjectElement createElement() =>
      new SliverStickyHeaderRenderObjectElement(this);

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverStickyHeader renderObject) {
    renderObject
      ..overlapsContent = overlapsContent
      ..sliverStickyHeaderScrollNotifier = sliverStickyHeaderScrollNotifier;
  }
}

/// A widget that builds a [SliverStickyHeader] and calls a [SliverStickyHeaderWidgetBuilder] when
/// the header scroll percentage changes.
///
/// This is useful if you want to change the header layout when it starts to scroll off the viewport.
class SliverStickyHeaderBuilder extends StatefulWidget {
  /// Creates a widget that builds the header of a [SliverStickyHeader]
  /// each time its scroll percentage changes.
  ///
  /// The [builder] and [overlapsContent] arguments must not be null.
  const SliverStickyHeaderBuilder({
    Key key,
    @required this.builder,
    this.sliver,
    this.overlapsContent: false,
  })  : assert(builder != null),
        assert(overlapsContent != null),
        super(key: key);

  /// Called to build the [SliverStickyHeader]'s header.
  ///
  /// This function is called when the [SliverStickyHeader]'s header
  /// scroll percentage changes.
  final SliverStickyHeaderWidgetBuilder builder;

  /// The sliver to display after the header.
  final Widget sliver;

  /// Whether the header should be drawn on top of the sliver
  /// instead of before.
  final bool overlapsContent;

  @override
  _SliverStickyHeaderBuilderState createState() =>
      new _SliverStickyHeaderBuilderState();
}

class _SliverStickyHeaderBuilderState extends State<SliverStickyHeaderBuilder> {
  double _scrollPercentage;
  SliverStickyHeaderScrollNotifier _sliverStickyHeaderScrollNotifier;

  @override
  void initState() {
    super.initState();
    _sliverStickyHeaderScrollNotifier = new SliverStickyHeaderScrollNotifier();
    _sliverStickyHeaderScrollNotifier.addListener(_scrollPercentageChanged);
  }

  void _scrollPercentageChanged() {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      setState(() => _scrollPercentage =
          _sliverStickyHeaderScrollNotifier.scrollPercentage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new SliverStickyHeader(
      overlapsContent: widget.overlapsContent,
      sliverStickyHeaderScrollNotifier: _sliverStickyHeaderScrollNotifier,
      sliver: widget.sliver,
      header: new LayoutBuilder(
        builder: (context, _) =>
            widget.builder(context, _scrollPercentage ?? 0.0),
      ),
    );
  }
}

class SliverStickyHeaderRenderObjectElement extends RenderObjectElement {
  /// Creates an element that uses the given widget as its configuration.
  SliverStickyHeaderRenderObjectElement(SliverStickyHeader widget)
      : super(widget);

  @override
  SliverStickyHeader get widget => super.widget;

  Element _header;

  Element _sliver;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_header != null) visitor(_header);
    if (_sliver != null) visitor(_sliver);
  }

  @override
  void forgetChild(Element child) {
    if (child == _header) _header = null;
    if (child == _sliver) _sliver = null;
  }

  @override
  void mount(Element parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _header = updateChild(_header, widget.header, 0);
    _sliver = updateChild(_sliver, widget.sliver, 1);
  }

  @override
  void update(SliverStickyHeader newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _header = updateChild(_header, widget.header, 0);
    _sliver = updateChild(_sliver, widget.sliver, 1);
  }

  @override
  void insertChildRenderObject(RenderObject child, int slot) {
    final RenderSliverStickyHeader renderObject = this.renderObject;
    if (slot == 0) renderObject.header = child;
    if (slot == 1) renderObject.child = child;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveChildRenderObject(RenderObject child, slot) {
    assert(false);
  }

  @override
  void removeChildRenderObject(RenderObject child) {
    final RenderSliverStickyHeader renderObject = this.renderObject;
    if (renderObject.header == child) renderObject.header = null;
    if (renderObject.child == child) renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}
