import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_processing/flutter_processing.dart';

class MitosisScreen extends StatefulWidget {
  const MitosisScreen({Key? key}) : super(key: key);

  @override
  State<MitosisScreen> createState() => _MitosisScreenState();
}

class _MitosisScreenState extends State<MitosisScreen> {
  final _cells = <Cell>[];

  @override
  void reassemble() {
    super.reassemble();
    _cells.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Processing(
          sketch: Sketch.simple(
            setup: (s) async {
              s.size(width: 700, height: 700);
              for (int i = 0; i < 10; ++i) {
                _cells.add(Cell.randomLocation(s.width, s.height));
              }
            },
            draw: (s) async {
              s.background(color: const Color.fromARGB(255, 200, 200, 200));

              for (final cell in _cells) {
                cell.move();
                cell.show(s);
              }
            },
            mouseClicked: (s) {
              final newCells = <Cell>[];
              final oldCells = <Cell>[];

              for (final cell in _cells) {
                if (cell.containsPoint(
                    s.mouseX.toDouble(), s.mouseY.toDouble())) {
                  print('splitting cell:');
                  print('- cell position:: ${cell.position}');
                  print('- tap position: ${s.mouseX}, ${s.mouseY}');
                  newCells.add(cell.mitosis());
                  newCells.add(cell.mitosis());

                  oldCells.add(cell);
                }
              }
              // remove "dead" cells
              _cells.removeWhere((element) => oldCells.contains(element));

              // Add new cells
              _cells.addAll(newCells);
            },
          ),
        ),
      ),
    );
  }
}

class Cell {
  Offset position;
  final double radius;
  final Color color;

  Cell({
    required this.position,
    required this.radius,
    required this.color,
  });

  bool containsPoint(double x, double y) {
    final distance = (position - Offset(x, y)).distance;
    print('- distance: $distance');
    return distance <= radius;
  }

  factory Cell.randomLocation(int width, int height) {
    final random = Random();
    return Cell(
      position: Offset(
        random.nextDouble() * width,
        random.nextInt(height).toDouble(),
      ),
      radius: 60,
      color: Color.fromARGB(
          100, random.nextInt(155) + 100, 0, random.nextInt(155) + 100),
    );
  }
  Cell mitosis() {
    return Cell(position: position, radius: radius * 0.8, color: color);
  }

  void move() {
    final randomAngle = Random().nextDouble() * 2 * pi;
    position += Offset.fromDirection(randomAngle, 3);
  }

  void show(Sketch s) {
    s
      ..noStroke()
      ..fill(color: color)
      ..circle(center: position, diameter: radius * 2);
  }
}
