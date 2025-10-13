import 'package:flutter/material.dart';

/// Onboarding screen that introduces users to the app
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding'),
      ),
      body: const Center(
        child: Text(
          'Onboarding Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
