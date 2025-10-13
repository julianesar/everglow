import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/progress_repository.dart';
import '../../../domain/models/journey_status.dart';

/// Splash screen that intelligently redirects users based on their journey status.
///
/// This screen performs the following:
/// 1. Displays a loading indicator while checking user progress
/// 2. Queries [ProgressRepository] to determine journey status and current day
/// 3. Redirects to the appropriate screen:
///    - `/onboarding` if [JourneyStatus.needsOnboarding]
///    - `/day/X` if [JourneyStatus.inProgress] (where X is the current day + 1)
///    - `/hub` if [JourneyStatus.completed]
///
/// The redirection is near-instantaneous once the status is determined.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start the navigation logic as soon as the screen initializes
    _navigateBasedOnStatus();
  }

  /// Determines the user's journey status and navigates to the appropriate screen.
  ///
  /// This method:
  /// 1. Waits for the [ProgressRepository] to be available
  /// 2. Fetches the [JourneyStatus] and current day
  /// 3. Navigates to the correct route using [GoRouter]
  ///
  /// Navigation logic:
  /// - [JourneyStatus.needsOnboarding] → `/onboarding`
  /// - [JourneyStatus.inProgress] → `/day/X` where X = currentDay + 1
  /// - [JourneyStatus.completed] → `/hub`
  Future<void> _navigateBasedOnStatus() async {
    // Ensure the widget is still mounted before proceeding
    if (!mounted) return;

    try {
      // Get the progress repository instance
      final progressRepo = await ref.read(progressRepositoryProvider.future);

      // Get the journey status and current day in parallel for efficiency
      final results = await Future.wait([
        progressRepo.getJourneyStatus(),
        progressRepo.getCurrentDay(),
      ]);

      final status = results[0] as JourneyStatus;
      final currentDay = results[1] as int;

      // Ensure widget is still mounted before navigating
      if (!mounted) return;

      // Navigate based on the journey status
      switch (status) {
        case JourneyStatus.needsOnboarding:
          // User hasn't completed onboarding yet
          context.go('/onboarding');
          break;

        case JourneyStatus.inProgress:
          // User is actively working through the journey
          // Navigate to the next day they should work on (currentDay + 1)
          // If currentDay is 0, they start at day 1
          // If currentDay is 1, they go to day 2, etc.
          final nextDay = currentDay + 1;
          context.go('/day/$nextDay');
          break;

        case JourneyStatus.completed:
          // User has completed all three days
          // Navigate to the hub screen
          context.go('/hub');
          break;
      }
    } catch (e) {
      // If something goes wrong, log the error and navigate to onboarding as fallback
      debugPrint('Error during splash navigation: $e');
      if (mounted) {
        context.go('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Display a simple loading screen with centered circular progress indicator
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          // Use theme color for consistency
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
