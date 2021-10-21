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
  Offset _circleOffset = Offset(400, 250);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
          child: Processing(
        sketch: Sketch.simple(
          setup: (s) {
            s.size(
              width: 800,
              height: 800,
            );
          },
          draw: (s) {},
        ),
      )),
    );
  }
}
