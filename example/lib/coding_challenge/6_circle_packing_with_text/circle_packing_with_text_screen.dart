import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_processing/flutter_processing.dart';

class CirclePackingWithTextScreen extends StatefulWidget {
  const CirclePackingWithTextScreen({Key? key}) : super(key: key);

  @override
  State<CirclePackingWithTextScreen> createState() =>
      _CirclePackingWithTextScreenState();
}

class _CirclePackingWithTextScreenState
    extends State<CirclePackingWithTextScreen> {
  final Sketch _sketch = CirclePackingWithTextScatch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Processing(
        sketch: _sketch,
      ),
    );
  }
}

class CirclePackingWithTextScatch extends Sketch {
  final List<Circle> _circles = [];

  final _newCirclesPerFrame = 20;
  final _maxNewCircleAttemps = 100;

  late ui.Image _textImage;

  // find white pixel position
  final _whitePixels = <Offset>[];

  @override
  Future<void> setup() async {
    size(width: 800, height: 400);
    _textImage = await loadImage("assets/images/flutter-text.png");

    final imageBytes = (await _textImage.toByteData()) as ByteData;
    for (int col = 0; col < _textImage.width; col += 1) {
      for (int row = 0; row < _textImage.height; row += 1) {
        // 4 bytes for pixel: red, green, blue, alpha
        final pixelOffset = ((row * _textImage.width) + col) * 4;
        // Uint32: 8 bits for byte * 4 bits for color
        final rgbaColor = imageBytes.getUint32(pixelOffset);

        if (rgbaColor == 0xFFFFFFFF) {
          _whitePixels.add(Offset(col.toDouble(), row.toDouble()));
        }
      }
    }
  }

  @override
  Future<void> draw() async {
    background(color: Colors.black);

    // image(image: _textImage);
    final didFindRoom = _generateCircle();
    if (!didFindRoom) {
      noLoop();
    }

    final screenSize = Size(width.toDouble(), height.toDouble());
    for (var circle in _circles) {
      if (circle.isAgainstEdges(screenSize)) {
        circle.stopGrowing();
      }

      if (circle.isGrowing) {
        for (final otherCircle in _circles) {
          if (otherCircle == circle) {
            continue;
          }

          if (circle.overlaps(otherCircle)) {
            circle.stopGrowing();
          }
        }
      }

      circle
        ..paint(this)
        ..grow();
    }
  }

  bool _generateCircle() {
    for (var i = 0; i < _newCirclesPerFrame; i++) {
      late Offset _randomOffset;
      bool overlapsOtherCircle = false;
      int attempts = 0;

      do {
        _randomOffset = _whitePixels[random(_whitePixels.length).floor()];

        overlapsOtherCircle = false;
        for (final circle in _circles) {
          if (circle.contains(_randomOffset)) {
            overlapsOtherCircle = true;
            break;
          }
        }

        attempts += 1;
        if (attempts >= _maxNewCircleAttemps) {
          return false;
        }
      } while (overlapsOtherCircle);

      _circles.add(Circle(offset: _randomOffset, radius: 1));
    }
    return true;
  }
}

class Circle {
  final Offset _offset;

  double _radius;

  int _strokeWeight = 2;

  bool _isGrowing = true;
  Circle({
    required Offset offset,
    required double radius,
  })  : _offset = offset,
        _radius = radius;

  double get radius => _radius;
  Offset get offset => _offset;
  bool get isGrowing => _isGrowing;

  void grow() {
    if (isGrowing) {
      _radius += 0.5;
    }
  }

  void stopGrowing() {
    _isGrowing = false;
  }

  bool isAgainstEdges(Size screenSize) {
    final boundaryRect = Rect.fromCircle(center: _offset, radius: _radius);

    return boundaryRect.left <= 0 ||
        boundaryRect.top <= 0 ||
        boundaryRect.right >= screenSize.width ||
        boundaryRect.bottom >= screenSize.height;
  }

  bool contains(Offset offset) {
    return (offset - _offset).distance <= _radius + _strokeWeight;
  }

  bool overlaps(Circle other) {
    return (_offset - other.offset).distance <= _radius + other.radius;
  }

  void paint(Sketch s) {
    s
      ..strokeWeight(_strokeWeight)
      ..stroke(color: Colors.white)
      ..fill(color: Colors.black)
      ..circle(center: offset, diameter: _radius * 2);
  }
}
