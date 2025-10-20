import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:everglow_app/features/welcome/presentation/pages/welcome_screen.dart';
import 'package:everglow_app/features/booking/presentation/pages/booking_screen.dart';
import 'package:everglow_app/features/splash/presentation/pages/splash_screen.dart';
import 'package:everglow_app/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:everglow_app/features/onboarding/presentation/pages/onboarding_intro_screen.dart';
import 'package:everglow_app/features/daily_journey/presentation/pages/day_screen.dart';
import 'package:everglow_app/features/report/presentation/pages/report_screen.dart';
import 'package:everglow_app/features/hub/presentation/pages/hub_screen.dart';
import 'package:everglow_app/features/auth/presentation/pages/auth_screen.dart';
import 'package:everglow_app/features/main_tabs/presentation/pages/main_tabs_screen.dart';
import 'package:everglow_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:everglow_app/core/router/auth_notifier.dart';

/// Provider for the app router instance
final appRouterProvider = Provider<GoRouter>((ref) {
  // Get the auth notifier that will trigger router refreshes
  final authNotifier = ref.watch(authNotifierProvider);

  // Get the auth repository for checking current user state
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/',
    // Listen to auth state changes and refresh routes automatically
    refreshListenable: authNotifier,
    // Redirect logic - acts as the gatekeeper for protected routes
    redirect: (context, state) {
      // Get the current authenticated user synchronously
      final currentUser = authRepository.currentUser;

      // Get the location the user is trying to access
      final targetLocation = state.matchedLocation;

      // Public routes that don't require authentication
      final publicRoutes = ['/', '/booking', '/auth'];

      // Rule 1: User is NOT logged in AND trying to access a protected page
      // Redirect to /auth
      if (currentUser == null && !publicRoutes.contains(targetLocation)) {
        return '/auth';
      }

      // Rule 2: User IS logged in AND on the auth page
      // Redirect to /onboarding-intro (transition screen before onboarding)
      if (currentUser != null && targetLocation == '/auth') {
        return '/onboarding-intro';
      }

      // Rule 3: Allow navigation in all other cases
      return null;
    },
    routes: [
      // Welcome landing page (public)
      GoRoute(
        path: '/',
        name: 'welcome',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const WelcomeScreen()),
      ),

      // Booking screen (public)
      GoRoute(
        path: '/booking',
        name: 'booking',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const BookingScreen()),
      ),

      // Authentication route
      GoRoute(
        path: '/auth',
        name: 'auth',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const AuthScreen()),
      ),

      // Splash screen that handles intelligent navigation
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SplashScreen()),
      ),

      // Onboarding intro route - transition screen after auth
      GoRoute(
        path: '/onboarding-intro',
        name: 'onboarding-intro',
        pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey, child: const OnboardingIntroScreen()),
      ),

      // Onboarding route
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const OnboardingScreen()),
      ),

      // Day itinerary route with path parameter
      GoRoute(
        path: '/day/:dayId',
        name: 'day',
        pageBuilder: (context, state) {
          final dayId = state.pathParameters['dayId']!;
          return MaterialPage(
            key: state.pageKey,
            child: DayScreen(dayId: dayId),
          );
        },
      ),

      // Report route
      GoRoute(
        path: '/report',
        name: 'report',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const ReportScreen()),
      ),

      // Hub route - Transformation hub for completed journeys
      GoRoute(
        path: '/hub',
        name: 'hub',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const HubScreen()),
      ),

      // Logistics Hub route - Redirects to main tabs with Logistics tab selected
      // This ensures LogisticsHub is always shown within the tab navigation
      GoRoute(
        path: '/logistics-hub',
        name: 'logistics-hub',
        redirect: (context, state) => '/tabs?tab=0',
      ),

      // Main tabs route - For authenticated users who completed onboarding
      // Supports optional query parameter 'tab' to specify initial tab (0, 1, or 2)
      // Example: /tabs?tab=0 (Logistics), /tabs?tab=1 (Journey), /tabs?tab=2 (Profile)
      GoRoute(
        path: '/tabs',
        name: 'tabs',
        pageBuilder: (context, state) {
          // Parse the 'tab' query parameter, default to 0 if not provided or invalid
          final tabParam = state.uri.queryParameters['tab'];
          final initialTab = int.tryParse(tabParam ?? '') ?? 0;

          return MaterialPage(
            key: state.pageKey,
            child: MainTabsScreen(initialTab: initialTab),
          );
        },
      ),
    ],

    // Error page for undefined routes
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Page not found',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
});
