import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/repositories/booking_repository_impl.dart';

/// Booking screen - allows users to select their transformation dates.
///
/// Features a clean calendar UI for selecting a 3-day transformation retreat.
/// Users select a start date and the system automatically highlights a 3-day range.
class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeEnd;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Transformation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and description
                      Text(
                        'Select Your Start Date',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose when you would like to begin your 3-day transformation journey.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Calendar
                      _buildCalendar(theme, colorScheme),

                      const SizedBox(height: 32),

                      // Selected date range display
                      if (_selectedDay != null) ...[
                        _buildDateRangeCard(theme, textTheme, colorScheme),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Bottom button
            _buildBottomButton(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  /// Builds the calendar widget with custom styling.
  Widget _buildCalendar(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          // Highlight the selected day and the 2 days after it (3-day range)
          if (_selectedDay == null) return false;
          return day.isAtSameMomentAs(_selectedDay!) ||
              (day.isAfter(_selectedDay!) &&
                  day.isBefore(_rangeEnd!.add(const Duration(days: 1))));
        },
        onDaySelected: (selectedDay, focusedDay) {
          // Only allow selection of dates that are not in the past
          if (selectedDay.isBefore(
              DateTime.now().subtract(const Duration(days: 1)))) {
            return;
          }

          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            // Calculate 3-day range
            _rangeEnd = selectedDay.add(const Duration(days: 2));
          });
        },
        enabledDayPredicate: (day) {
          // Disable past dates
          return !day.isBefore(
              DateTime.now().subtract(const Duration(days: 1)));
        },
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: theme.textTheme.titleMedium!,
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: colorScheme.primary,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: colorScheme.primary,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: theme.textTheme.labelSmall!.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          weekendStyle: theme.textTheme.labelSmall!.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        calendarStyle: CalendarStyle(
          // Default day style
          defaultTextStyle: theme.textTheme.bodyMedium!,
          weekendTextStyle: theme.textTheme.bodyMedium!,

          // Disabled (past) day style
          disabledTextStyle: theme.textTheme.bodyMedium!.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),

          // Today style
          todayDecoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          todayTextStyle: theme.textTheme.bodyMedium!.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),

          // Selected day style
          selectedDecoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: theme.textTheme.bodyMedium!.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),

          // Outside month style
          outsideTextStyle: theme.textTheme.bodyMedium!.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),

          // Cell margin
          cellMargin: const EdgeInsets.all(6),
        ),
      ),
    );
  }

  /// Builds the selected date range card.
  Widget _buildDateRangeCard(
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final dateFormat = DateFormat('MMMM d, y');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Transformation',
            style: textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${dateFormat.format(_selectedDay!)} - ${dateFormat.format(_rangeEnd!)}',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '3-day immersive experience',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the bottom confirmation button.
  Widget _buildBottomButton(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _selectedDay == null || _isLoading
              ? null
              : () => _handleConfirmBooking(context),
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor:
                colorScheme.onSurface.withValues(alpha: 0.12),
            disabledForegroundColor:
                colorScheme.onSurface.withValues(alpha: 0.38),
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.onPrimary,
                    ),
                  ),
                )
              : const Text('CONFIRM DATES & CONTINUE'),
        ),
      ),
    );
  }

  /// Handles the booking confirmation and navigation.
  Future<void> _handleConfirmBooking(BuildContext context) async {
    if (_selectedDay == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Save the selected booking date to the provider
      // The user is already authenticated at this point
      ref.read(selectedBookingDateProvider.notifier).setDate(_selectedDay!);

      // Navigate to onboarding intro screen on success
      if (context.mounted) {
        context.go('/onboarding-intro');
      }
    } catch (error) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save booking date. Please try again.',
              style: const TextStyle(fontFamily: 'Satoshi'),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
