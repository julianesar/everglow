import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

/// Overlay widget shown after successful check-in.
///
/// This widget appears as an overlay on top of the Logistics Hub screen,
/// featuring:
/// - Animated checkmark icon
/// - Confetti celebration
/// - Welcome message
/// - Auto-dismiss after 3.5 seconds
/// - Manual dismiss via button
///
/// After dismissal, it triggers the [onDismiss] callback to navigate
/// to the Journey tab.
class CheckInCelebrationOverlay extends StatefulWidget {
  /// Callback invoked when the celebration is dismissed.
  final VoidCallback onDismiss;

  const CheckInCelebrationOverlay({
    super.key,
    required this.onDismiss,
  });

  @override
  State<CheckInCelebrationOverlay> createState() =>
      _CheckInCelebrationOverlayState();
}

class _CheckInCelebrationOverlayState extends State<CheckInCelebrationOverlay>
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

    // Auto-dismiss after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        widget.onDismiss();
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

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Semi-transparent backdrop
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface.withValues(alpha: 0.95),
                  colorScheme.surface.withValues(alpha: 0.98),
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

          // Bottom button
          Positioned(
            left: 32,
            right: 32,
            bottom: 48,
            child: SafeArea(
              child: ElevatedButton(
                onPressed: widget.onDismiss,
                child: const Text('GET STARTED'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
