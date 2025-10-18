import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Welcome screen - the app's landing page.
///
/// Displays a luxury hero image with headline and call-to-action button
/// aligned with the "Silent Luxury" brand aesthetic.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Sophisticated gradient background
          // TODO: Replace with luxury hero image (assets/images/welcome_hero.jpg)
          // showing villa overlooking ocean
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A1A1A),
                  const Color(0xFF121212),
                  colorScheme.primary.withValues(alpha: 0.1),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // Subtle pattern overlay for depth
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // Content - headline and CTA button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Main headline
                  Text(
                    'A Luxury Retreat To Upgrade Your Body, Beauty, & Longevity',
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 20.0,
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 1),

                  // CTA Button
                  ElevatedButton(
                    onPressed: () => context.go('/booking'),
                    child: const Text('BEGIN YOUR TRANSFORMATION'),
                  ),

                  const Spacer(flex: 2),

                  // Subtle brand tagline
                  Text(
                    'Regenerative Medicine Retreat',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary.withValues(alpha: 0.8),
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
