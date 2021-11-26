import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_processing/flutter_processing.dart';

class PurpleRainScreen extends StatefulWidget {
  const PurpleRainScreen({Key? key}) : super(key: key);

  @override
  _PurpleRainScreenState createState() => _PurpleRainScreenState();
}

class _PurpleRainScreenState extends State<PurpleRainScreen> {
  final _droplets = <Droplet>[];

  @override
  void reassemble() {
    super.reassemble();
    _droplets.clear();
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
          clipBehavior: Clip.hardEdge,
          sketch: Sketch.simple(
            setup: (s) {
              s
                ..size(
                  width: 640,
                  height: 360,
                )
                ..background(
                  color: const Color.fromARGB(255, 200, 175, 220),
                );

              for (var i = 0; i < 100; i++) {
                // TODO: 사이즈 문제 해결하기
                final width = 640;
                final height = 360;

                _droplets.add(
                  Droplet(
                    x: s.random(width),
                    y: s.random(-height, 0),
                    z: s.random(1),
                    length: 20,
                  ),
                );
              }
            },
            draw: (s) {
              for (final droplet in _droplets) {
                droplet
                  ..show(s)
                  ..fall(s);
              }
            },
          ),
        ),
      ),
    );
  }
}

class Droplet {
  double x;
  double y;
  double z;
  double length;

  Droplet({
    required this.x,
    required this.y,
    required this.z,
    required this.length,
  });

  void fall(Sketch s) {
    y += lerpDouble(8, 20, z)!;

    if (y >= s.height - length) {
      y = 0;
      z = s.random(1);
    }
  }

  void show(Sketch s) {
    final perspectiveLength = lerpDouble(0.2 * length, length, z)!;

    s
      ..stroke(
        // TODO: stroke width 설정하는 메소드 만들기
        color: const Color.fromARGB(255, 128, 43, 226),
      )
      ..line(
        Offset(x, y),
        Offset(x, y + perspectiveLength),
      );
  }
}
