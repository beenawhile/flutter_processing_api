import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_infra.dart';

void main() {
  group("Tranform", () {
    testGoldens("translate(): example 1", (tester) async {
      configureWindowForSpecTest(tester);

      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(draw: (s) {
            s
              ..translate(x: 30, y: 20)
              ..rect(
                rect: Rect.fromLTWH(0, 0, 55, 55),
              );
          }),
        ),
      );

      await screenMatchesGolden(
        tester,
        'transform_translate-example-1',
        customPump: (tester) async {
          await tester.pump(const Duration(milliseconds: 17));
          await tester.pump(const Duration(milliseconds: 17));
        },
      );
    });
    testGoldens("translate(): example 2", (tester) async {
      configureWindowForSpecTest(tester);

      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(draw: (s) {
            s
              ..rect(
                rect: const Rect.fromLTWH(0, 0, 55, 55),
              )
              ..translate(x: 30, y: 20)
              ..rect(
                rect: const Rect.fromLTWH(0, 0, 55, 55),
              )
              ..translate(x: 14, y: 14)
              ..rect(
                rect: const Rect.fromLTWH(0, 0, 55, 55),
              );
          }),
        ),
      );

      await screenMatchesGolden(
        tester,
        'transform_translate-example-2',
        customPump: (tester) async {
          await tester.pump(const Duration(milliseconds: 17));
          await tester.pump(const Duration(milliseconds: 17));
        },
      );
    });
  });
}
