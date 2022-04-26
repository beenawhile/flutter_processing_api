import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class CirclePackingScreen extends StatefulWidget {
  const CirclePackingScreen({Key? key}) : super(key: key);

  @override
  State<CirclePackingScreen> createState() => _CirclePackingScreenState();
}

class _CirclePackingScreenState extends State<CirclePackingScreen> {
  Sketch _sketch = CirclePackingSketch();

  @override
  void reassemble() {
    super.reassemble();
    _sketch = CirclePackingSketch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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

class CirclePackingSketch extends Sketch {
  final List<Circle> _circles = [];
  final _maxNewCircleAttemps = 100;

  final _newCirlcesPerFrame = 5;
  @override
  Future<void> setup() async {
    size(width: 800, height: 400);
  }

  @override
  Future<void> draw() async {
    background(color: Colors.black);

    final didFindRoom = _generateNewCircle();
    if (!didFindRoom) {
      noLoop();
    }

    final screenSize = Size(width.toDouble(), height.toDouble());
    for (final circle in _circles) {
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
        ..grow()
        ..paint(this);
    }
  }

  /// Generates a group of new circles, if there is a room to do so.
  ///
  /// Returns `true` if new circles were added, or `false` if ther
  /// wasn't enough room.
  bool _generateNewCircle() {
    for (var i = 0; i < _newCirlcesPerFrame; i++) {
      late Offset randomOffset;
      bool overlapsOtherCircle = false;
      int attempts = 0;

      do {
        randomOffset = Offset(random(width), random(height));

        overlapsOtherCircle = false;
        for (final circle in _circles) {
          if (circle.contains(randomOffset)) {
            overlapsOtherCircle = true;
            break;
          }
        }
        attempts += 1;
        if (attempts >= _maxNewCircleAttemps) {
          return false;
        }
      } while (overlapsOtherCircle);

      _circles.add(
        Circle(
          offset: randomOffset,
          radius: 1,
        ),
      );
    }
    return true;
  }
}

class Circle {
  Circle({
    required Offset offset,
    required double radius,
  })  : _offset = offset,
        _radius = radius;

  Offset _offset;
  double _radius;
  bool get isGrowing => _isGrowing;
  bool _isGrowing = true;

  int _strokeWeight = 2;

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
    return (other._offset - _offset).distance <= (other._radius + _radius);
  }

  void grow() {
    if (_isGrowing) {
      _radius += 0.5;
    }
  }

  void stopGrowing() {
    _isGrowing = false;
  }

  void paint(Sketch s) {
    s
      ..strokeWeight(_strokeWeight)
      ..stroke(color: Colors.white)
      ..fill(color: Colors.black)
      ..circle(center: _offset, diameter: _radius * 2);
  }
}
