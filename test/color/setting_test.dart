import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_infra.dart';

void main() {
  group('Color', () {
    group("setting", () {
      testGoldens("background(): example 1", (tester) async {
        // screenshot test = golden test
        /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
        configureWindowForSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) {
                s
                  ..noLoop()
                  ..background(
                    color: const Color(0xFF404040),
                  );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_background-example-1');
      });

      testGoldens("background(): example 2", (tester) async {
        // screenshot test = golden test
        /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
        configureWindowForSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) {
                s
                  ..noLoop()
                  ..background(
                    color: const Color(0xFFFFCC00),
                  );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'color_setting_background-example-2');
      });
    });
    testGoldens("user can paint background in setup()", (tester) async {
      // screenshot test = golden test
      /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
      configureWindowForSpecTest(tester);

      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(
            setup: (s) {
              s
                ..noLoop()
                ..background(
                  color: const Color(0xFF404040),
                );
            },
          ),
        ),
      );

      await screenMatchesGolden(tester, 'color_setting_background-in-setup');
    });

    testGoldens("background in draw() replaces background in setup()",
        (tester) async {
      // screenshot test = golden test
      /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
      configureWindowForSpecTest(tester);

      await tester.pumpWidget(
        Processing(
          sketch: Sketch.simple(
            setup: (s) {
              s
                ..noLoop()
                ..background(
                  color: const Color(0xFFFF0000),
                );
            },
            draw: (s) {
              s.background(
                color: const Color(0xFF404040),
              );
            },
          ),
        ),
      );

      await screenMatchesGolden(
          tester, 'color_setting_background-setup-and-draw');
    });
  });

  testGoldens("fill(): example 1", (tester) async {
    // screenshot test = golden test
    /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
    configureWindowForSpecTest(tester);

    await tester.pumpWidget(
      Processing(
        sketch: Sketch.simple(
          draw: (s) {
            s
              ..noLoop()
              ..fill(
                color: const Color(0xFF969696),
              )
              ..rect(
                rect: const Rect.fromLTWH(30, 20, 55, 55),
              );
          },
        ),
      ),
    );

    await screenMatchesGolden(tester, 'color_setting_fill-example-1');
  });
  testGoldens("fill(): example 2", (tester) async {
    // screenshot test = golden test
    /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
    configureWindowForSpecTest(tester);

    await tester.pumpWidget(
      Processing(
        sketch: Sketch.simple(
          draw: (s) {
            s
              ..noLoop()
              ..fill(
                color: const Color(0xFFCC6600),
              )
              ..rect(
                rect: const Rect.fromLTWH(30, 20, 55, 55),
              );
          },
        ),
      ),
    );

    await screenMatchesGolden(tester, 'color_setting_fill-example-2');
  });

  testGoldens("noFill(): example 1", (tester) async {
    // screenshot test = golden test
    /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
    configureWindowForSpecTest(tester);

    await tester.pumpWidget(
      Processing(
        sketch: Sketch.simple(
          draw: (s) {
            s
              ..noLoop()
              ..rect(
                rect: const Rect.fromLTWH(15, 10, 55, 55),
              )
              ..noFill()
              ..rect(
                rect: const Rect.fromLTWH(30, 20, 55, 55),
              );
          },
        ),
      ),
    );

    await screenMatchesGolden(tester, 'color_setting_nofill-example-1');
  });

  testGoldens("stroke(): example 1", (tester) async {
    // screenshot test = golden test
    /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
    configureWindowForSpecTest(tester);

    await tester.pumpWidget(
      Processing(
        sketch: Sketch.simple(
          draw: (s) {
            s
              ..noLoop()
              ..stroke(
                color: const Color(0xFFAAAAAA),
              )
              ..rect(
                rect: const Rect.fromLTWH(30, 20, 55, 55),
              );
          },
        ),
      ),
    );

    await screenMatchesGolden(tester, 'color_setting_stroke-example-1');
  });

  testGoldens("stroke(): example 2", (tester) async {
    // screenshot test = golden test
    /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
    configureWindowForSpecTest(tester);

    await tester.pumpWidget(
      Processing(
        sketch: Sketch.simple(
          draw: (s) {
            s
              ..noLoop()
              ..stroke(
                color: const Color(0xFFCC6600),
              )
              ..rect(
                rect: const Rect.fromLTWH(30, 20, 55, 55),
              );
          },
        ),
      ),
    );

    await screenMatchesGolden(tester, 'color_setting_stroke-example-2');
  });
  testGoldens("noStroke(): example 1", (tester) async {
    // screenshot test = golden test
    /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
    configureWindowForSpecTest(tester);

    await tester.pumpWidget(
      Processing(
        sketch: Sketch.simple(
          draw: (s) {
            s
              ..noLoop()
              ..noStroke()
              ..rect(
                rect: const Rect.fromLTWH(30, 20, 55, 55),
              );
          },
        ),
      ),
    );

    await screenMatchesGolden(tester, 'color_setting_nostroke-example-1');
  });
}
