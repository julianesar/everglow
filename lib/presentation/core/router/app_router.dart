import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:everglow_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:everglow_app/presentation/screens/day/day_screen.dart';
import 'package:everglow_app/presentation/screens/report/report_screen.dart';

/// Provider for the app router instance
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Root route - Onboarding
      GoRoute(
        path: '/',
        name: 'onboarding',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
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
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ReportScreen(),
        ),
      ),
    ],

    // Error page for undefined routes
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
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
