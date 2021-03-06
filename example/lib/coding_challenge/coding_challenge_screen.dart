import 'package:flutter/material.dart';

import '1_starfield/starfield_screen.dart';
import '2_purple_rain/purple_rain_screen.dart';
import '3_random_walker/random_walker.dart';
import '4_mitosis/mitosis_screen.dart';
import '5_circle_packing/circle_packing_screen.dart';
import '6_circle_packing_with_text/circle_packing_with_text_screen.dart';
import '7_metaballs/meta_balls_screen.dart';
import '8_phyllotaxis/phyllotaxis_screen.dart';

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
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MitosisScreen(),
                    ),
                  ),
                  child: const Text("4. Mitosis Simulation"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CirclePackingScreen(),
                    ),
                  ),
                  child: const Text("5. Animated Circle Packing"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CirclePackingWithTextScreen(),
                    ),
                  ),
                  child: const Text("6. Animated Circle Packing with Text"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MetaBallsScreen(),
                    ),
                  ),
                  child: const Text("7. Metaballs"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhyllotaxisScreen(),
                    ),
                  ),
                  child: const Text("8. Phyllotaxis"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
