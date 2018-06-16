import 'package:flutter/widgets.dart';

class SliverStickyHeaderScrollNotifier extends ChangeNotifier {
  double get scrollPercentage => _scrollPercentage;
  double _scrollPercentage;
  set scrollPercentage(double value) {
    assert(value != null);
    _scrollPercentage = value;
    notifyListeners();
  }
}
