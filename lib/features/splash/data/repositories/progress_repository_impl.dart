import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../user/data/models/user_model.dart';
import '../../../user/domain/repositories/user_repository.dart';
import '../../../user/data/repositories/user_repository_impl.dart';
import '../../../journal/data/models/daily_log_model.dart';
import '../../../booking/domain/repositories/booking_repository.dart';
import '../../../booking/data/repositories/booking_repository_impl.dart';
import '../../domain/entities/journey_status.dart';
import '../../../../core/database/isar_provider.dart';

part 'progress_repository_impl.g.dart';

/// Abstract repository contract for tracking user progress through the journey.
///
/// This interface defines the contract for monitoring the user's overall
/// status and progress through the three-day program, following the
/// Repository pattern from Clean Architecture.
abstract class ProgressRepository {
  /// Determines the current status of the user's journey.
  ///
  /// Returns [JourneyStatus.needsOnboarding] if no user exists in the database
  /// or if the user has not completed the onboarding process.
  /// Returns [JourneyStatus.awaitingArrival] if the user has a booking but is not checked in.
  /// Returns [JourneyStatus.completed] if a generated report exists and is not empty.
  /// Returns [JourneyStatus.inProgress] otherwise.
  ///
  /// This method performs the following checks:
  /// 1. Verify if a user exists (if not, return needsOnboarding)
  /// 2. Check if the user has completed onboarding (if not, return needsOnboarding)
  /// 3. Check if a generated report exists and is not empty (if yes, return completed)
  /// 4. Check if the user has a booking and if they are checked in
  /// 5. If booking exists but not checked in, return awaitingArrival
  /// 6. Otherwise, return inProgress
  Future<JourneyStatus> getJourneyStatus();

  /// Gets the current day number based on saved Single Priorities.
  ///
  /// Returns the count of days that have their Single Priority saved.
  /// For example:
  /// - If no priorities are saved, returns 0
  /// - If Day 1 priority is saved, returns 1
  /// - If Day 1 and 2 priorities are saved, returns 2
  /// - If all three days' priorities are saved, returns 3
  ///
  /// This helps determine which day the user should be working on.
  Future<int> getCurrentDay();
}

/// Isar database implementation of [ProgressRepository].
///
/// This class provides progress tracking functionality by querying
/// user and daily log data from the Isar database.
class IsarProgressRepository implements ProgressRepository {
  /// The Isar database instance.
  final Isar _isar;

  /// The user repository to check for user existence and generated reports.
  final UserRepository _userRepository;

  /// The booking repository to check for booking status.
  final BookingRepository _bookingRepository;

  /// Creates an instance of [IsarProgressRepository].
  ///
  /// [isar] The Isar database instance to use for queries.
  /// [userRepository] The user repository to check for user data.
  /// [bookingRepository] The booking repository to check for booking data.
  const IsarProgressRepository(
    this._isar,
    this._userRepository,
    this._bookingRepository,
  );

  @override
  Future<JourneyStatus> getJourneyStatus() async {
    // Step 1: Check if a user exists
    final user = await _isar.users.where().findFirst();

    if (user == null) {
      return JourneyStatus.needsOnboarding;
    }

    // Step 2: Check if the user has completed onboarding
    if (!user.hasCompletedOnboarding) {
      return JourneyStatus.needsOnboarding;
    }

    // Step 3: Check if a generated report exists and is not empty
    final generatedReport = await _userRepository.getGeneratedReport();

    if (generatedReport != null && generatedReport.isNotEmpty) {
      return JourneyStatus.completed;
    }

    // Step 4: Check if the user has a booking
    final booking = await _bookingRepository.getActiveBookingForUser(user.id.toString());

    // Step 5: If booking exists but user is not checked in, they are awaiting arrival
    if (booking != null && !booking.isCheckedIn) {
      return JourneyStatus.awaitingArrival;
    }

    // Step 6: User exists, completed onboarding, checked in, but no report generated,
    // journey is in progress
    return JourneyStatus.inProgress;
  }

  @override
  Future<int> getCurrentDay() async {
    // Count all daily logs that have a non-empty Single Priority
    final dailyLogs = await _isar.dailyLogs.where().sortByDayNumber().findAll();

    // Count how many days have a saved (non-empty) Single Priority
    int daysWithPriority = 0;

    for (final log in dailyLogs) {
      if (log.singlePriority.isNotEmpty) {
        daysWithPriority++;
      }
    }

    return daysWithPriority;
  }
}

/// Provides an instance of [ProgressRepository].
///
/// This provider creates and manages the [IsarProgressRepository] instance,
/// which uses Isar for querying progress data.
///
/// The provider watches [isarProvider] to get the database instance,
/// [userRepositoryProvider] to get the user repository instance,
/// and [bookingRepositoryProvider] to get the booking repository instance,
/// then passes all three to the repository constructor.
///
/// Usage example:
/// ```dart
/// final progressRepo = await ref.read(progressRepositoryProvider.future);
/// final status = await progressRepo.getJourneyStatus();
/// final currentDay = await progressRepo.getCurrentDay();
/// ```
@riverpod
Future<ProgressRepository> progressRepository(ProgressRepositoryRef ref) async {
  final isar = await ref.watch(isarProvider.future);
  final userRepo = await ref.watch(userRepositoryProvider.future);
  final bookingRepo = await ref.watch(bookingRepositoryProvider.future);
  return IsarProgressRepository(isar, userRepo, bookingRepo);
}
