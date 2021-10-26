import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

void main() {
  runApp(const FlutterProcessingExampleApp());
}

class FlutterProcessingExampleApp extends StatelessWidget {
  const FlutterProcessingExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Processing Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _stars = <Star>[];

  @override
  void reassemble() {
    super.reassemble();
    _stars.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
          child: Processing(
        sketch: Sketch.simple(
          setup: (s) {
            final width = 1600;
            final height = 900;

            s
              ..size(
                width: width,
                height: height,
              )
              ..background(color: Colors.black);

            for (var i = 0; i < 100; i++) {
              _stars.add(
                Star(
                  x: s.random(-width / 2, width / 2),
                  y: s.random(-width / 2, width / 2),
                  z: s.random(width),
                ),
              );
            }
          },
          draw: (s) {
            for (var star in _stars) {
              star.update(s);
            }

            for (var star in _stars) {
              star.paintStreak(s);
            }

            for (var star in _stars) {
              star.paintStar(s);
            }
          },
        ),
      )),
    );
  }
}

class Star {
  double x, y, z;
  double originalZ;

  Star({
    required this.x,
    required this.y,
    required this.z,
  }) : originalZ = z {
    originalZ = z;
  }

  void update(Sketch s) {
    // 이렇게 임의로 값을 정하는 것을 지양하라
    z -= 30;

    originalZ -= 15;

    if (z <= 0) {
      x = s.random(-s.width / 2, s.width / 2);
      y = s.random(-s.height / 2, s.height / 2);
      z = s.random(s.width);
      originalZ = z;
    }
  }

  void paintStreak(Sketch s) {
    final center = Offset(s.width / 2, s.height / 2);

    final perspectiveOrigin = Offset(
      lerpDouble(0, s.width, x / originalZ)!,
      lerpDouble(0, s.height, y / originalZ)!,
    );

    final perspectivePosition = Offset(
      lerpDouble(0, s.width, x / z)!,
      lerpDouble(0, s.height, y / z)!,
    );

    s
      ..stroke(
        color: Colors.white.withOpacity(.3),
      )
      ..line(
        perspectiveOrigin + center,
        perspectivePosition + center,
      );
  }

  void paintStar(Sketch s) {
    final center = Offset(s.width / 2, s.height / 2);

    final perspectiveOffset = Offset(
      lerpDouble(0, s.width, x / z)!,
      lerpDouble(0, s.height, y / z)!,
    );

    final diameter = lerpDouble(12, 0, z / s.width)!;

    s
      ..noStroke()
      ..fill(color: Colors.white)
      ..circle(
        center: perspectiveOffset + center,
        diameter: diameter,
      );
  }
}
