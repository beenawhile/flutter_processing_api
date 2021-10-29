import 'package:example/1_starfield/starfield_screen.dart';
import 'package:example/2_purple_rain/purple_rain_screen.dart';
import 'package:flutter/material.dart';

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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Flutter Processing Example"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StarfieldScreen(),
                    ),
                  ),
                  child: const Text("1. Starfield"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PurpleRainScreen(),
                    ),
                  ),
                  child: const Text("2. Purple Rain"),
                ),
              ],
            ),
          )),
        ));
  }
}
