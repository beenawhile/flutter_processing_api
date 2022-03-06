import 'package:example/coding_challenge/3_random_walker/random_walker.dart';
import 'package:flutter/material.dart';

import '1_starfield/starfield_screen.dart';
import '2_purple_rain/purple_rain_screen.dart';

class CodingChallengeScreen extends StatelessWidget {
  const CodingChallengeScreen({Key? key}) : super(key: key);

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
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RandomWalkerScreen(),
                    ),
                  ),
                  child: const Text("3. Random Walker"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
