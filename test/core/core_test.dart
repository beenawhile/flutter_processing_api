import 'package:flutter_processing/flutter_processing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_infra.dart';

void main() {
  group('core', () {
    testGoldens("setup() paints light grey background by default",
        (tester) async {
      // screenshot test = golden test
      /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
      configureWindowForSpecTest(tester);

      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(setup: (s) {
            s.noLoop();
          }),
        ),
      );

      await screenMatchesGolden(tester, 'core_setup_paints_default-background');
    });
  });
}
