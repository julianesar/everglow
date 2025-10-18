import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';

/// Elegant transition screen shown after completing concierge questions
///
/// This screen provides a smooth transition between the onboarding process
/// and Day 1, with a celebratory animation and welcoming message.
class ConciergeCompletionScreen extends StatefulWidget {
  const ConciergeCompletionScreen({super.key});

  @override
  State<ConciergeCompletionScreen> createState() =>
      _ConciergeCompletionScreenState();
}

class _ConciergeCompletionScreenState extends State<ConciergeCompletionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Fade animation for content
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Scale animation for icon
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Initialize confetti controller
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // Start animations
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _confettiController.play();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _navigateToDay1() {
    context.go('/day/1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Animated icon
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.15),
                          ),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 80,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Animated title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'You\'re All Set!',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Animated subtitle
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Thank you for completing your profile. Your personalized 3-day transformation journey is ready to begin.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Feature highlights
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildFeatureHighlights(context),
                  ),

                  const Spacer(),

                  // Call-to-action button
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ElevatedButton(
                      onPressed: _navigateToDay1,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Begin Day 1',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14159 / 2, // Down
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.3,
              shouldLoop: false,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.tertiary,
                Colors.purple,
                Colors.green,
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build feature highlights section
  Widget _buildFeatureHighlights(BuildContext context) {
    return Column(
      children: [
        _buildFeatureItem(
          context,
          icon: Icons.calendar_today_rounded,
          title: '3-Day Journey',
          description: 'Carefully curated daily experiences',
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(
          context,
          icon: Icons.psychology_rounded,
          title: 'Personalized Insights',
          description: 'Tailored to your unique profile',
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(
          context,
          icon: Icons.auto_awesome_rounded,
          title: 'Transformation Report',
          description: 'Comprehensive analysis at the end',
        ),
      ],
    );
  }

  /// Build a single feature highlight item
  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outline
              .withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.15),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
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
