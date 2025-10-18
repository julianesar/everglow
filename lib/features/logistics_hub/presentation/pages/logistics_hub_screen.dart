import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../concierge/domain/entities/concierge_info.dart';
import '../controllers/logistics_hub_controller.dart';

/// Main screen for the Logistics Hub.
///
/// This screen displays different UI states based on whether the user
/// is waiting for their arrival date (pre-arrival mode) or has reached
/// their arrival date (arrival mode).
///
/// **Pre-Arrival Mode (isArrivalDay == false):**
/// - Serene background with centered message
/// - Elegant countdown timer showing time until arrival
/// - Formatted start date display
///
/// **Arrival Mode (isArrivalDay == true):**
/// - Welcome message
/// - Concierge information (driver, villa, check-in instructions)
/// - Call-to-action buttons
class LogisticsHubScreen extends ConsumerWidget {
  const LogisticsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(logisticsHubControllerProvider);

    return Scaffold(
      body: asyncState.when(
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(context, error),
        data: (state) => state.isArrivalDay
            ? _buildArrivalMode(context, ref, state)
            : _buildWaitingMode(context, state),
      ),
    );
  }

  /// Builds the loading state with a centered progress indicator.
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB89A6A)),
      ),
    );
  }

  /// Builds the error state with an error message.
  Widget _buildErrorState(BuildContext context, Object error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the waiting mode UI (before arrival day).
  ///
  /// Displays:
  /// - Serene background image
  /// - Centered "Your transformation is booked" message
  /// - Countdown timer to arrival date
  /// - Formatted arrival date
  Widget _buildWaitingMode(BuildContext context, LogisticsHubState state) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final difference = state.booking.startDate.difference(now);

    return Stack(
      children: [
        // Background with gradient (fallback if image not available)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A0A0A),
                  const Color(0xFF1A1A1A),
                  const Color(0xFF121212),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Optional background image overlay
        // Note: Image file should be added to assets/images/serene_background.jpg
        // See assets/images/README.md for details
        Positioned.fill(
          child: Image.asset(
            'assets/images/serene_background.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Return transparent container if image doesn't exist
              return const SizedBox.shrink();
            },
            color: Colors.black.withValues(alpha: 0.4),
            colorBlendMode: BlendMode.darken,
          ),
        ),

        // Content
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main message
                  Text(
                    'Your transformation\nis booked.',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: const Color(0xFFF5F5F0),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 64),

                  // Countdown timer
                  _buildCountdownTimer(context, difference),

                  const SizedBox(height: 48),

                  // Arrival date message
                  Text(
                    'We await your arrival on',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFF5F5F0).withValues(alpha: 0.8),
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    _formatDate(state.booking.startDate),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFB89A6A),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the countdown timer display.
  Widget _buildCountdownTimer(BuildContext context, Duration difference) {
    final theme = Theme.of(context);
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF121212).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFB89A6A).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Days
                _buildTimeUnit(context, days.toString().padLeft(2, '0'), 'DAYS'),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: const Color(0xFFB89A6A),
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
                  ),
                ),

                // Hours
                _buildTimeUnit(context, hours.toString().padLeft(2, '0'), 'HOURS'),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: const Color(0xFFB89A6A),
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
                  ),
                ),

                // Minutes
                _buildTimeUnit(context, minutes.toString().padLeft(2, '0'), 'MINS'),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: const Color(0xFFB89A6A),
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
                  ),
                ),

                // Seconds
                _buildTimeUnit(context, seconds.toString().padLeft(2, '0'), 'SECS'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single time unit display (days, hours, minutes, or seconds).
  Widget _buildTimeUnit(BuildContext context, String value, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.displayMedium?.copyWith(
            color: const Color(0xFFF5F5F0),
            fontWeight: FontWeight.w300,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: const Color(0xFFB89A6A),
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  /// Builds the arrival mode UI (on or after arrival day).
  ///
  /// Displays:
  /// - Emotional header with "Today is the Day" message
  /// - Driver information with call button
  /// - Villa information with image
  /// - Check-in instructions
  /// - Sticky check-in button at the bottom
  Widget _buildArrivalMode(BuildContext context, WidgetRef ref, LogisticsHubState state) {
    final theme = Theme.of(context);
    final concierge = state.conciergeInfo;

    return Stack(
      children: [
        // Scrollable content
        ListView(
          padding: EdgeInsets.only(
            top: 0,
            left: 24,
            right: 24,
            bottom: !state.booking.isCheckedIn ? 120 : 24, // Extra padding for sticky button
          ),
          children: [
            // Emotional Header
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 48, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today is the Day!',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to EverGlow. We are ready for your arrival.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 18,
                        height: 1.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (concierge != null) ...[
              // Driver information card
              _buildDriverCard(context, concierge),
              const SizedBox(height: 24),

              // Villa information card
              _buildVillaCard(context, concierge),
              const SizedBox(height: 24),

              // Check-in instructions card
              _buildCheckInCard(context, concierge),
            ] else ...[
              // Fallback if no concierge info
              _buildNoConciergeInfo(context),
            ],
          ],
        ),

        // Sticky check-in button at the bottom (only if not checked in yet)
        if (concierge != null && !state.booking.isCheckedIn)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, -4),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(logisticsHubControllerProvider.notifier).performCheckIn(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text('Confirm Arrival & Check In'),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the driver information card.
  Widget _buildDriverCard(BuildContext context, ConciergeInfo concierge) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Driver',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        concierge.driverName,
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement phone call functionality
              },
              icon: const Icon(Icons.phone_outlined),
              label: Text(concierge.driverPhone),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the villa information card.
  Widget _buildVillaCard(BuildContext context, ConciergeInfo concierge) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Villa image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              concierge.villaImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: theme.colorScheme.surface,
                  child: Center(
                    child: Icon(
                      Icons.home_outlined,
                      size: 64,
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                );
              },
            ),
          ),

          // Villa details
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Villa',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        concierge.villaAddress,
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the check-in instructions card.
  Widget _buildCheckInCard(BuildContext context, ConciergeInfo concierge) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Check-In Instructions',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              concierge.checkInInstructions,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Builds a fallback message when no concierge info is available.
  Widget _buildNoConciergeInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.pending_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Your arrival details are being prepared',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Please check back shortly',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Formats a date in a human-readable format.
  String _formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, y').format(date);
  }
}
