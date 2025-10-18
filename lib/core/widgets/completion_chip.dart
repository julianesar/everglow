import 'package:flutter/material.dart';

/// A premium, elegant chip button for marking tasks as completed.
///
/// Follows the "Silent Luxury" design system with sophisticated animations
/// and refined aesthetics. The chip displays "Mark as completed" text with
/// a subtle checkmark icon.
///
/// Features:
/// - Elegant hover/press animations (scale + opacity)
/// - Disabled state when task is already completed
/// - Smooth transitions (250ms duration)
/// - Proper accessibility with semantic labels
/// - Minimum touch target size (48px height)
class CompletionChip extends StatefulWidget {
  /// Creates a completion chip.
  ///
  /// The [isCompleted] parameter determines the chip's state.
  /// The [onPressed] callback is invoked when the user taps the chip.
  const CompletionChip({
    required this.isCompleted,
    required this.onPressed,
    super.key,
  });

  /// Whether the associated task is already completed.
  final bool isCompleted;

  /// Callback invoked when the chip is tapped.
  ///
  /// Set to null to disable the chip.
  final VoidCallback? onPressed;

  @override
  State<CompletionChip> createState() => _CompletionChipState();
}

class _CompletionChipState extends State<CompletionChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isCompleted && widget.onPressed != null) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDisabled = widget.isCompleted || widget.onPressed == null;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isDisabled
                ? colorScheme.secondary.withValues(alpha: 0.2)
                : colorScheme.primary.withValues(alpha: 0.12),
            border: Border.all(
              color: isDisabled
                  ? colorScheme.secondary.withValues(alpha: 0.3)
                  : colorScheme.primary.withValues(alpha: 0.4),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Checkmark icon with fade-in animation
              AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: widget.isCompleted ? 1.0 : 0.7,
                child: Icon(
                  widget.isCompleted
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  size: 18,
                  color: isDisabled
                      ? colorScheme.secondary.withValues(alpha: 0.6)
                      : colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              // Text label
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: theme.textTheme.labelMedium!.copyWith(
                  color: isDisabled
                      ? colorScheme.secondary.withValues(alpha: 0.6)
                      : colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                child: Text(
                  widget.isCompleted ? 'Completed' : 'Mark as completed',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
