import 'dart:ui';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_processing/flutter_processing.dart';

class ImageVerificationScreen extends StatefulWidget {
  const ImageVerificationScreen({Key? key}) : super(key: key);

  @override
  _ImageVerificationScreenState createState() =>
      _ImageVerificationScreenState();
}

class _ImageVerificationScreenState extends State<ImageVerificationScreen> {
  late Image _loadedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(),
      body: Center(
        child: Processing(
          sketch: Sketch.simple(
            setup: (s) async {
              s.size(width: 500, height: 500);

              _loadedImage = await s.loadImage("assets/images/audio-mixer.png");
            },
            draw: (s) async {
              s.image(
                image: _loadedImage,
              );

              final pixelColor = await s.get(s.mouseX, s.mouseY);

              s
                ..fill(color: pixelColor)
                ..circle(
                    center: Offset(s.mouseX + 20, s.mouseY + 20), diameter: 100)
                ..noStroke();
            },
          ),
        ),
      ),
    );
  }
}
