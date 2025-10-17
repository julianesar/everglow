import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/journal_models.dart';
import '../../domain/models/journey_status.dart';
import '../local/isar_provider.dart';
import 'user_repository.dart';

part 'progress_repository.g.dart';

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
  /// Returns [JourneyStatus.completed] if a generated report exists and is not empty.
  /// Returns [JourneyStatus.inProgress] otherwise.
  ///
  /// This method performs the following checks:
  /// 1. Verify if a user exists (if not, return needsOnboarding)
  /// 2. Check if the user has completed onboarding (if not, return needsOnboarding)
  /// 3. Check if a generated report exists and is not empty (if yes, return completed)
  /// 4. Otherwise, return inProgress
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

  /// Creates an instance of [IsarProgressRepository].
  ///
  /// [isar] The Isar database instance to use for queries.
  /// [userRepository] The user repository to check for user data.
  const IsarProgressRepository(this._isar, this._userRepository);

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

    // Step 4: User exists and completed onboarding but no report generated,
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
/// The provider watches [isarProvider] to get the database instance
/// and [userRepositoryProvider] to get the user repository instance,
/// then passes both to the repository constructor.
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
  return IsarProgressRepository(isar, userRepo);
}
