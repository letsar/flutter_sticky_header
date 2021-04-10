import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/src/rendering/sliver_sticky_header.dart';
import 'package:value_layout_builder/value_layout_builder.dart';

/// Signature used by [SliverStickyHeader.builder] to build the header
/// when the sticky header state has changed.
typedef Widget SliverStickyHeaderWidgetBuilder(
  BuildContext context,
  SliverStickyHeaderState state,
);

/// A
class StickyHeaderController with ChangeNotifier {
  /// The offset to use in order to jump to the first item
  /// of current the sticky header.
  ///
  /// If there is no sticky headers, this is 0.
  double get stickyHeaderScrollOffset => _stickyHeaderScrollOffset;
  double _stickyHeaderScrollOffset = 0;

  /// This setter should only be used by flutter_sticky_header package.
  set stickyHeaderScrollOffset(double value) {
    if (_stickyHeaderScrollOffset != value) {
      _stickyHeaderScrollOffset = value;
      notifyListeners();
    }
  }
}

/// The [StickyHeaderController] for descendant widgets that don't specify one
/// explicitly.
///
/// [DefaultStickyHeaderController] is an inherited widget that is used to share a
/// [StickyHeaderController] with [SliverStickyHeader]s. It's used when sharing an
/// explicitly created [StickyHeaderController] isn't convenient because the sticky
/// headers are created by a stateless parent widget or by different parent
/// widgets.
class DefaultStickyHeaderController extends StatefulWidget {
  const DefaultStickyHeaderController({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Scaffold] whose [AppBar] includes a [TabBar].
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// The closest instance of this class that encloses the given context.
  ///
  /// Typical usage:
  ///
  /// ```dart
  /// StickyHeaderController controller = DefaultStickyHeaderController.of(context);
  /// ```
  static StickyHeaderController? of(BuildContext context) {
    final _StickyHeaderControllerScope? scope = context
        .dependOnInheritedWidgetOfExactType<_StickyHeaderControllerScope>();
    return scope?.controller;
  }

  @override
  _DefaultStickyHeaderControllerState createState() =>
      _DefaultStickyHeaderControllerState();
}

class _DefaultStickyHeaderControllerState
    extends State<DefaultStickyHeaderController> {
  StickyHeaderController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = StickyHeaderController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StickyHeaderControllerScope(
      controller: _controller,
      child: widget.child,
    );
  }
}

class _StickyHeaderControllerScope extends InheritedWidget {
  const _StickyHeaderControllerScope({
    Key? key,
    this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  final StickyHeaderController? controller;

  @override
  bool updateShouldNotify(_StickyHeaderControllerScope old) {
    return controller != old.controller;
  }
}

/// State describing how a sticky header is rendered.
@immutable
class SliverStickyHeaderState {
  const SliverStickyHeaderState(
    this.scrollPercentage,
    this.isPinned,
  );

  final double scrollPercentage;

  final bool isPinned;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! SliverStickyHeaderState) return false;
    final SliverStickyHeaderState typedOther = other;
    return scrollPercentage == typedOther.scrollPercentage &&
        isPinned == typedOther.isPinned;
  }

  @override
  int get hashCode {
    return hashValues(scrollPercentage, isPinned);
  }
}

/// A sliver that displays a header before its sliver.
/// The header scrolls off the viewport only when the sliver does.
///
/// Place this widget inside a [CustomScrollView] or similar.
class SliverStickyHeader extends RenderObjectWidget {
  /// Creates a sliver that displays the [header] before its [sliver], unless
  /// [overlapsContent] it's true.
  /// The [header] stays pinned when it hits the start of the viewport until
  /// the [sliver] scrolls off the viewport.
  ///
  /// The [overlapsContent] and [sticky] arguments must not be null.
  ///
  /// If a [StickyHeaderController] is not provided, then the value of
  /// [DefaultStickyHeaderController.of] will be used.
  SliverStickyHeader({
    Key? key,
    this.header,
    this.sliver,
    this.overlapsContent: false,
    this.sticky = true,
    this.controller,
  }) : super(key: key);

  /// Creates a widget that builds the header of a [SliverStickyHeader]
  /// each time its scroll percentage changes.
  ///
  /// The [builder], [overlapsContent] and [sticky] arguments must not be null.
  ///
  /// If a [StickyHeaderController] is not provided, then the value of
  /// [DefaultStickyHeaderController.of] will be used.
  SliverStickyHeader.builder({
    Key? key,
    required SliverStickyHeaderWidgetBuilder builder,
    Widget? sliver,
    bool overlapsContent: false,
    bool sticky = true,
    StickyHeaderController? controller,
  }) : this(
          key: key,
          header: ValueLayoutBuilder<SliverStickyHeaderState>(
            builder: (context, constraints) =>
                builder(context, constraints.value),
          ),
          sliver: sliver,
          overlapsContent: overlapsContent,
          sticky: sticky,
          controller: controller,
        );

  /// The header to display before the sliver.
  final Widget? header;

  /// The sliver to display after the header.
  final Widget? sliver;

  /// Whether the header should be drawn on top of the sliver
  /// instead of before.
  final bool overlapsContent;

  /// Whether to stick the header.
  /// Defaults to true.
  final bool sticky;

  /// The controller used to interact with this sliver.
  ///
  /// If a [StickyHeaderController] is not provided, then the value of [DefaultStickyHeaderController.of]
  /// will be used.
  final StickyHeaderController? controller;

  @override
  RenderSliverStickyHeader createRenderObject(BuildContext context) {
    return RenderSliverStickyHeader(
      overlapsContent: overlapsContent,
      sticky: sticky,
      controller: controller ?? DefaultStickyHeaderController.of(context),
    );
  }

  @override
  SliverStickyHeaderRenderObjectElement createElement() =>
      SliverStickyHeaderRenderObjectElement(this);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverStickyHeader renderObject,
  ) {
    renderObject
      ..overlapsContent = overlapsContent
      ..sticky = sticky
      ..controller = controller ?? DefaultStickyHeaderController.of(context);
  }
}

/// A widget that builds a [SliverStickyHeader] and calls a [SliverStickyHeaderWidgetBuilder] when
/// the header scroll percentage changes.
///
/// This is useful if you want to change the header layout when it starts to scroll off the viewport.
/// You cannot change the main axis extent of the header in this builder otherwise it could result
/// in strange behavior.
@Deprecated('Use SliverStickyHeader.builder instead.')
class SliverStickyHeaderBuilder extends StatelessWidget {
  /// Creates a widget that builds the header of a [SliverStickyHeader]
  /// each time its scroll percentage changes.
  ///
  /// The [builder], [overlapsContent] and [sticky] arguments must not be null.
  ///
  /// If a [StickyHeaderController] is not provided, then the value of [DefaultStickyHeaderController.of]
  /// will be used.
  const SliverStickyHeaderBuilder({
    Key? key,
    required this.builder,
    this.sliver,
    this.overlapsContent: false,
    this.sticky = true,
    this.controller,
  }) : super(key: key);

  /// Called to build the [SliverStickyHeader]'s header.
  ///
  /// This function is called when the [SliverStickyHeader]'s header
  /// scroll percentage changes.
  final SliverStickyHeaderWidgetBuilder builder;

  /// The sliver to display after the header.
  final Widget? sliver;

  /// Whether the header should be drawn on top of the sliver
  /// instead of before.
  final bool overlapsContent;

  /// Whether to stick the header.
  /// Defaults to true.
  final bool sticky;

  /// The controller used to interact with this sliver.
  ///
  /// If a [StickyHeaderController] is not provided, then the value of [DefaultStickyHeaderController.of]
  /// will be used.
  final StickyHeaderController? controller;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      overlapsContent: overlapsContent,
      sliver: sliver,
      sticky: sticky,
      controller: controller,
      header: ValueLayoutBuilder<SliverStickyHeaderState>(
        builder: (context, constraints) => builder(context, constraints.value),
      ),
    );
  }
}

class SliverStickyHeaderRenderObjectElement extends RenderObjectElement {
  /// Creates an element that uses the given widget as its configuration.
  SliverStickyHeaderRenderObjectElement(SliverStickyHeader widget)
      : super(widget);

  @override
  SliverStickyHeader get widget => super.widget as SliverStickyHeader;

  Element? _header;

  Element? _sliver;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_header != null) visitor(_header!);
    if (_sliver != null) visitor(_sliver!);
  }

  @override
  void forgetChild(Element child) {
    super.forgetChild(child);
    if (child == _header) _header = null;
    if (child == _sliver) _sliver = null;
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
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
  void insertRenderObjectChild(RenderObject child, int? slot) {
    final RenderSliverStickyHeader renderObject =
        this.renderObject as RenderSliverStickyHeader;
    if (slot == 0) renderObject.header = child as RenderBox?;
    if (slot == 1) renderObject.child = child as RenderSliver?;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(RenderObject child, slot, newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(RenderObject child, slot) {
    final RenderSliverStickyHeader renderObject =
        this.renderObject as RenderSliverStickyHeader;
    if (renderObject.header == child) renderObject.header = null;
    if (renderObject.child == child) renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}
