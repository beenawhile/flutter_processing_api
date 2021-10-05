import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void configureWindowForSpecTest(WidgetTester tester) {
  tester.binding.window
    ..physicalSizeTestValue = const Size(100, 100)
    // valid for dektop app. not valid for mobile since it is largely densed.
    ..devicePixelRatioTestValue = 1.0;
}
