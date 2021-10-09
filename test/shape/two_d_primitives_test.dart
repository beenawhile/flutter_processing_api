import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_infra.dart';

void main() {
  group("shape", () {
    group('2D primitives', () {
      testGoldens("circle(): example 1", (tester) async {
        configureWindowForSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(draw: (s) {
              s.circle(
                center: const Offset(56, 46),
                diameter: 55,
              );
            }),
          ),
        );

        await screenMatchesGolden(
            tester, 'shape_2d_primitives_circle-example-1');
      });

      testGoldens("square(): example 1", (tester) async {
        configureWindowForSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) {
                s.square(
                  Square.fromLTE(const Offset(30, 20), 55),
                  // Squre.fromCenter(Offset(30,20), 55)
                );
              },
            ),
          ),
        );

        await screenMatchesGolden(
            tester, 'shape_2d_primitives_square-example-1');
      });
      testGoldens("rect(): example 1", (tester) async {
        configureWindowForSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) {
                s.rect(
                  rect: const Rect.fromLTWH(30, 20, 55, 55),
                  // Squre.fromCenter(Offset(30,20), 55)
                );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'shape_2d_primitives_rect-example-1');
      });
      testGoldens("rect(): example 2", (tester) async {
        configureWindowForSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) {
                s.rect(
                    rect: const Rect.fromLTWH(30, 20, 55, 55),
                    borderRadius: BorderRadius.circular(7)
                    // Squre.fromCenter(Offset(30,20), 55)
                    );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'shape_2d_primitives_rect-example-2');
      });
      testGoldens("rect(): example 3", (tester) async {
        configureWindowForSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) {
                s.rect(
                  rect: const Rect.fromLTWH(30, 20, 55, 55),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3),
                    topRight: Radius.circular(6),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(18),
                  ),
                  // Squre.fromCenter(Offset(30,20), 55)
                );
              },
            ),
          ),
        );

        await screenMatchesGolden(tester, 'shape_2d_primitives_rect-example-3');
      });
      testGoldens("triangle(): example 1", (tester) async {
        configureWindowForSpecTest(tester);

        await tester.pumpWidget(
          Processing(
            sketch: Sketch.simple(
              draw: (s) {
                s.triangle(
                  const Offset(30, 75),
                  const Offset(58, 20),
                  const Offset(86, 75),
                );
              },
            ),
          ),
        );

        await screenMatchesGolden(
            tester, 'shape_2d_primitives_triangle-example-1');
      });
    });
  });
}
