import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Processing extends StatefulWidget {
  const Processing({
    Key? key,
    required this.sketch,
    this.clipBehavior = Clip.hardEdge,
  }) : super(key: key);

  final Sketch sketch;
  final Clip clipBehavior;

  @override
  State<Processing> createState() => _ProcessingState();
}

class _ProcessingState extends State<Processing>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();

    widget.sketch
      .._onSizeChanged = _onSizeChanged
      .._loop = _loop
      .._noLoop = _noLoop;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Processing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.sketch != oldWidget.sketch) {
      oldWidget.sketch
        .._onSizeChanged = null
        .._loop = null
        .._noLoop = null;

      widget.sketch
        .._onSizeChanged = _onSizeChanged
        .._loop = _loop
        .._noLoop = _noLoop;

      _ticker.stop();
      if (widget.sketch._isLooping) {
        _ticker.start();
      }
    }
  }

  void _onTick(Duration elapsedTime) {
    setState(() {
      widget.sketch.elapsedTime = elapsedTime;
    });
  }

  void _onSizeChanged() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        setState(() {});
      },
    );
  }

  void _noLoop() {
    if (_ticker.isTicking) {
      _ticker.stop();
    }
  }

  void _loop() {
    if (!_ticker.isTicking) {
      _ticker.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement animation frames, keyboard input, mouse input
    return Center(
      child: CustomPaint(
        size: Size(
          widget.sketch._desiredWidth.toDouble(),
          widget.sketch._desiredHeight.toDouble(),
        ),
        painter: _SketchPainter(
          sketch: widget.sketch,
          clipBehavior: widget.clipBehavior,
        ),
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

  bool _hasDoneSetup = false;

  void _doSetup() {
    if (_hasDoneSetup) {
      return;
    }

    _hasDoneSetup = true;

    // By default fill the background with a light gray
    background(
      color: _backgroundColor,
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

  void _onDraw() {
    background(color: _backgroundColor);

    // TODO: figure out how to correctly support varying frame rates
    // if (_lastDrawTime != null) {
    //   if (_elapsedTime - _lastDrawTime! < _desiredFrameTime) {
    //     return;
    //   }
    // }

    draw();

    _frameCount += 1;
    _lastDrawTime = _elapsedTime;

    final secondsFraction = _elapsedTime.inMilliseconds / 1000.0;
    _actualFrameRate = secondsFraction > 0
        ? (_frameCount / secondsFraction).round()
        : _actualFrameRate;
  }

  void draw() {
    _draw?.call(this);
  }

  late Canvas _canvas;
  late Size _size;
  late Paint _fillPaint;
  late Paint _strokePaint;
  Color _backgroundColor = Color(0xFFC5C5C5);

  int _desiredWidth = 100;
  int _desiredHeight = 100;
  VoidCallback? _onSizeChanged;

  // ------ Start Structure ------
  bool _isLooping = true;
  VoidCallback? _loop;
  VoidCallback? _noLoop;

  void loop() {
    _isLooping = true;
    _loop?.call();
  }

  void noLoop() {
    _isLooping = false;
    _noLoop?.call();
  }
  // ------ End Structure ------

  // ------ Start Color/Setting ------

  void background({
    required Color color,
  }) {
    _backgroundColor = color;

    final paint = Paint()..color = color;
    _canvas.drawRect(Offset.zero & _size, paint);
  }

  void fill({
    required Color color,
  }) {
    _fillPaint.color = color;
  }

  void noFill() {
    _fillPaint.color = Colors.transparent;
  }

  void stroke({required Color color}) {
    _strokePaint.color = color;
  }

  void noStroke() {
    _strokePaint.color = Colors.transparent;
  }
  // ------ End Color/Setting ------

  // ------ Start Environment ------
  Duration _elapsedTime = Duration.zero;
  set elapsedTime(Duration newElapsedTime) => _elapsedTime = newElapsedTime;

  Duration? _lastDrawTime;

  int _frameCount = 0;
  int get frameCount => _frameCount;

  int _actualFrameRate = 10;
  int get frameRate => _actualFrameRate;

  Duration _desiredFrameTime = Duration(
    milliseconds: (1000.0 / 60).floor(),
  );
  set frameRate(int frameRate) => _desiredFrameTime = Duration(
        milliseconds: (1000.0 / frameRate).floor(),
      );

  int get width => _size.width.toInt();

  int get height => _size.height.toInt();

  void size({required int width, required int height}) {
    _desiredWidth = width;
    _desiredHeight = height;
    _onSizeChanged?.call();
  }
  // ------ End Environment ------

  // ------ Start Random ------
  Random _random = Random();

  /// Sets the seed value for all [random()] invocations to the given [seed]
  /// To return to a natural seed value, pass [null] for [seed].
  void randomSeed(int? seed) {
    _random = Random(seed);
  }

  double random(num bound1, [num? bound2]) {
    final lowerBound = bound2 != null ? bound1 : 0;
    final upperBound = bound2 ?? bound1;

    if (upperBound < lowerBound) {
      throw Exception("random() lower bound must be less than upper bound");
    }

    return _random.nextDouble() * (upperBound - lowerBound) + lowerBound;
  }
  // ------ End Random ------

  // ------ Start Shape/2D Primitives ------
  void circle({required Offset center, required double diameter}) {
    _canvas
      ..drawCircle(center, diameter / 2, _fillPaint)
      ..drawCircle(center, diameter / 2, _strokePaint);
  }

  void square(Square square) {
    _canvas
      ..drawRect(square.rect, _fillPaint)
      ..drawRect(square.rect, _strokePaint);
  }

  void rect({required Rect rect, BorderRadius? borderRadius}) {
    if (borderRadius == null) {
      _canvas
        ..drawRect(rect, _fillPaint)
        ..drawRect(rect, _strokePaint);
    } else {
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      );
      _canvas
        ..drawRRect(rrect, _fillPaint)
        ..drawRRect(rrect, _strokePaint);
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

    _canvas
      ..drawPath(path, _fillPaint)
      ..drawPath(path, _strokePaint);
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

    _canvas
      ..drawPath(path, _fillPaint)
      ..drawPath(path, _strokePaint);
  }

  void line(Offset p1, Offset p2, [Offset? p3]) {
    if (p3 != null) {
      throw UnimplementedError("3D line drawing is not supported yet.");
    }

    _canvas.drawLine(p1, p2, _strokePaint);
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
      ..color = _strokePaint.color
      ..style = PaintingStyle.fill;

    _canvas.drawRect(
      Rect.fromLTWH(x, y, 1, 1),
      _strokePaintForPoint,
    );
  }

  void ellipse(Ellipse ellipse) {
    _canvas
      ..drawOval(ellipse.rect, _fillPaint)
      ..drawOval(ellipse.rect, _strokePaint);
  }

  void arc({
    required Ellipse ellipse,
    required double startAngle,
    required double endAngle,
    ArcMode mode = ArcMode.openStrokePieFill,
  }) {
    switch (mode) {
      case ArcMode.openStrokePieFill:
        _canvas
          ..drawArc(
              ellipse.rect, startAngle, endAngle - startAngle, true, _fillPaint)
          ..drawArc(ellipse.rect, startAngle, endAngle - startAngle, false,
              _strokePaint);
        break;
      case ArcMode.open:
        _canvas
          ..drawArc(ellipse.rect, startAngle, endAngle - startAngle, false,
              _fillPaint)
          ..drawArc(ellipse.rect, startAngle, endAngle - startAngle, false,
              _strokePaint);
        break;
      case ArcMode.chord:
        final chordPath = Path()
          ..addArc(ellipse.rect, startAngle, endAngle - startAngle)
          ..close();

        _canvas
          ..drawArc(ellipse.rect, startAngle, endAngle - startAngle, false,
              _fillPaint)
          ..drawPath(chordPath, _strokePaint);
        break;
      case ArcMode.pie:
        _canvas
          ..drawArc(
              ellipse.rect, startAngle, endAngle - startAngle, true, _fillPaint)
          ..drawArc(ellipse.rect, startAngle, endAngle - startAngle, true,
              _strokePaint);
        break;
    }
  }

  // ------ End Shape/2D Primitives ------

  // ------ Start Transform ------
  void translate({
    double? x,
    double? y,
    double? z,
  }) {
    if (z != null) {
      throw UnimplementedError("3D translations are not yet supported");
    }

    _canvas.translate(x ?? 0, y ?? 0);
  }
  // ------ End Transform ------

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

enum ArcMode {
  openStrokePieFill,
  open,
  chord,
  pie,
}

class _SketchPainter extends CustomPainter {
  final Sketch sketch;
  final Clip clipBehavior;
  _SketchPainter({
    required this.sketch,
    required this.clipBehavior,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (clipBehavior != Clip.none) {
      canvas.clipRect(Offset.zero & size,
          doAntiAlias: clipBehavior == Clip.antiAlias ||
              clipBehavior == Clip.antiAliasWithSaveLayer);
    }

    // TODO: figure out how to save layer for antiAliasWithSaveLayer

    sketch
      .._canvas = canvas
      .._size = size
      .._doSetup()
      .._onDraw();
    // 현재는 애니메이션을 사용하지 않으므로 한번만 수행됨
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // repaint on every frame until we know what the appropriate condition is
    return true;
  }
}
