import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/entities/journey_status.dart';

/// Splash screen that intelligently redirects users based on their journey status.
///
/// This screen performs the following:
/// 1. Displays a loading indicator while checking user progress
/// 2. Queries [ProgressRepository] to determine journey status
/// 3. Redirects to the appropriate screen:
///    - `/booking` if [JourneyStatus.needsBooking]
///    - `/onboarding-intro` if [JourneyStatus.needsOnboarding]
///    - `/tabs` if user has completed onboarding (awaitingArrival, inProgress, completed)
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
  /// 2. Fetches the [JourneyStatus]
  /// 3. Navigates to the correct route using [GoRouter]
  ///
  /// Navigation logic:
  /// - [JourneyStatus.needsBooking] → `/booking`
  /// - [JourneyStatus.needsOnboarding] → `/onboarding-intro`
  /// - [JourneyStatus.awaitingArrival] → `/tabs` (logistics hub - tab 0)
  /// - [JourneyStatus.inProgress] → `/tabs` (daily journey accessible via tab 1)
  /// - [JourneyStatus.completed] → `/tabs` (all features accessible)
  Future<void> _navigateBasedOnStatus() async {
    // Ensure the widget is still mounted before proceeding
    if (!mounted) return;

    try {
      // Get the progress repository instance
      final progressRepo = await ref.read(progressRepositoryProvider.future);

      // Get the journey status
      final status = await progressRepo.getJourneyStatus();

      // Ensure widget is still mounted before navigating
      if (!mounted) return;

      // Navigate based on the journey status
      switch (status) {
        case JourneyStatus.needsBooking:
          // User is authenticated but doesn't have a booking yet
          context.go('/booking');
          break;

        case JourneyStatus.needsOnboarding:
          // User has a booking but hasn't completed onboarding yet
          context.go('/onboarding-intro');
          break;

        case JourneyStatus.awaitingArrival:
          // User has completed onboarding but hasn't checked in yet
          // Navigate to the main tabs (logistics hub will be accessible there)
          context.go('/tabs');
          break;

        case JourneyStatus.inProgress:
          // User is actively working through the journey
          // Navigate to main tabs (they can access daily journey from there)
          context.go('/tabs');
          break;

        case JourneyStatus.completed:
          // User has completed all three days
          // Navigate to main tabs (they can access hub and other features)
          context.go('/tabs');
          break;
      }
    } catch (e) {
      // If something goes wrong, log the error and navigate to booking as fallback
      debugPrint('Error during splash navigation: $e');
      if (mounted) {
        context.go('/booking');
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
