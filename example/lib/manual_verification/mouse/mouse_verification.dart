import 'package:flutter/material.dart';
import 'package:flutter_processing/flutter_processing.dart';

class MouseVerificationScreen extends StatelessWidget {
  const MouseVerificationScreen({Key? key}) : super(key: key);

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
              },
              draw: (s) async {},
              mouseMoved: (s) {
                print(
                  "mouseMoved - current position: (${s.mouseX}, ${s.mouseY}), \nprevious position: (${s.pmouseX}, ${s.pmouseY}),",
                );
              },
              mousePressed: (s) {
                print(
                  "mousePressed - current position: (${s.mouseX}, ${s.mouseY}), \nprevious position: (${s.pmouseX}, ${s.pmouseY}),",
                );
              },
              mouseDragged: (s) {
                print(
                  "mouseDragged - current position: (${s.mouseX}, ${s.mouseY}), \nprevious position: (${s.pmouseX}, ${s.pmouseY}),",
                );
              },
              mouseReleased: (s) {
                print(
                  "mouseReleased - current position: (${s.mouseX}, ${s.mouseY}), \nprevious position: (${s.pmouseX}, ${s.pmouseY}),",
                );
              },
              mouseClicked: (s) {
                print(
                  "mouseClicked - current position: (${s.mouseX}, ${s.mouseY}), \nprevious position: (${s.pmouseX}, ${s.pmouseY}),",
                );
              },
              mouseWheel: (s, count) {
                print(
                  "mouseWheel - count: $count",
                );
              }),
        ),
      ),
    );
  }
}
