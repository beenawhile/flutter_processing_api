import 'package:example/manual_verification/mouse/mouse_verification.dart';
import 'package:flutter/material.dart';

class ManualVerificationScreen extends StatelessWidget {
  const ManualVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manual Verification"),
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
                      builder: (context) => const MouseVerificationScreen(),
                    ),
                  ),
                  child: const Text("1. Mouse Verification"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
