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
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      backgroundColor: Colors.yellow,
      body: Center(
        child: Processing(
          sketch: Sketch.simple(
            setup: (s) async {
              s.size(width: 500, height: 500);

              _loadedImage = await s.loadImage('assets/images/audio-mixer.png');
            },
            draw: (s) async {
              s.image(
                image: _loadedImage,
              );

              final subImage = await s.getRegion(
                x: 0,
                y: 0,
                width: (s.width / 2).round(),
                height: (s.height / 2).round(),
              );

              await s.loadPixels();

              for (int col = 0; col < 400; ++col) {
                for (int row = 0; row < 400; ++row) {
                  s.set(
                    x: col,
                    y: row,
                    color: const Color(0xFFFF0000),
                  );
                }
              }
              await s.setRegion(image: subImage);

              await s.updatePixels();

              final pixelColor = await s.get(s.mouseX, s.mouseY);

              s
                // ..noStroke()
                ..fill(color: pixelColor)
                ..circle(
                  center: Offset(s.mouseX + 50, s.mouseY + 50),
                  diameter: 100,
                );
            },
          ),
        ),
      ),
    );
  }
}
