import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/models/daily_journey_models.dart';
import '../../../data/repositories/daily_journey_repository.dart';
import '../../../data/repositories/journal_repository.dart';
import '../../core/services/notification_service.dart';

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
  /// 2. Loads the saved single priority for this day
  /// 3. Loads all journal entries for this day
  /// 4. Returns a [DailyJourney] with [isPrioritySet], [singlePriority], and [journalResponses] updated
  ///
  /// Throws an exception if the repository fails to fetch the data.
  @override
  Future<DailyJourney> build(int dayNumber) async {
    final repository = ref.watch(dailyJourneyRepositoryProvider);
    final journey = await repository.getJourneyForDay(dayNumber);

    // Load the saved single priority for this day
    final journalRepo = await ref.read(journalRepositoryProvider.future);
    final savedPriority = await journalRepo.getSinglePriorityForDay(dayNumber);

    // Load journal entries for this day
    final journalResponses = await _loadJournalEntries(dayNumber);

    // Determine if priority is set based on whether the saved priority is non-empty
    final isPrioritySet = savedPriority != null && savedPriority.isNotEmpty;

    // Return journey with updated isPrioritySet flag, singlePriority text, and journal responses
    return journey.copyWith(
      isPrioritySet: isPrioritySet,
      singlePriority: isPrioritySet ? savedPriority : null,
      journalResponses: journalResponses,
    );
  }

  /// Loads all journal entries for the given day.
  ///
  /// Returns a Map where the key is the promptId and the value is the response text.
  /// Returns an empty map if there are no entries or if an error occurs.
  Future<Map<String, String>> _loadJournalEntries(int dayNumber) async {
    try {
      final journalRepo = await ref.read(journalRepositoryProvider.future);
      return await journalRepo.getJournalEntriesForDay(dayNumber);
    } catch (e) {
      // If there's any error, return empty map
      return {};
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

      // Schedule daily notifications after successful save
      await ref.read(notificationServiceProvider).scheduleDailyNotifications(
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

  /// Marks the priority as unset, allowing the user to edit it.
  ///
  /// This method updates the state to set [isPrioritySet] to false,
  /// which triggers the UI to switch from Read Mode to Edit Mode.
  /// The priority text is preserved so the user can edit it.
  Future<void> markPriorityAsUnset() async {
    // Get the current state
    final currentJourney = state.value;
    if (currentJourney == null) return;

    // Update state with isPrioritySet = false
    final updatedJourney = currentJourney.copyWith(isPrioritySet: false);

    state = AsyncValue.data(updatedJourney);
  }

  /// Updates a journal entry for a specific prompt.
  ///
  /// Takes the [promptId] to identify which prompt is being answered and
  /// the [response] text entered by the user. Persists the journal entry
  /// to the repository and updates the local state.
  ///
  /// After successful save, updates the [journalResponses] map in the state
  /// with the new response.
  ///
  /// If an error occurs during save, the state is updated with an error.
  Future<void> updateJournalEntry(String promptId, String response) async {
    // Get the current state to ensure we have valid data
    final currentJourney = state.value;
    if (currentJourney == null) return;

    try {
      // Persist to journal repository with the current day number
      final journalRepo = await ref.read(journalRepositoryProvider.future);
      await journalRepo.saveJournalEntry(
        promptId: promptId,
        responseText: response,
        dayNumber: currentJourney.dayNumber,
      );

      // Update local state with the new journal response
      final updatedResponses = Map<String, String>.from(
        currentJourney.journalResponses,
      );
      updatedResponses[promptId] = response;

      final updatedJourney = currentJourney.copyWith(
        journalResponses: updatedResponses,
      );

      state = AsyncValue.data(updatedJourney);
    } catch (e, stackTrace) {
      // Handle error - set error state
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
