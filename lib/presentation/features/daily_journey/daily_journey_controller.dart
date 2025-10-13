import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/models/daily_journey_models.dart';
import '../../../data/repositories/daily_journey_repository.dart';
import '../../../data/repositories/journal_repository.dart';

part 'daily_journey_controller.g.dart';

/// Controller for managing daily journey state and operations.
///
/// This controller fetches and manages the daily journey data for a specific day.
/// It uses Riverpod's AsyncNotifier to handle async state management.
/// The state is a [DailyJourney] object that includes the [isPrioritySet] flag.
@riverpod
class DailyJourneyController extends _$DailyJourneyController {
  /// Builds the initial state by fetching the daily journey for the given day.
  ///
  /// This method:
  /// 1. Fetches the journey data from the repository
  /// 2. Checks if a priority has been set for this day in the journal repository
  /// 3. Returns a [DailyJourney] with the [isPrioritySet] flag updated
  ///
  /// Throws an exception if the repository fails to fetch the data.
  @override
  Future<DailyJourney> build(int dayNumber) async {
    final repository = ref.watch(dailyJourneyRepositoryProvider);
    final journey = await repository.getJourneyForDay(dayNumber);

    // Check if priority has been set for this day by querying the journal repository
    final isPrioritySet = await _checkIfPriorityIsSet(dayNumber);

    // Return journey with updated isPrioritySet flag
    return journey.copyWith(isPrioritySet: isPrioritySet);
  }

  /// Checks if a single priority has been set for the given day.
  ///
  /// Returns true if a non-empty priority exists in the repository.
  /// Returns false if there's no priority or if an error occurs.
  Future<bool> _checkIfPriorityIsSet(int dayNumber) async {
    try {
      final journalRepo = await ref.read(journalRepositoryProvider.future);
      final userData = await journalRepo.getAllUserData();
      final dayKey = 'day_$dayNumber';

      if (userData.containsKey(dayKey)) {
        final priority = userData[dayKey]['priority'] as String?;
        return priority != null && priority.isNotEmpty;
      }
      return false;
    } catch (e) {
      // If there's any error, assume priority is not set
      return false;
    }
  }

  /// Updates the single priority for the current day.
  ///
  /// Takes the [priority] text and persists it to the journal repository.
  /// Upon successful save, updates the state with a new [DailyJourney] object
  /// that has [isPrioritySet] set to true and the [singlePriority] field updated.
  ///
  /// If an error occurs during save, the state is updated with an error.
  Future<void> updateSinglePriority(String priority) async {
    // Get the current state
    final currentJourney = state.value;
    if (currentJourney == null) return;

    try {
      // Persist to repository first
      final journalRepo = await ref.read(journalRepositoryProvider.future);
      await journalRepo.saveSinglePriority(
        dayNumber: currentJourney.dayNumber,
        priorityText: priority,
      );

      // Upon successful save, update state with new journey object
      final updatedJourney = currentJourney.copyWith(
        singlePriority: priority,
        isPrioritySet: true,
      );

      state = AsyncValue.data(updatedJourney);
    } catch (e, stackTrace) {
      // Handle error - set error state
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Updates a journal entry for a specific prompt.
  ///
  /// Takes the [promptId] to identify which prompt is being answered and
  /// the [response] text entered by the user. Persists the journal entry
  /// to the repository.
  ///
  /// Note: This method does not update the local state as journal entries
  /// are not part of the [DailyJourney] model. They are stored separately
  /// in the journal repository.
  ///
  /// If an error occurs during save, the state is updated with an error.
  Future<void> updateJournalEntry(String promptId, String response) async {
    // Get the current state to ensure we have valid data
    final currentJourney = state.value;
    if (currentJourney == null) return;

    try {
      // Persist to journal repository
      final journalRepo = await ref.read(journalRepositoryProvider.future);
      await journalRepo.saveJournalEntry(
        promptId: promptId,
        responseText: response,
      );

      // Note: We don't update the state here because journal entries
      // are not part of the DailyJourney model. They are stored separately
      // and can be fetched using the journal repository when needed.
    } catch (e, stackTrace) {
      // Handle error - set error state
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
