import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class PhyllotaxisScreen extends StatefulWidget {
  const PhyllotaxisScreen({Key? key}) : super(key: key);

  @override
  State<PhyllotaxisScreen> createState() => _PhyllotaxisScreenState();
}

class _PhyllotaxisScreenState extends State<PhyllotaxisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Processing(
        sketch: PhyllotaxisSketch(),
      ),
    );
  }
}

class PhyllotaxisSketch extends Sketch {
  final _dotRadius = 3;
  final _dotDistanceMultiplier = 6;
  int _n = 0;
  @override
  Future<void> setup() async {
    size(width: 400, height: 400);
  }

  @override
  Future<void> draw() async {
    background(color: Colors.black);

    translate(x: width / 2, y: height / 2);

    final baseAngle = _n * 0.3;
    for (var i = 0; i < _n; i++) {
      final angle = i * (137.5 / 360) * (2 * math.pi) + baseAngle;
      final radius = _dotDistanceMultiplier * math.sqrt(i);
      final x = radius * math.cos(angle);
      final y = radius * math.sin(angle);
      final hue = (i / 3) % 360;

      fill(color: HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor());
      noStroke();
      circle(center: Offset(x, y), diameter: _dotRadius * 2);
    }

    _n += 5;

    _n.clamp(0, 100);
  }
}
