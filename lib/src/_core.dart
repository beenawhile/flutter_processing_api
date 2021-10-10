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

class Sketch {
  Sketch();

  Sketch.simple({
    void Function(Sketch)? setup,
    void Function(Sketch)? draw,
  })  : _setup = setup,
        _draw = draw;

  void Function(Sketch)? _setup;
  void Function(Sketch)? _draw;

  // TODO: find a way to allow for sketch implementations to avoid
  //       subclassing Sketch.

  void _doSetup() {
    assert(canvas != null);
    assert(size != null);

    // By default fill the background with a light gray
    background(
      color: const Color(0xFFC5C5C5),
    );

    // By default, the fill color is white and stroke is 1px black
    _fillPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;

    _strokePaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    setup();
  }

  // empty implementation
  void setup() {
    _setup?.call(this);
  }

  void draw() {
    _draw?.call(this);
  }

  Canvas? canvas;
  Size? size;
  Paint? _fillPaint;
  Paint? _strokePaint;

  // ------ Start Color/Setting ------
  void background({
    required Color color,
  }) {
    final paint = Paint()..color = color;
    canvas!.drawRect(Offset.zero & size!, paint);
  }

  void fill({
    required Color color,
  }) {
    _fillPaint!.color = color;
  }

  void noFill() {
    _fillPaint!.color = Colors.transparent;
  }

  void stroke({required Color color}) {
    _strokePaint!.color = color;
  }

  void noStroke() {
    _strokePaint!.color = Colors.transparent;
  }

  // ------ End Color/Setting ------

  // ------ Start Shape/2D Primitives ------
  void circle({required Offset center, required double diameter}) {
    canvas!
      ..drawCircle(center, diameter / 2, _fillPaint!)
      ..drawCircle(center, diameter / 2, _strokePaint!);
  }

  void square(Square square) {
    canvas!
      ..drawRect(square.rect, _fillPaint!)
      ..drawRect(square.rect, _strokePaint!);
  }

  void rect({required Rect rect, BorderRadius? borderRadius}) {
    if (borderRadius == null) {
      canvas!
        ..drawRect(rect, _fillPaint!)
        ..drawRect(rect, _strokePaint!);
    } else {
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      );
      canvas!
        ..drawRRect(rrect, _fillPaint!)
        ..drawRRect(rrect, _strokePaint!);
    }
  }

  void triangle(
    Offset p1,
    Offset p2,
    Offset p3,
  ) {
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    canvas!
      ..drawPath(path, _fillPaint!)
      ..drawPath(path, _strokePaint!);
  }

  void quad(
    Offset p1,
    Offset p2,
    Offset p3,
    Offset p4,
  ) {
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p4.dx, p4.dy)
      ..close();

    canvas!
      ..drawPath(path, _fillPaint!)
      ..drawPath(path, _strokePaint!);
  }

  void line(Offset p1, Offset p2, [Offset? p3]) {
    if (p3 != null) {
      throw UnimplementedError("3D line drawing is not supported yet.");
    }

    canvas!.drawLine(p1, p2, _strokePaint!);
  }

  void point({
    required double x,
    required double y,
    double? z,
  }) {
    if (z != null) {
      throw UnimplementedError("3D point drawing is not yet supported");
    }

    final _strokePaintForPoint = Paint()
      ..color = _strokePaint!.color
      ..style = PaintingStyle.fill;

    canvas!.drawRect(
      Rect.fromLTWH(x, y, 1, 1),
      _strokePaintForPoint,
    );
  }

  void ellipse(Ellipse ellipse) {
    canvas!
      ..drawOval(ellipse.rect, _fillPaint!)
      ..drawOval(ellipse.rect, _strokePaint!);
  }

  // ------ End Shape/2D Primitives ------

  // TODO: implement all other processing apis.
}

class Square {
  Square.fromLTE(Offset topLeft, double extent)
      : _rect = Rect.fromLTWH(
          topLeft.dx,
          topLeft.dy,
          extent,
          extent,
        );

  Square.fromCenter(Offset center, double extent)
      : _rect = Rect.fromCenter(
          center: center,
          width: extent,
          height: extent,
        );

  Rect? _rect;

  Square._();

  Rect get rect => _rect!;
}

class Ellipse {
  Ellipse.fromLTWH(
      {required Offset topLeft, required double width, required double height})
      : _rect = Rect.fromLTWH(
          topLeft.dx,
          topLeft.dy,
          width,
          height,
        );

  Ellipse.fromLTRB({required Offset topLeft, required Offset bottomRight})
      : _rect = Rect.fromLTRB(
          topLeft.dx,
          topLeft.dy,
          bottomRight.dx,
          bottomRight.dy,
        );

  Ellipse.fromCenter({
    required Offset center,
    required double width,
    required double height,
  }) : _rect = Rect.fromCenter(
          center: center,
          width: width,
          height: height,
        );
  Ellipse.fromCenterWithRadius({
    required Offset center,
    required double radius1,
    required double radius2,
  }) : _rect = Rect.fromCenter(
          center: center,
          width: radius1 * 2,
          height: radius2 * 2,
        );

  Rect? _rect;

  Ellipse._();

  Rect get rect => _rect!;
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
      .._doSetup()
      ..draw();
    // 현재는 애니메이션을 사용하지 않으므로 한번만 수행됨
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // repaint on every frame until we know what the appropriate condition is
    return true;
  }
}
