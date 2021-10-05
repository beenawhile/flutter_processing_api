import 'package:flutter/material.dart';

class Processing extends StatelessWidget {
  const Processing({
    Key? key,
    required this.sketch,
  }) : super(key: key);

  final Sketch sketch;

  @override
  Widget build(BuildContext context) {
    // TODO: implement animation frames, keyboard input, mouse input
    return CustomPaint(
      size: Size.infinite,
      painter: _SketchPainter(
        sketch: sketch,
      ),
    );
  }
}

abstract class Sketch {
  // TODO: find a way to allow for sketch implementations to avoid
  //       subclassing Sketch.

  // empty implementation
  void setUp() {}

  void draw() {}

  Canvas? canvas;
  Size? size;

  void background({
    required Color color,
  }) {
    assert(canvas != null);
    assert(size != null);

    final paint = Paint()..color = color;
    canvas!.drawRect(Offset.zero & size!, paint);
  }

  // TODO: implement all other processing apis.
}

class _SketchPainter extends CustomPainter {
  final Sketch sketch;
  _SketchPainter({
    required this.sketch,
  });

  @override
  void paint(Canvas canvas, Size size) {
    sketch
      ..canvas = canvas
      ..size = size
      ..setUp()
      ..draw();
    // 현재는 애니메이션을 사용하지 않으므로 한번만 수행됨
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // repaint on every frame until we know what the appropriate condition is
    return true;
  }
}
