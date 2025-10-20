import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../booking/data/repositories/booking_repository_impl.dart';
import '../../../booking/domain/entities/booking.dart';
import '../../../concierge/data/repositories/concierge_repository_impl.dart';
import '../../../concierge/domain/entities/concierge_info.dart';

part 'logistics_hub_controller.g.dart';

/// State class for the Logistics Hub screen.
///
/// Contains all necessary data to render the logistics hub UI,
/// including booking information and optional concierge details
/// depending on whether it's arrival day.
class LogisticsHubState {
  /// Indicates if today is the arrival day (booking start date).
  ///
  /// When true, the UI displays arrival-specific information including
  /// concierge details. When false, shows pre-arrival information.
  final bool isArrivalDay;

  /// The user's active booking information.
  ///
  /// Contains booking dates, check-in status, and other booking details.
  final Booking booking;

  /// Optional concierge information for arrival day.
  ///
  /// Only populated when [isArrivalDay] is true. Contains details about
  /// the assigned driver, villa, and check-in instructions.
  final ConciergeInfo? conciergeInfo;

  /// Indicates whether to show the check-in celebration overlay.
  ///
  /// When true, the celebration overlay is displayed on top of the
  /// Logistics Hub screen with confetti and welcome message.
  final bool showCelebration;

  /// Creates a new [LogisticsHubState] instance.
  const LogisticsHubState({
    required this.isArrivalDay,
    required this.booking,
    this.conciergeInfo,
    this.showCelebration = false,
  });

  /// Creates a copy of this state with the given fields replaced with new values.
  LogisticsHubState copyWith({
    bool? isArrivalDay,
    Booking? booking,
    ConciergeInfo? conciergeInfo,
    bool? showCelebration,
  }) {
    return LogisticsHubState(
      isArrivalDay: isArrivalDay ?? this.isArrivalDay,
      booking: booking ?? this.booking,
      conciergeInfo: conciergeInfo ?? this.conciergeInfo,
      showCelebration: showCelebration ?? this.showCelebration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LogisticsHubState &&
        other.isArrivalDay == isArrivalDay &&
        other.booking == booking &&
        other.conciergeInfo == conciergeInfo &&
        other.showCelebration == showCelebration;
  }

  @override
  int get hashCode {
    return isArrivalDay.hashCode ^
        booking.hashCode ^
        conciergeInfo.hashCode ^
        showCelebration.hashCode;
  }

  @override
  String toString() {
    return 'LogisticsHubState(isArrivalDay: $isArrivalDay, booking: $booking, conciergeInfo: $conciergeInfo, showCelebration: $showCelebration)';
  }
}

/// Controller for managing the Logistics Hub screen state.
///
/// This controller orchestrates the loading of booking and concierge data,
/// determining whether to show arrival-day or pre-arrival information based
/// on the booking dates.
///
/// The controller follows these steps:
/// 1. Retrieves the current authenticated user ID
/// 2. Fetches the user's active booking
/// 3. Determines if today is the arrival day by comparing dates
/// 4. Conditionally fetches concierge information (only on arrival day)
/// 5. Returns a complete [LogisticsHubState] with all necessary data
@riverpod
class LogisticsHubController extends _$LogisticsHubController {
  /// Timer for updating the countdown every second when in pre-arrival mode.
  Timer? _countdownTimer;

  /// Builds the initial state by fetching booking and optional concierge data.
  ///
  /// This method:
  /// 1. Gets the current user ID from [AuthRepository]
  /// 2. Fetches the active booking for the user
  /// 3. Determines if today is arrival day by comparing booking start date
  /// 4. If arrival day, fetches concierge information
  /// 5. Returns a complete [LogisticsHubState]
  /// 6. Starts a timer to update the countdown every second (if pre-arrival)
  ///
  /// Throws an exception if:
  /// - No user is currently authenticated
  /// - No active booking exists for the user
  /// - Repository operations fail
  @override
  Future<LogisticsHubState> build() async {
    // Step 1: Get the current authenticated user
    final authRepository = ref.watch(authRepositoryProvider);
    final currentUser = authRepository.currentUser;

    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }

    // Step 2: Fetch the user's active booking
    final bookingRepository = ref.watch(bookingRepositoryProvider);
    final booking = await bookingRepository.getActiveBookingForUser(currentUser.id);

    if (booking == null) {
      throw Exception('No active booking found for user');
    }

    // Step 3: Determine if today is arrival day
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(
      booking.startDate.year,
      booking.startDate.month,
      booking.startDate.day,
    );

    // Compare dates without time component
    // If today is on or after the start date, it's arrival day or later
    final isArrivalDay = today.isAtSameMomentAs(startDay) || today.isAfter(startDay);

    // Step 4: Conditionally fetch concierge information
    ConciergeInfo? conciergeInfo;
    if (isArrivalDay) {
      final conciergeRepository = ref.watch(conciergeRepositoryProvider);
      conciergeInfo = await conciergeRepository.getConciergeInfo(booking.id);
    }

    // Step 5: Return the complete state
    final initialState = LogisticsHubState(
      isArrivalDay: isArrivalDay,
      booking: booking,
      conciergeInfo: conciergeInfo,
    );

    // Step 6: Start countdown timer if in pre-arrival mode
    if (!isArrivalDay) {
      _startCountdownTimer();
    }

    return initialState;
  }

  /// Manually refreshes the logistics hub state.
  ///
  /// This method can be called to reload booking and concierge data,
  /// useful for pull-to-refresh functionality or when data might have changed.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// Performs the check-in process for the user.
  ///
  /// This method:
  /// 1. Updates the booking's isCheckedIn status to true
  /// 2. Persists the updated booking via the repository
  /// 3. Updates the state to show the celebration overlay
  ///
  /// Throws an exception if the state is not currently loaded or if
  /// the booking update fails.
  Future<void> performCheckIn() async {
    // Ensure we have a valid state with booking data
    final currentState = state.value;
    if (currentState == null) {
      throw Exception('Cannot check in: state not loaded');
    }

    try {
      // Get the booking repository
      final bookingRepository = ref.watch(bookingRepositoryProvider);

      // Create an updated booking with isCheckedIn set to true
      final updatedBooking = currentState.booking.copyWith(isCheckedIn: true);

      // Persist the updated booking
      await bookingRepository.updateBooking(updatedBooking);

      // Update the state to show celebration overlay
      state = AsyncValue.data(
        currentState.copyWith(
          booking: updatedBooking,
          showCelebration: true,
        ),
      );
    } catch (e) {
      // Re-throw the exception to let the UI handle the error
      throw Exception('Failed to check in: $e');
    }
  }

  /// Dismisses the check-in celebration overlay.
  ///
  /// This method updates the state to hide the celebration overlay.
  /// Should be called when the user dismisses the celebration or
  /// when the auto-dismiss timer completes.
  void dismissCelebration() {
    final currentState = state.value;
    if (currentState != null && currentState.showCelebration) {
      state = AsyncValue.data(
        currentState.copyWith(showCelebration: false),
      );
    }
  }

  /// Starts a timer that triggers a state update every second.
  ///
  /// This ensures the countdown timer UI updates in real-time.
  /// The timer automatically checks if we've reached arrival day and
  /// stops updating if so.
  void _startCountdownTimer() {
    // Cancel any existing timer first
    _countdownTimer?.cancel();

    // Create a periodic timer that fires every second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Get the current state value
      final currentState = state.value;
      if (currentState == null) return;

      // Check if we've reached arrival day
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final startDay = DateTime(
        currentState.booking.startDate.year,
        currentState.booking.startDate.month,
        currentState.booking.startDate.day,
      );

      // If we've reached arrival day, refresh the entire state and stop timer
      if (today.isAtSameMomentAs(startDay) || today.isAfter(startDay)) {
        _countdownTimer?.cancel();
        refresh();
        return;
      }

      // Otherwise, just trigger a state rebuild to update the countdown
      // We create a new state object to trigger Riverpod's change detection
      state = AsyncValue.data(currentState.copyWith());
    });

    // Set up cleanup when the provider is disposed
    ref.onDispose(() {
      _countdownTimer?.cancel();
      _countdownTimer = null;
    });
  }
}
