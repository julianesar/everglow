import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A navigable timeline widget that allows users to navigate between days.
///
/// Displays the current day number with left and right navigation buttons.
/// Navigation buttons are automatically disabled at the boundaries (day 1 and day 3).
///
/// This widget supports two navigation modes:
/// 1. Callback-based (for in-tab navigation): Provide [onNavigateToDay]
/// 2. Router-based (for standalone navigation): Uses GoRouter when callback is null
class TimelineNavigator extends StatelessWidget {
  /// The current day number (1-3).
  final int currentDay;

  /// Optional callback for navigating to a specific day.
  /// When provided, this callback is used instead of GoRouter navigation.
  /// This allows navigation to stay within a tab context.
  final void Function(int day)? onNavigateToDay;

  /// Creates a [TimelineNavigator].
  ///
  /// The [currentDay] parameter must be between 1 and 3 inclusive.
  /// If [onNavigateToDay] is provided, it will be used for navigation.
  /// Otherwise, GoRouter navigation will be used.
  const TimelineNavigator({
    super.key,
    required this.currentDay,
    this.onNavigateToDay,
  }) : assert(
          currentDay >= 1 && currentDay <= 3,
          'currentDay must be between 1 and 3',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canGoPrevious = currentDay > 1;
    final canGoNext = currentDay < 3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous day button
        IconButton(
          onPressed: canGoPrevious
              ? () {
                  if (onNavigateToDay != null) {
                    // Use callback-based navigation (stays in tab)
                    onNavigateToDay!(currentDay - 1);
                  } else {
                    // Use router-based navigation (full-screen)
                    context.go('/day/${currentDay - 1}');
                  }
                }
              : null,
          icon: const Icon(Icons.chevron_left),
          tooltip: canGoPrevious ? 'Previous day' : null,
        ),

        const SizedBox(width: 16),

        // Current day text
        Text(
          'DAY $currentDay OF 3',
          style: theme.textTheme.titleLarge?.copyWith(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(width: 16),

        // Next day button
        IconButton(
          onPressed: canGoNext
              ? () {
                  if (onNavigateToDay != null) {
                    // Use callback-based navigation (stays in tab)
                    onNavigateToDay!(currentDay + 1);
                  } else {
                    // Use router-based navigation (full-screen)
                    context.go('/day/${currentDay + 1}');
                  }
                }
              : null,
          icon: const Icon(Icons.chevron_right),
          tooltip: canGoNext ? 'Next day' : null,
        ),
      ],
    );
  }
}
