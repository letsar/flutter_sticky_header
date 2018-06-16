import 'package:flutter/widgets.dart';

/// This object notifies its listeners when [scrollPercentage] changes.
class SliverStickyHeaderScrollNotifier extends ChangeNotifier {
  /// The percentage of the header's content scroll.
  double get scrollPercentage => _scrollPercentage;
  double _scrollPercentage;
  set scrollPercentage(double value) {
    assert(value != null);
    _scrollPercentage = value;
    notifyListeners();
  }
}
