import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class StarfieldScreen extends StatefulWidget {
  const StarfieldScreen({Key? key}) : super(key: key);

  @override
  State<StarfieldScreen> createState() => _StarfieldScreenState();
}

class _StarfieldScreenState extends State<StarfieldScreen> {
  final _stars = <Star>[];

  @override
  void reassemble() {
    super.reassemble();
    _stars.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
          child: Processing(
        sketch: Sketch.simple(
          setup: (s) {
            s
              ..size(
                width: 1600,
                height: 900,
              )
              ..background(color: Colors.black);

            for (var i = 0; i < 70; i++) {
              _stars.add(
                Star(
                  x: s.random(-s.width / 2, s.width / 2),
                  y: s.random(-s.width / 2, s.width / 2),
                  z: s.random(s.width),
                ),
              );
            }

            for (var i = 0; i < 30; i++) {
              _stars.add(
                Star(
                  x: s.random(-s.width / 2, s.width / 2),
                  y: s.random(-s.width / 2, s.width / 2),
                  z: s.random(s.width),
                  color: Colors.purple,
                ),
              );
            }
          },
          draw: (s) {
            for (var star in _stars) {
              star.update(s);
            }

            for (var star in _stars) {
              star.paintStreak(s, star.color);
            }

            for (var star in _stars) {
              star.paintStar(s, star.color);
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
  Color color;

  Star({
    required this.x,
    required this.y,
    required this.z,
    this.color = Colors.white,
  }) : originalZ = z {
    originalZ = z;
  }

  void update(Sketch s) {
    // 이렇게 임의로 값을 정하는 것을 지양하라
    z -= 5;

    originalZ -= 4.5;

    if (z <= 0) {
      x = s.random(-s.width / 2, s.width / 2);
      y = s.random(-s.height / 2, s.height / 2);
      z = s.random(s.width);
      originalZ = z;
    }
  }

  void paintStreak(Sketch s, [Color? strokeColor]) {
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
        color: strokeColor?.withOpacity(.3) ?? color.withOpacity(.3),
      )
      ..line(
        perspectiveOrigin + center,
        perspectivePosition + center,
      );
  }

  void paintStar(Sketch s, [Color? fillColor]) {
    final center = Offset(s.width / 2, s.height / 2);

    final perspectiveOffset = Offset(
      lerpDouble(0, s.width, x / z)!,
      lerpDouble(0, s.height, y / z)!,
    );

    final diameter = lerpDouble(12, 0, z / s.width)!;

    s
      ..noStroke()
      ..fill(color: fillColor ?? color)
      ..circle(
        center: perspectiveOffset + center,
        diameter: diameter,
      );
  }
}
