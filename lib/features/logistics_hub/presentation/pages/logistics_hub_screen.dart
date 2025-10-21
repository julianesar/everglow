import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../concierge/domain/entities/concierge_info.dart';
import '../../../main_tabs/presentation/controllers/main_tabs_controller.dart';
import '../../../user/data/repositories/user_repository_impl.dart';
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
  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(logisticsHubControllerProvider);
    final userAsyncValue = ref.watch(userRepositoryProvider);

    return Scaffold(
      body: asyncState.when(
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(context, error),
        data: (state) => Stack(
          children: [
            // Main unified content
            userAsyncValue.when(
              data: (userRepo) => FutureBuilder(
                future: userRepo.getUser(),
                builder: (context, snapshot) {
                  final userName = snapshot.data?.name ?? 'Guest';
                  return _buildUnifiedContent(context, ref, state, userName);
                },
              ),
              loading: () => _buildLoadingState(),
              error: (_, __) => _buildUnifiedContent(context, ref, state, 'Guest'),
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
  /// - Pre-arrival information (countdown timer and date) OR
  /// - Arrival logistics (concierge, driver, villa, check-in)
  /// - All in a single scrollable page
  Widget _buildUnifiedContent(
    BuildContext context,
    WidgetRef ref,
    LogisticsHubState state,
    String userName,
  ) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final difference = state.booking.startDate.difference(now);
    final daysUntil = difference.inDays;

    return Column(
      children: [
        // Welcome Header (always visible)
        SafeArea(
          bottom: false,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                  theme.colorScheme.surface,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $userName',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                if (!state.isArrivalDay)
                  Text(
                    daysUntil == 1
                        ? '1 day until your transformation'
                        : '$daysUntil days until your transformation',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.3,
                    ),
                  )
                else
                  Text(
                    'Your transformation begins today',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.3,
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Main scrollable content
        Expanded(
          child: state.isArrivalDay
              ? _buildArrivalContent(context, ref, state, state.conciergeInfo)
              : _buildPreArrivalContent(context, state, difference),
        ),
      ],
    );
  }

  /// Builds the pre-arrival content (before arrival day).
  ///
  /// Displays:
  /// - Centered "Your transformation is booked" message
  /// - Countdown timer to arrival date
  /// - Formatted arrival date
  Widget _buildPreArrivalContent(
    BuildContext context,
    LogisticsHubState state,
    Duration difference,
  ) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 48),

          // Main message
          Text(
            'Your transformation\nis booked.',
            style: theme.textTheme.headlineLarge?.copyWith(
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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            _formatDate(state.booking.startDate),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 48),
        ],
      ),
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
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
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
                _buildTimeUnit(
                  context,
                  days.toString().padLeft(2, '0'),
                  'DAYS',
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
                  ),
                ),

                // Hours
                _buildTimeUnit(
                  context,
                  hours.toString().padLeft(2, '0'),
                  'HOURS',
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
                  ),
                ),

                // Minutes
                _buildTimeUnit(
                  context,
                  minutes.toString().padLeft(2, '0'),
                  'MINS',
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    ':',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
                  ),
                ),

                // Seconds
                _buildTimeUnit(
                  context,
                  seconds.toString().padLeft(2, '0'),
                  'SECS',
                ),
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
            color: theme.colorScheme.primary,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  /// Builds arrival content with arrival logistics information.
  Widget _buildArrivalContent(
    BuildContext context,
    WidgetRef ref,
    LogisticsHubState state,
    ConciergeInfo? concierge,
  ) {
    final theme = Theme.of(context);

    if (concierge == null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _buildNoConciergeInfo(context),
      );
    }

    return Stack(
      children: [
        // Scrollable content
        ListView(
          padding: EdgeInsets.only(
            top: 16,
            left: 24,
            right: 24,
            bottom: !state.booking.isCheckedIn ? 120 : 24,
          ),
          children: [
            // Welcome message for arrival day
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'We are ready for your arrival.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Concierge information card
            _buildConciergeCard(context, concierge),
            const SizedBox(height: 24),

            // Driver information card
            _buildDriverCard(context, concierge),
            const SizedBox(height: 24),

            // Villa information card
            _buildVillaCard(context, concierge),
            const SizedBox(height: 24),

            // Check-in instructions card
            _buildCheckInCard(context, concierge),
          ],
        ),

        // Sticky check-in button at the bottom (only if not checked in yet)
        if (!state.booking.isCheckedIn)
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Concierge',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Concierge photo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      concierge.conciergePhotoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        concierge.conciergeName,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Available 24/7 for your comfort',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          fontStyle: FontStyle.italic,
                        ),
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
              label: Text(concierge.conciergePhone),
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
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
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
