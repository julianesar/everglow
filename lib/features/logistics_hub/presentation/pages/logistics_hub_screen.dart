import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../concierge/domain/entities/concierge_info.dart';
import '../../../main_tabs/presentation/controllers/main_tabs_controller.dart';
import '../../../user/presentation/controllers/user_controller.dart';
import '../controllers/logistics_hub_controller.dart';
import '../widgets/check_in_celebration_overlay.dart';

/// Main screen for the Logistics Hub.
///
/// This unified screen displays:
/// - Welcome header with user name and countdown
/// - Pre-arrival information (when before arrival date)
/// - Arrival logistics (when on or after arrival date)
/// - All content is integrated into a single scrollable page
class LogisticsHubScreen extends ConsumerStatefulWidget {
  const LogisticsHubScreen({super.key});

  @override
  ConsumerState<LogisticsHubScreen> createState() => _LogisticsHubScreenState();
}

class _LogisticsHubScreenState extends ConsumerState<LogisticsHubScreen> {
  /// Formats a date range for display (e.g., "Monday, November 24, 2025 - Thursday, November 27, 2025")
  String _formatDateRange(DateTime startDate, DateTime endDate) {
    final monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final startDay = dayNames[startDate.weekday - 1];
    final startMonth = monthNames[startDate.month - 1];
    final endDay = dayNames[endDate.weekday - 1];
    final endMonth = monthNames[endDate.month - 1];

    return '$startDay, $startMonth ${startDate.day}, ${startDate.year} -\n$endDay, $endMonth ${endDate.day}, ${endDate.year}';
  }

  /// Builds the retreat dates card with dark background
  Widget _buildRetreatDatesCard(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Pre-Arrival Information',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and title row
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Retreat Dates',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Date range text
              Text(
                _formatDateRange(startDate, endDate),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(logisticsHubControllerProvider);
    final userAsyncValue = ref.watch(userControllerProvider);

    return Scaffold(
      body: asyncState.when(
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(context, error),
        data: (state) => Stack(
          children: [
            // Main unified content
            userAsyncValue.when(
              data: (user) {
                final userName = user?.name ?? 'Guest';
                return _buildUnifiedContent(context, ref, state, userName);
              },
              loading: () => _buildLoadingState(),
              error: (_, __) =>
                  _buildUnifiedContent(context, ref, state, 'Guest'),
            ),

            // Celebration overlay (shown after check-in)
            if (state.showCelebration)
              CheckInCelebrationOverlay(
                onDismiss: () {
                  // Dismiss the celebration overlay
                  ref
                      .read(logisticsHubControllerProvider.notifier)
                      .dismissCelebration();

                  // Switch to Journey tab (index 1)
                  ref.read(mainTabsControllerProvider.notifier).setTab(1);
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the loading state with a centered progress indicator.
  Widget _buildLoadingState() {
    return Builder(
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      },
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
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
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

  /// Builds the unified content for the Logistics Hub.
  ///
  /// Displays:
  /// - Welcome header with user name and days countdown
  /// - "Your transformation is booked" message
  /// - Countdown timer (if before arrival) or arrival message
  /// - Arrival logistics (concierge, driver, villa, check-in) - always visible
  /// - All in a single scrollable page
  Widget _buildUnifiedContent(
    BuildContext context,
    WidgetRef ref,
    LogisticsHubState state,
    String userName,
  ) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    // Normalize dates to midnight for accurate day calculation
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(
      state.booking.startDate.year,
      state.booking.startDate.month,
      state.booking.startDate.day,
    );

    final difference = startDay.difference(today);
    // If less than 24 hours but still in the future, show at least 1 day
    final daysUntil = difference.inDays > 0
        ? difference.inDays
        : (difference.isNegative ? 0 : 1);

    return Column(
      children: [
        // Welcome Header (fixed - only name and countdown)
        SafeArea(
          bottom: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome text
                Text(
                  'Welcome, $userName',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                // Days countdown
                if (!state.isArrivalDay)
                  Text(
                    daysUntil == 1
                        ? '1 day until your transformation'
                        : '$daysUntil days until your transformation',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  )
                else
                  Text(
                    'Your transformation begins today',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Main scrollable content - merged view
        Expanded(child: _buildMergedContent(context, ref, state)),
      ],
    );
  }

  /// Builds the merged content showing retreat dates and logistics info.
  ///
  /// Displays:
  /// - Pre-Arrival Information and Retreat Dates card
  /// - Arrival logistics (concierge, driver, villa, check-in) - always visible
  Widget _buildMergedContent(
    BuildContext context,
    WidgetRef ref,
    LogisticsHubState state,
  ) {
    final theme = Theme.of(context);
    final concierge = state.conciergeInfo;

    return Stack(
      children: [
        // Scrollable content
        ListView(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: !state.booking.isCheckedIn ? 120 : 24,
          ),
          children: [
            // Retreat dates card
            _buildRetreatDatesCard(
              context,
              state.booking.startDate,
              state.booking.endDate,
            ),
            const SizedBox(height: 32),

            // Logistics information (always visible)
            // Concierge information card
            _buildConciergeCard(context, concierge),
            const SizedBox(height: 16),

            // Driver information card
            _buildDriverCard(context, concierge),
            const SizedBox(height: 16),

            // Villa information card
            _buildVillaCard(context, concierge),
            const SizedBox(height: 16),

            // Check-in instructions card
            _buildCheckInCard(context, concierge),
          ],
        ),

        // Sticky check-in button at the bottom (only if arrival day and not checked in)
        if (state.isArrivalDay && !state.booking.isCheckedIn)
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
                      ref
                          .read(logisticsHubControllerProvider.notifier)
                          .performCheckIn();
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

  /// Builds the concierge information card.
  Widget _buildConciergeCard(BuildContext context, ConciergeInfo concierge) {
    final theme = Theme.of(context);
    final conciergeName = concierge.conciergeName ?? '---';
    final conciergePhone = concierge.conciergePhone ?? '---';

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
                        'Your Concierge',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(conciergeName, style: theme.textTheme.titleLarge),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: conciergePhone != '---'
                  ? () {
                      // TODO: Implement phone call functionality
                    }
                  : null,
              icon: const Icon(Icons.phone_outlined),
              label: Text(conciergePhone),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the driver information card.
  Widget _buildDriverCard(BuildContext context, ConciergeInfo concierge) {
    final theme = Theme.of(context);
    final driverName = concierge.driverName ?? '---';
    final driverPhone = concierge.driverPhone ?? '---';

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
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(driverName, style: theme.textTheme.titleLarge),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: driverPhone != '---'
                  ? () {
                      // TODO: Implement phone call functionality
                    }
                  : null,
              icon: const Icon(Icons.phone_outlined),
              label: Text(driverPhone),
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
    final villaAddress = concierge.villaAddress ?? '---';
    final villaImageUrl = concierge.villaImageUrl;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Villa image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: villaImageUrl != null
                ? Image.network(
                    villaImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.colorScheme.surface,
                        child: Center(
                          child: Icon(
                            Icons.home_outlined,
                            size: 64,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    color: theme.colorScheme.surface,
                    child: Center(
                      child: Icon(
                        Icons.home_outlined,
                        size: 64,
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
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
                        villaAddress,
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
    final checkInInstructions = concierge.checkInInstructions ?? '---';

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
              checkInInstructions,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
