import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test helper: pumps [widget] inside a minimal [MaterialApp] so it has a
/// `Directionality`, `Navigator`, and `Theme`. Use in widget tests to avoid
/// repeating the `MaterialApp` wrapper.
extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(MaterialApp(home: widget));
  }
}
