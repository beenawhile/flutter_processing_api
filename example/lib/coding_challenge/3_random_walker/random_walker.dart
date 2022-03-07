import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class RandomWalkerScreen extends StatefulWidget {
  const RandomWalkerScreen({Key? key}) : super(key: key);

  @override
  State<RandomWalkerScreen> createState() => _RandomWalkerScreenState();
}

class _RandomWalkerScreenState extends State<RandomWalkerScreen> {
  late int x;
  late int y;

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
            setup: (s) async {
              s
                ..size(width: 400, height: 400)
                ..background(color: const Color(0xFF444444));

              x = (s.width / 2).round();
              y = (s.height / 2).round();
            },
            draw: (s) async {
              s
                ..noStroke()
                ..fill(color: Colors.white)
                ..circle(
                  center: Offset(x.toDouble(), y.toDouble()),
                  diameter: 4,
                );

              final randomDirection = Random().nextInt(4);
              switch (randomDirection) {
                case 0:
                  x += 1;
                  break;
                case 1:
                  x -= 1;
                  break;
                case 2:
                  y += 1;
                  break;
                case 3:
                  y -= 1;
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
