import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('core', () {
    testGoldens("user can paint background in setup()", (tester) async {
      // screenshot test = golden test
      /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
      tester.binding.window
        ..physicalSizeTestValue = const Size(100, 100)
        // valid for dektop app. not valid for mobile since it is largely densed.
        ..devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        Processing(
          sketch: PaintBackgroundInSetupSketch(),
        ),
      );

      await screenMatchesGolden(tester, 'core_setup_background');
    });

    testGoldens("user can paint background in draw()", (tester) async {
      // screenshot test = golden test
      /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
      tester.binding.window
        ..physicalSizeTestValue = const Size(100, 100)
        // valid for dektop app. not valid for mobile since it is largely densed.
        ..devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        Processing(
          sketch: PaintBackgroundInDrawSketch(),
        ),
      );

      await screenMatchesGolden(tester, 'core_draw_background');
    });

    testGoldens("user can paint orange background", (tester) async {
      // screenshot test = golden test
      /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
      tester.binding.window
        ..physicalSizeTestValue = const Size(100, 100)
        // valid for dektop app. not valid for mobile since it is largely densed.
        ..devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        Processing(
          sketch: PaintOrangeBackgroundSketch(),
        ),
      );

      await screenMatchesGolden(tester, 'core_draw_background_orange');
    });
  });
  testGoldens("background in draw() replaces background in setup()",
      (tester) async {
    // screenshot test = golden test
    /// Golden Tests: Widget tests. A special mather compares your widget with an image file and expects that it looks the same.
    tester.binding.window
      ..physicalSizeTestValue = const Size(100, 100)
      // valid for dektop app. not valid for mobile since it is largely densed.
      ..devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(
      Processing(
        sketch: PaintBackgroundInSetupAndDrawSketch(),
      ),
    );

    await screenMatchesGolden(tester, 'core_background_setup_draw');
  });
}

class PaintBackgroundInSetupSketch extends Sketch {
  @override
  void setUp() {
    background(color: const Color(0xFF404040));
  }
}

class PaintBackgroundInDrawSketch extends Sketch {
  @override
  void draw() {
    background(color: const Color(0xFF404040));
  }
}

class PaintOrangeBackgroundSketch extends Sketch {
  @override
  void draw() {
    background(color: const Color(0xFFFFCC00));
  }
}

class PaintBackgroundInSetupAndDrawSketch extends Sketch {
  @override
  void setUp() {
    background(color: const Color(0xFFFF0000));
  }

  @override
  void draw() {
    background(color: const Color(0xFF404040));
  }
}
