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
  /// 2. Loads the saved single priority for this day
  /// 3. Loads all journal entries for this day
  /// 4. Loads completed tasks for this day
  /// 5. Returns a [DailyJourney] with [isPrioritySet], [singlePriority], [journalResponses], and completion status updated
  ///
  /// Throws an exception if the repository fails to fetch the data.
  @override
  Future<DailyJourney> build(int dayNumber) async {
    final repository = ref.watch(dailyJourneyRepositoryProvider);
    final journey = await repository.getJourneyForDay(dayNumber);

    // Load journal entries for this day
    final journalResponses = await _loadJournalEntries(dayNumber);

    // Load completed tasks for this day
    final journalRepo = await ref.read(journalRepositoryProvider.future);
    final completedTasks = await journalRepo.getCompletedTasksForDay(dayNumber);

    // Priority is always set since it's pre-established in the repository
    final isPrioritySet = true;

    // Update itinerary items with completion status
    final updatedItinerary = journey.itinerary.map((item) {
      final isCompleted = completedTasks.contains(item.id);
      return switch (item) {
        MedicalEvent() => MedicalEvent(
          id: item.id,
          time: item.time,
          title: item.title,
          description: item.description,
          location: item.location,
          isCompleted: isCompleted,
        ),
        GuidedPractice() => GuidedPractice(
          id: item.id,
          time: item.time,
          title: item.title,
          audioUrl: item.audioUrl,
          isCompleted: isCompleted,
        ),
        JournalingSection() => JournalingSection(
          id: item.id,
          time: item.time,
          title: item.title,
          prompts: item.prompts,
          isCompleted: isCompleted,
        ),
        _ => item,
      };
    }).toList();

    // Return journey with updated isPrioritySet flag, journal responses, and completion status
    // singlePriority is already set in the journey from the repository
    return journey.copyWith(
      isPrioritySet: isPrioritySet,
      journalResponses: journalResponses,
      itinerary: updatedItinerary,
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

  /// Marks a task as completed and triggers UI update with celebratory animation.
  ///
  /// [taskId] The unique identifier of the task to mark as completed
  ///
  /// This method:
  /// 1. Persists the completion status to the repository
  /// 2. Updates the local state to reflect the completion
  /// 3. Triggers a celebratory animation (handled by UI layer)
  ///
  /// Returns true if the task was newly completed, false if it was already completed.
  Future<bool> completeTask(String taskId) async {
    // Get the current state to ensure we have valid data
    final currentJourney = state.value;
    if (currentJourney == null) return false;

    // Check if task is already completed
    final taskItem = currentJourney.itinerary.firstWhere(
      (item) => item.id == taskId,
      orElse: () => throw ArgumentError('Task with id $taskId not found'),
    );

    if (taskItem.isCompleted) {
      // Task already completed, no need to do anything
      return false;
    }

    try {
      // Persist to repository first
      final journalRepo = await ref.read(journalRepositoryProvider.future);
      await journalRepo.completeTask(
        dayNumber: currentJourney.dayNumber,
        taskId: taskId,
      );

      // Update local state with the new completion status
      final updatedItinerary = currentJourney.itinerary.map((item) {
        if (item.id == taskId) {
          return switch (item) {
            MedicalEvent() => MedicalEvent(
              id: item.id,
              time: item.time,
              title: item.title,
              description: item.description,
              location: item.location,
              isCompleted: true,
            ),
            GuidedPractice() => GuidedPractice(
              id: item.id,
              time: item.time,
              title: item.title,
              audioUrl: item.audioUrl,
              isCompleted: true,
            ),
            JournalingSection() => JournalingSection(
              id: item.id,
              time: item.time,
              title: item.title,
              prompts: item.prompts,
              isCompleted: true,
            ),
            _ => item,
          };
        }
        return item;
      }).toList();

      final updatedJourney = currentJourney.copyWith(
        itinerary: updatedItinerary,
      );

      state = AsyncValue.data(updatedJourney);
      return true; // Task was newly completed
    } catch (e, stackTrace) {
      // Handle error - set error state
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }
}
