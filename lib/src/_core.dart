import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' hide Image;

class Processing extends StatefulWidget {
  const Processing({
    Key? key,
    this.focusNode,
    required this.sketch,
    this.clipBehavior = Clip.hardEdge,
  }) : super(key: key);

  final FocusNode? focusNode;
  final Sketch sketch;
  final Clip clipBehavior;

  @override
  _ProcessingState createState() => _ProcessingState();
}

class _ProcessingState extends State<Processing>
    with SingleTickerProviderStateMixin {
  final _controlKeys = <LogicalKeyboardKey>{
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.controlRight,
    LogicalKeyboardKey.meta,
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
    LogicalKeyboardKey.capsLock,
    LogicalKeyboardKey.escape,
    LogicalKeyboardKey.arrowLeft,
    LogicalKeyboardKey.arrowRight,
    LogicalKeyboardKey.arrowUp,
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.home,
    LogicalKeyboardKey.end,
    LogicalKeyboardKey.pageUp,
    LogicalKeyboardKey.pageDown,
  };

  final _sketchCanvasKey = GlobalKey();

  late Ticker _ticker;
  late FocusNode _focusNode;

  Image? _currentImage;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();

    _focusNode = widget.focusNode ?? FocusNode();

    widget.sketch
      .._onFrameAvailable = _onFrameAvailable
      .._onSizeChanged = _onSizeChanged
      .._loop = _loop
      .._noLoop = _noLoop;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.sketch._assetBundle = DefaultAssetBundle.of(context);
  }

  @override
  void didUpdateWidget(Processing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode = widget.focusNode ?? FocusNode();
    }

    if (widget.sketch != oldWidget.sketch) {
      oldWidget.sketch
        .._onFrameAvailable = null
        .._onSizeChanged = null
        .._loop = null
        .._noLoop = null;

      widget.sketch
        .._onFrameAvailable = _onFrameAvailable
        .._assetBundle = DefaultAssetBundle.of(context)
        .._onSizeChanged = _onSizeChanged
        .._loop = _loop
        .._noLoop = _noLoop;

      _ticker.stop();
      if (widget.sketch._isLooping) {
        _ticker.start();
      }
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(elapsedTime) {
    widget.sketch._doDrawFrame(elapsedTime);
  }

  void _onFrameAvailable(Image newFrame) {
    if (mounted) {
      setState(() {
        _currentImage = newFrame;
      });
    }
  }

  void _onSizeChanged() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
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

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      widget.sketch._onKeyPressed(event.logicalKey);

      if (!_controlKeys.contains(event.logicalKey)) {
        widget.sketch._onKeyTyped(event.logicalKey);
      }
    } else if (event is RawKeyUpEvent) {
      widget.sketch._onKeyReleased(event.logicalKey);
    }
  }

  MouseButton _getMouseButton(int mouseButtonMask) {
    if (mouseButtonMask & kPrimaryMouseButton != 0) {
      return MouseButton.left;
    } else if (mouseButtonMask & kSecondaryMouseButton != 0) {
      return MouseButton.right;
    } else if (mouseButtonMask & kMiddleMouseButton != 0) {
      return MouseButton.center;
    } else {
      throw Exception('Invalid mouse button mask: $mouseButtonMask');
    }
  }

  Offset _getCanvasOffsetFromWidgetOffset(Offset widgetOffset) {
    final myBox = context.findRenderObject();
    final canvasBox =
        _sketchCanvasKey.currentContext!.findRenderObject() as RenderBox;
    return canvasBox.globalToLocal(widgetOffset, ancestor: myBox);
  }

  void _onPointerDown(PointerDownEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }

    final mouseButton = _getMouseButton(event.buttons);

    widget.sketch._pressedMouseButtons.add(mouseButton);
    widget.sketch
      .._mouseButton = mouseButton
      .._updateMousePosition(
        _getCanvasOffsetFromWidgetOffset(event.position),
      )
      .._onMousePressed();
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }

    final mouseButton = _getMouseButton(event.buttons);

    widget.sketch
      .._mouseButton = mouseButton
      .._updateMousePosition(
        _getCanvasOffsetFromWidgetOffset(event.position),
      )
      .._onMouseDragged();
  }

  void _onPointerUp(PointerUpEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }

    // TODO: the PointerUpEvent does not report which button was relased,
    //       therefore we don't know which one to remove from the set.
    //       For now, we remove all pressed button.
    //
    //       Find an appropriate solution to handle concurrent mouse button
    //       presses and releases.
    widget.sketch._pressedMouseButtons.clear();
    widget.sketch
      .._mouseButton = null
      .._updateMousePosition(
        _getCanvasOffsetFromWidgetOffset(event.position),
      )
      .._onMouseReleased()
      .._onMouseClicked();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }

    // TODO: the PointerUpEvent does not report which button was relased,
    //       therefore we don't know which one to remove from the set.
    //       For now, we remove all pressed button.
    //
    //       Find an appropriate solution to handle concurrent mouse button
    //       presses and releases.
    widget.sketch._pressedMouseButtons.clear();
    widget.sketch
      .._mouseButton = null
      .._updateMousePosition(
        _getCanvasOffsetFromWidgetOffset(event.position),
      )
      .._onMouseReleased();
  }

  void _onPointerHover(PointerHoverEvent event) {
    if (event.kind != PointerDeviceKind.mouse) {
      return;
    }

    widget.sketch
      .._updateMousePosition(
        _getCanvasOffsetFromWidgetOffset(event.position),
      )
      .._onMouseMoved();
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) {
      return;
    }

    widget.sketch._onMouseWheel(event.scrollDelta.dy);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _onKey,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        onPointerHover: _onPointerHover,
        onPointerSignal: _onPointerSignal,
        child: Center(
          child: _currentImage != null
              ? RawImage(
                  key: _sketchCanvasKey,
                  image: _currentImage,
                )
              : SizedBox(
                  key: _sketchCanvasKey,
                ),
        ),
      ),
    );
  }
}

class Sketch {
  Sketch.simple({
    Future<void> Function(Sketch)? setup,
    Future<void> Function(Sketch)? draw,
    void Function(Sketch)? keyPressed,
    void Function(Sketch)? keyTyped,
    void Function(Sketch)? keyReleased,
    void Function(Sketch)? mousePressed,
    void Function(Sketch)? mouseDragged,
    void Function(Sketch)? mouseReleased,
    void Function(Sketch)? mouseClicked,
    void Function(Sketch)? mouseMoved,
    void Function(Sketch, double)? mouseWheel,
  })  : _setup = setup,
        _draw = draw,
        _keyPressed = keyPressed,
        _keyTyped = keyTyped,
        _keyReleased = keyReleased,
        _mousePressed = mousePressed,
        _mouseDragged = mouseDragged,
        _mouseReleased = mouseReleased,
        _mouseClicked = mouseClicked,
        _mouseMoved = mouseMoved,
        _mouseWheel = mouseWheel;

  Sketch();

  Future<void> Function(Sketch)? _setup;
  Future<void> Function(Sketch)? _draw;
  void Function(Sketch)? _keyPressed;
  void Function(Sketch)? _keyTyped;
  void Function(Sketch)? _keyReleased;
  void Function(Sketch)? _mousePressed;
  void Function(Sketch)? _mouseDragged;
  void Function(Sketch)? _mouseReleased;
  void Function(Sketch)? _mouseClicked;
  void Function(Sketch)? _mouseMoved;
  void Function(Sketch, double count)? _mouseWheel;

  AssetBundle? _assetBundle;

  void Function(Image newFrame)? _onFrameAvailable;
  bool _isDrawing = false;

  late PictureRecorder _recorder;
  Image? _intermediateImage;
  ByteData? _pixels;
  bool _hasUnappliedCanvasCommands = false;
  Image? _publishedImage;

  bool _hasDoneSetup = false;

  Future<void> _doDrawFrame(Duration elapsedTime) async {
    if (_isDrawing || (_hasDoneSetup && !_isLooping)) {
      return;
    }

    _isDrawing = true;
    _intermediateImage = null;

    _updateElapsedTime(elapsedTime);

    _startRecording();

    // Run Processing setup method.
    await _doSetup();

    // Run Processing draw method.
    await _onDraw();

    await _finishRecording();

    _onFrameAvailable?.call(_publishedImage!);
    _isDrawing = false;
  }

  void _startRecording() {
    _recorder = PictureRecorder();
    _canvas = Canvas(_recorder);
  }

  Future<void> _doIntermediateRasterization() async {
    _intermediateImage = await _rasterize();
    _startRecording();

    _canvas.drawImage(_intermediateImage!, Offset.zero, Paint());

    _hasUnappliedCanvasCommands = false;
  }

  Future<void> _finishRecording() async {
    _publishedImage = await _rasterize();
  }

  Future<Image> _rasterize() async {
    final picture = _recorder.endRecording();
    return await picture.toImage(_desiredWidth, _desiredHeight);
  }

  Future<void> _doSetup() async {
    assert(_assetBundle != null);

    if (_hasDoneSetup) {
      return;
    }
    _hasDoneSetup = true;

    // By default fill the background with a light grey.
    background(color: _backgroundColor);

    // By default, the fill color is white and the stroke is 1px black.
    _fillPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    _strokePaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    await setup();
  }

  Future<void> setup() async {
    await _setup?.call(this);
  }

  Future<void> _onDraw() async {
    // TODO: figure out how to correctly support varying frame rates
    // if (_lastDrawTime != null) {
    //   if (_elapsedTime - _lastDrawTime! < _desiredFrameTime) {
    //     return;
    //   }
    // }

    if (_publishedImage != null) {
      _canvas.drawImage(_publishedImage!, Offset.zero, Paint());
    }

    await draw();

    _frameCount += 1;
    _lastDrawTime = _elapsedTime;

    final secondsFraction = _elapsedTime.inMilliseconds / 1000.0;
    _actualFrameRate = secondsFraction > 0
        ? (_frameCount / secondsFraction).round()
        : _actualFrameRate;
  }

  Future<void> draw() async {
    await _draw?.call(this);
  }

  void _onKeyPressed(LogicalKeyboardKey key) {
    _pressedKeys.add(key);
    _key = key;

    keyPressed();
  }

  void keyPressed() {
    _keyPressed?.call(this);
  }

  void _onKeyTyped(LogicalKeyboardKey key) {
    keyTyped();
  }

  void keyTyped() {
    _keyTyped?.call(this);
  }

  void _onKeyReleased(LogicalKeyboardKey key) {
    _pressedKeys.remove(key);
    _key = key;

    keyReleased();
  }

  void keyReleased() {
    _keyReleased?.call(this);
  }

  void _onMousePressed() {
    mousePressed();
  }

  void mousePressed() {
    _mousePressed?.call(this);
  }

  void _onMouseDragged() {
    mouseDragged();
  }

  void mouseDragged() {
    _mouseDragged?.call(this);
  }

  void _onMouseReleased() {
    mouseReleased();
  }

  void mouseReleased() {
    _mouseReleased?.call(this);
  }

  void _onMouseClicked() {
    mouseClicked();
  }

  void mouseClicked() {
    _mouseClicked?.call(this);
  }

  void _onMouseMoved() {
    mouseMoved();
  }

  void mouseMoved() {
    _mouseMoved?.call(this);
  }

  void _onMouseWheel(double count) {
    mouseWheel(count);
  }

  void mouseWheel(double count) {
    _mouseWheel?.call(this, count);
  }

  late Canvas _canvas;
  late Size _size = Size(100, 100);
  late Paint _fillPaint;
  late Paint _strokePaint;
  Color _backgroundColor = const Color(0xFFC5C5C5);

  int _desiredWidth = 100;
  int _desiredHeight = 100;
  VoidCallback? _onSizeChanged;

  //------ Start Structure -----
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

  //------ Start Environment -----
  Duration _elapsedTime = Duration.zero;
  void _updateElapsedTime(Duration newElapsedTime) =>
      _elapsedTime = newElapsedTime;

  Duration? _lastDrawTime;

  int _frameCount = 0;
  int get frameCount => _frameCount;

  int _actualFrameRate = 10;
  int get frameRate => _actualFrameRate;

  Duration _desiredFrameTime = Duration(milliseconds: (1000.0 / 60).floor());
  set frameRate(int frameRate) {
    print('WARNING: non-natural frame rates are very buggy at this time');

    _desiredFrameTime = Duration(milliseconds: (1000.0 / frameRate).floor());
  }

  int get width => _desiredWidth;

  int get height => _desiredHeight;

  void size({
    required int width,
    required int height,
  }) {
    _desiredWidth = width;
    _desiredHeight = height;
    _size = Size(width.toDouble(), height.toDouble());
    _onSizeChanged?.call();

    background(color: _backgroundColor);
  }

  //------ Start Random -----
  Random _random = Random();

  /// Sets the seed value for all [random()] invocations to the given
  /// [seed].
  ///
  /// To return to a natural seed value, pass [null] for [seed].
  void randomSeed(int? seed) {
    _random = Random(seed);
  }

  double random(num bound1, [num? bound2]) {
    final lowerBound = bound2 != null ? bound1 : 0;
    final upperBound = bound2 != null ? bound2 : bound1;

    if (upperBound < lowerBound) {
      throw Exception('random() lower bound must be less than upper bound');
    }

    return _random.nextDouble() * (upperBound - lowerBound) + lowerBound;
  }

  //------ Start Color/Setting -----
  void background({
    required Color color,
  }) {
    _backgroundColor = color;

    final paint = Paint()..color = color;
    _canvas.drawRect(Offset.zero & _size, paint);

    _hasUnappliedCanvasCommands = true;
  }

  void fill({
    required Color color,
  }) {
    _fillPaint.color = color;
  }

  void noFill() {
    _fillPaint.color = const Color(0x00000000);
  }

  void stroke({
    required Color color,
  }) {
    _strokePaint.color = color;
  }

  void noStroke() {
    _strokePaint.color = const Color(0x00000000);
  }
  //------- End Color/Setting -----

  //------- Start Image/Loading & Displaying -----
  Future<Image> loadImage(String filepath) async {
    final imageData = await _assetBundle!.load(filepath);
    final codec = await (await ImageDescriptor.encoded(
      await ImmutableBuffer.fromUint8List(imageData.buffer.asUint8List()),
    ))
        .instantiateCodec();

    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void image({
    required Image image,
    Offset origin = Offset.zero,
    Size? displaySize,
  }) {
    // TODO: implement displaySize support.
    _canvas.drawImage(image, origin, Paint());

    _hasUnappliedCanvasCommands = true;
  }

  //------- Start Image/Pixels -----
  Future<Color> get(int x, int y) async {
    await _doIntermediateRasterization();
    final sourceImage = _intermediateImage ?? _publishedImage;

    final pixelDataOffset = _getBitmapPixelOffset(
      imageWidth: sourceImage!.width,
      x: x,
      y: y,
    );
    final imageData = await sourceImage.toByteData();
    final rgbaColor = imageData!.getUint32(pixelDataOffset);
    final argbColor =
        ((rgbaColor & 0x000000FF) << 24) | ((rgbaColor & 0xFFFFFF00) >> 8);
    return Color(argbColor);
  }

  Future<Image> getRegion({
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    await _doIntermediateRasterization();
    final sourceImage = _intermediateImage ?? _publishedImage;

    final sourceData = await sourceImage!.toByteData();
    final destinationData = Uint8List(width * height * 4);
    final rowLength = width * 4;

    for (int row = 0; row < height; row += 1) {
      final sourceRowOffset = _getBitmapPixelOffset(
        imageWidth: sourceImage.width,
        x: x,
        y: y + row,
      );
      final destinationRowOffset = _getBitmapPixelOffset(
        imageWidth: width,
        x: 0,
        y: row,
      );

      destinationData.setRange(
        destinationRowOffset,
        destinationRowOffset + rowLength - 1,
        Uint8List.view(sourceData!.buffer, sourceRowOffset, rowLength),
      );
    }

    final codec = await ImageDescriptor.raw(
      await ImmutableBuffer.fromUint8List(destinationData),
      width: width,
      height: height,
      pixelFormat: PixelFormat.rgba8888,
    ).instantiateCodec();

    return (await codec.getNextFrame()).image;
  }

  Future<void> loadPixels() async {
    await _doIntermediateRasterization();

    final sourceImage = _intermediateImage ?? _publishedImage;
    _pixels = await sourceImage!.toByteData();
  }

  void set({
    required int x,
    required int y,
    required Color color,
  }) {
    if (_pixels == null) {
      throw Exception("Must call loadPixels() before calling set()");
    }

    final pixelIndex = _getBitmapPixelOffset(
      imageWidth: width,
      x: x,
      y: y,
    );

    // color transformation
    final argbColorInt = color.value;
    final rgbaColor = ((argbColorInt & 0xFF000000) >> 24) |
        ((argbColorInt & 0x00FFFFFF) << 8);
    _pixels!.setUint32(pixelIndex, rgbaColor);
  }

  Future<void> setRegion({
    required Image image,
    int x = 0,
    int y = 0,
  }) async {
    if (_pixels == null) {
      throw Exception("Must call loadPixels() before calling set()");
    }

    final pixelsCodec = await ImageDescriptor.raw(
      await ImmutableBuffer.fromUint8List(_pixels!.buffer.asUint8List()),
      width: width,
      height: height,
      pixelFormat: PixelFormat.rgba8888,
    ).instantiateCodec();

    final pixelsImage = (await pixelsCodec.getNextFrame()).image;

    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    canvas
      ..drawImage(
        pixelsImage,
        Offset.zero,
        Paint(),
      )
      ..drawImage(
        image,
        Offset(x.toDouble(), y.toDouble()),
        Paint(),
      );

    final picture = pictureRecorder.endRecording();
    final combinedImage = await picture.toImage(width, height);

    _pixels = (await combinedImage.toByteData());
  }

  Future<void> updatePixels() async {
    if (_pixels == null) {
      throw Exception("Must call loadPixels() before calling updatePixels()");
    }

    final pixelsCodec = await ImageDescriptor.raw(
      await ImmutableBuffer.fromUint8List(_pixels!.buffer.asUint8List()),
      width: width,
      height: height,
      pixelFormat: PixelFormat.rgba8888,
    ).instantiateCodec();

    final pixelsImage = (await pixelsCodec.getNextFrame()).image;

    image(image: pixelsImage);
  }

  int _getBitmapPixelOffset({
    required int imageWidth,
    required int x,
    required int y,
  }) {
    return ((y * imageWidth) + x) * 4;
  }

  //----- Start Shape/2D Primitives ----
  void point({
    required double x,
    required double y,
    double? z,
  }) {
    if (z != null) {
      throw UnimplementedError('3D point drawing is not yet supported.');
    }

    _strokePaint.style = PaintingStyle.fill;
    _canvas.drawRect(
      Rect.fromLTWH(x, y, 1, 1),
      _strokePaint,
    );
    _strokePaint.style = PaintingStyle.stroke;

    _hasUnappliedCanvasCommands = true;
  }

  void line(Offset p1, Offset p2, [Offset? p3]) {
    if (p3 != null) {
      throw UnimplementedError('3D line drawing is not yet supported.');
    }

    _canvas.drawLine(p1, p2, _strokePaint);

    _hasUnappliedCanvasCommands = true;
  }

  void circle({
    required Offset center,
    required double diameter,
  }) {
    _canvas
      ..drawCircle(center, diameter / 2, _fillPaint)
      ..drawCircle(center, diameter / 2, _strokePaint);

    _hasUnappliedCanvasCommands = true;
  }

  void ellipse(Ellipse ellipse) {
    _canvas //
      ..drawOval(ellipse.rect, _fillPaint) //
      ..drawOval(ellipse.rect, _strokePaint);

    _hasUnappliedCanvasCommands = true;
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

    _hasUnappliedCanvasCommands = true;
  }

  void square(Square square) {
    _canvas //
      ..drawRect(square.rect, _fillPaint) //
      ..drawRect(square.rect, _strokePaint);

    _hasUnappliedCanvasCommands = true;
  }

  void rect({
    required Rect rect,
    BorderRadius? borderRadius,
  }) {
    if (borderRadius == null) {
      _canvas //
        ..drawRect(rect, _fillPaint) //
        ..drawRect(rect, _strokePaint);
    } else {
      final rrect = RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      );
      _canvas //
        ..drawRRect(rrect, _fillPaint) //
        ..drawRRect(rrect, _strokePaint);
    }

    _hasUnappliedCanvasCommands = true;
  }

  void triangle(Offset p1, Offset p2, Offset p3) {
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    _canvas //
      ..drawPath(path, _fillPaint) //
      ..drawPath(path, _strokePaint);

    _hasUnappliedCanvasCommands = true;
  }

  void quad(Offset p1, Offset p2, Offset p3, Offset p4) {
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p4.dx, p4.dy)
      ..close();

    _canvas //
      ..drawPath(path, _fillPaint) //
      ..drawPath(path, _strokePaint);

    _hasUnappliedCanvasCommands = true;
  }
  //------- End Shape/2D Primitives -----

  //----- Start Shape/Attributes ----
  void strokeWeight(int newWeight) {
    if (newWeight < 0) {
      throw Exception('Stroke weight must be >= 0');
    }

    _strokePaint.strokeWidth = newWeight.toDouble();
  }

  //----- Start Input/Mouse ----
  int _mouseX = 0;
  int get mouseX => _mouseX;

  int _mouseY = 0;
  int get mouseY => _mouseY;

  int _pmouseX = 0;
  int get pmouseX => _pmouseX;

  int _pmouseY = 0;
  int get pmouseY => _pmouseY;

  void _updateMousePosition(Offset newPosition) {
    _pmouseX = _mouseX;
    _pmouseY = _mouseY;

    _mouseX = newPosition.dx.round();
    _mouseY = newPosition.dy.round();
  }

  Set<MouseButton> _pressedMouseButtons = {};

  bool get isMousePressed => _pressedMouseButtons.isNotEmpty;

  MouseButton? _mouseButton;
  MouseButton? get mouseButton => _mouseButton;

  //----- Start Input/Keyboard ----
  Set<LogicalKeyboardKey> _pressedKeys = {};

  bool get isKeyPressed => _pressedKeys.isNotEmpty;

  LogicalKeyboardKey? _key;
  LogicalKeyboardKey? get key => _key;

  //------- Start Transform ------
  void translate({
    double? x,
    double? y,
    double? z,
  }) {
    if (z != null) {
      throw UnimplementedError('3D translations are not yet supported.');
    }

    _canvas.translate(x ?? 0, y ?? 0);

    _hasUnappliedCanvasCommands = true;
  }

  // TODO: implement all other Processing APIs
}

enum MouseButton {
  left,
  center,
  right,
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

  final Rect _rect;
  Rect get rect => _rect;
}

class Ellipse {
  Ellipse.fromLTWH({
    required Offset topLeft,
    required double width,
    required double height,
  }) : _rect = Rect.fromLTWH(
          topLeft.dx,
          topLeft.dy,
          width,
          height,
        );

  Ellipse.fromLTRB({
    required Offset topLeft,
    required Offset bottomRight,
  }) : _rect = Rect.fromLTRB(
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

  final Rect _rect;
  Rect get rect => _rect;
}

enum ArcMode {
  openStrokePieFill,
  open,
  chord,
  pie,
}
