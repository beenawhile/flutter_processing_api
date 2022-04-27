import 'dart:ffi';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter_processing/flutter_processing.dart';

class MetaBallsScreen extends StatefulWidget {
  const MetaBallsScreen({Key? key}) : super(key: key);

  @override
  State<MetaBallsScreen> createState() => _MetaBallsScreenState();
}

class _MetaBallsScreenState extends State<MetaBallsScreen> {
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
        sketch: MetalballSketch(),
      ),
    );
  }
}

class MetalballSketch extends Sketch {
  final _blobCount = 6;
  final _blobRadius = 25.0;
  final _blobSpeed = 5.0;

  final _blobs = <Blob>[];

  @override
  Future<void> setup() async {
    size(width: 400, height: 400);

    for (var i = 0; i < _blobCount; i++) {
      _blobs.add(
        Blob(
          offset: Offset(random(width), random(height)),
          radius: _blobRadius,
          velocity: Offset.fromDirection(random(2 * math.pi), _blobSpeed),
        ),
      );
    }
  }

  @override
  Future<void> draw() async {
    final screenSize = Size(width.toDouble(), height.toDouble());
    background(color: Colors.black);

    // needs to paint pixel by pixel using gpu, shader
    // but there is no way using flutter
    await loadPixels();
    for (int col = 0; col < width; col++) {
      for (int row = 0; row < height; row++) {
        double sum = 0;
        // one pixel unit
        for (final blob in _blobs) {
          final distance =
              (Offset(col.toDouble(), row.toDouble()) - blob.offset).distance;

          // add to brightness
          sum += 0.75 * blob.radius / distance;
          // sum += 600 * blob.radius / distance;
        }

        set(
            x: col,
            y: row,
            color: HSVColor.fromAHSV(1.0, 0.0, 0.0, sum.clamp(0.0, 1.0))
                .toColor());

        // set(
        //     x: col,
        //     y: row,
        //     color: HSVColor.fromAHSV(1.0, sum % 360, 1.0, 1.0).toColor());
      }
    }
    await updatePixels();

    for (var blob in _blobs) {
      blob..move(screenSize);
      // ..paint(this);
    }
  }
}

class Blob {
  Offset _offset;
  double _radius;
  Offset _velocity;

  Blob({
    required Offset offset,
    required double radius,
    required Offset velocity,
  })  : _offset = offset,
        _radius = radius,
        _velocity = velocity;

  Offset get offset => _offset;
  double get radius => _radius;

  void move(Size screenSize) {
    if (_offset.dx <= 0 || _offset.dx >= screenSize.width) {
      _velocity = Offset(-_velocity.dx, _velocity.dy);
    }

    if (_offset.dy <= 0 || _offset.dy >= screenSize.height) {
      _velocity = Offset(_velocity.dx, -_velocity.dy);
    }

    _offset += _velocity;
  }

  void paint(Sketch s) {
    s
      ..strokeWeight(2)
      ..stroke(color: Colors.white)
      ..noFill()
      ..circle(center: _offset, diameter: _radius * 2);
  }
}
