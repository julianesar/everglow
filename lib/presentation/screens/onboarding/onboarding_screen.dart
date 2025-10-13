import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/onboarding_controller.dart';

/// Onboarding screen that introduces users to the app
///
/// Collects user's name and integration statement before proceeding to main app
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Everglow'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Header section
              const SizedBox(height: 32),
              const Icon(
                Icons.wb_sunny,
                size: 64,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              const Text(
                'Let\'s get to know you',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Share a bit about yourself to personalize your experience',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Name input field
              TextField(
                onChanged: controller.updateName,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),

              // Integration statement input field
              TextField(
                onChanged: controller.updateStatement,
                decoration: const InputDecoration(
                  labelText: 'Integration Statement',
                  hintText: 'What do you want to integrate or achieve?',
                  prefixIcon: Icon(Icons.lightbulb_outline),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),

              // Helper text
              Text(
                'Your integration statement helps us tailor your daily reflections and insights.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 32),

              // Submit button
              ElevatedButton(
                onPressed: state.isButtonEnabled
                    ? () async {
                        try {
                          await controller.submitOnboarding();
                          if (context.mounted) {
                            // Navigate to day 1 after successful onboarding
                            context.go('/day/1');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
