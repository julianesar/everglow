import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';

/// Celebratory screen shown after check-in completion.
///
/// Features:
/// - Animated checkmark icon
/// - Confetti celebration
/// - Auto-navigation to day 1 after 3-4 seconds
/// - Silent Luxury design aesthetic
class CheckInCelebrationScreen extends StatefulWidget {
  const CheckInCelebrationScreen({super.key});

  @override
  State<CheckInCelebrationScreen> createState() =>
      _CheckInCelebrationScreenState();
}

class _CheckInCelebrationScreenState extends State<CheckInCelebrationScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _checkmarkController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize confetti controller
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Initialize checkmark animation controller
    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Scale animation for checkmark (starts small, grows to size)
    _scaleAnimation = CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    );

    // Opacity animation for checkmark (fades in)
    _opacityAnimation = CurvedAnimation(
      parent: _checkmarkController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    );

    // Start animations immediately
    _confettiController.play();
    _checkmarkController.forward();

    // Navigate to day 1 after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        context.go('/day/1');
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _checkmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface,
                  colorScheme.surface.withValues(alpha: 0.95),
                  colorScheme.primary.withValues(alpha: 0.15),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated checkmark icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 72,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Celebratory text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Welcome!',
                    style: textTheme.displayMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Your journey begins now.',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Confetti overlay (centered at top)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // Downward
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 15,
              minBlastForce: 5,
              gravity: 0.3,
              colors: [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.7),
                colorScheme.onSurface.withValues(alpha: 0.5),
                colorScheme.onSurface.withValues(alpha: 0.3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
