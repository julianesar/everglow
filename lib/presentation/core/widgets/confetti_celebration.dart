import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// A widget that displays a celebratory confetti animation.
///
/// This widget is designed to be overlayed on top of other widgets
/// to celebrate task completion in the gamification system.
///
/// Usage:
/// ```dart
/// ConfettiCelebration(
///   controller: _confettiController,
/// )
/// ```
class ConfettiCelebration extends StatelessWidget {
  /// The confetti controller to manage the animation
  final ConfettiController controller;

  /// The direction of the confetti blast
  final double blastDirection;

  /// The number of particles to emit
  final int numberOfParticles;

  /// The minimum blast force
  final double minBlastForce;

  /// The maximum blast force
  final double maxBlastForce;

  /// The gravity force applied to particles
  final double gravity;

  /// Creates a [ConfettiCelebration] widget
  const ConfettiCelebration({
    required this.controller,
    this.blastDirection = pi / 2, // Default: upward
    this.numberOfParticles = 20,
    this.minBlastForce = 5,
    this.maxBlastForce = 15,
    this.gravity = 0.3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirection: blastDirection,
        numberOfParticles: numberOfParticles,
        minBlastForce: minBlastForce,
        maxBlastForce: maxBlastForce,
        gravity: gravity,
        emissionFrequency: 0.05,
        shouldLoop: false,
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
          const Color(0xFFFFD700), // Gold
          Colors.green,
          Colors.purple,
          Colors.pink,
        ],
        createParticlePath: _drawStar,
      ),
    );
  }

  /// Draws a star-shaped particle
  Path _drawStar(Size size) {
    final path = Path();
    final double width = size.width;
    final double height = size.height;
    final double halfWidth = width / 2;
    final double halfHeight = height / 2;

    path.moveTo(halfWidth, 0);
    path.lineTo(halfWidth * 1.3, halfHeight * 1.3);
    path.lineTo(width, halfHeight);
    path.lineTo(halfWidth * 1.3, halfHeight * 1.7);
    path.lineTo(halfWidth, height);
    path.lineTo(halfWidth * 0.7, halfHeight * 1.7);
    path.lineTo(0, halfHeight);
    path.lineTo(halfWidth * 0.7, halfHeight * 1.3);
    path.close();

    return path;
  }
}

/// A mixin that provides confetti celebration functionality.
///
/// This mixin manages the confetti controller lifecycle and provides
/// a method to trigger celebrations.
///
/// Usage:
/// ```dart
/// class MyWidgetState extends State<MyWidget> with ConfettiCelebrationMixin {
///   @override
///   void initState() {
///     super.initState();
///     initConfetti();
///   }
///
///   @override
///   void dispose() {
///     disposeConfetti();
///     super.dispose();
///   }
///
///   void _onTaskCompleted() {
///     celebrate();
///   }
/// }
/// ```
mixin ConfettiCelebrationMixin<T extends StatefulWidget> on State<T> {
  late ConfettiController _confettiController;

  /// Gets the confetti controller
  ConfettiController get confettiController => _confettiController;

  /// Initializes the confetti controller.
  /// Call this in initState().
  void initConfetti() {
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  /// Disposes the confetti controller.
  /// Call this in dispose().
  void disposeConfetti() {
    _confettiController.dispose();
  }

  /// Triggers a celebration animation.
  void celebrate() {
    _confettiController.play();
  }
}

/// A widget that wraps a checkbox with confetti celebration capability.
///
/// This widget shows a checkbox that, when checked, triggers a confetti animation.
/// It's designed specifically for gamification in the DayScreen.
class CelebratoryCheckbox extends StatefulWidget {
  /// Whether the checkbox is currently checked
  final bool value;

  /// Callback when the checkbox value changes
  final ValueChanged<bool?>? onChanged;

  /// Optional widget to display next to the checkbox
  final Widget? child;

  /// Creates a [CelebratoryCheckbox]
  const CelebratoryCheckbox({
    required this.value,
    required this.onChanged,
    this.child,
    super.key,
  });

  @override
  State<CelebratoryCheckbox> createState() => _CelebratoryCheckboxState();
}

class _CelebratoryCheckboxState extends State<CelebratoryCheckbox>
    with ConfettiCelebrationMixin {
  @override
  void initState() {
    super.initState();
    initConfetti();
  }

  @override
  void dispose() {
    disposeConfetti();
    super.dispose();
  }

  void _handleCheckboxChange(bool? newValue) {
    if (newValue == true && !widget.value) {
      // Only celebrate if we're transitioning from unchecked to checked
      celebrate();
    }
    widget.onChanged?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Checkbox(
              value: widget.value,
              onChanged: widget.onChanged != null
                  ? _handleCheckboxChange
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            if (widget.child != null) ...[
              const SizedBox(width: 8),
              Expanded(child: widget.child!),
            ],
          ],
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: ConfettiCelebration(
              controller: confettiController,
              numberOfParticles: 15,
              minBlastForce: 3,
              maxBlastForce: 8,
            ),
          ),
        ),
      ],
    );
  }
}
