import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/data/repositories/auth_repository_impl.dart';

/// Onboarding introduction screen shown after authentication.
///
/// This screen welcomes the authenticated user and explains the upcoming
/// medical intake and concierge questions process before starting the
/// full onboarding flow.
///
/// Features:
/// - Personalized welcome message with user's name
/// - Professional explanation of the intake process
/// - "Start Intake" button to navigate to onboarding
/// - Follows Silent Luxury design aesthetic
class OnboardingIntroScreen extends ConsumerWidget {
  const OnboardingIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Get current user to display their name
    final authRepository = ref.watch(authRepositoryProvider);
    final currentUser = authRepository.currentUser;
    final userName = currentUser?.name ?? 'Guest';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    const SizedBox(height: 48),

                    // Welcome icon
                    Icon(
                      Icons.auto_awesome,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 32),

                    // Personalized welcome title
                    Text(
                      'Welcome, $userName',
                      style: textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Explanation text
                    Text(
                      'To create a personalized transformation journey, we\'ll guide you through a brief intake process.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'This includes medical history questions and concierge preferences to ensure your experience is perfectly tailored to your needs.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Information cards
                    _InfoCard(
                      icon: Icons.favorite_outline,
                      title: 'Medical Intake',
                      description:
                          'Share your health history to ensure safe, effective treatments',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                    const SizedBox(height: 16),

                    _InfoCard(
                      icon: Icons.diamond_outlined,
                      title: 'Concierge Preferences',
                      description:
                          'Personalize your experience with dietary, accommodation, and activity preferences',
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Start intake button (fixed at bottom)
            Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/onboarding');
                  },
                  child: const Text('START INTAKE'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Information card widget for displaying intake process details.
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.colorScheme,
    required this.textTheme,
  });

  final IconData icon;
  final String title;
  final String description;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
