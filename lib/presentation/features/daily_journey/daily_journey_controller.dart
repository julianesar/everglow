import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/models/daily_journey_models.dart';
import '../../../data/repositories/daily_journey_repository.dart';

part 'daily_journey_controller.g.dart';

/// Controller for managing daily journey state and operations.
///
/// This controller fetches and manages the daily journey data for a specific day.
/// It uses Riverpod's AsyncNotifier to handle async state management.
@riverpod
class DailyJourneyController extends _$DailyJourneyController {
  /// Builds the initial state by fetching the daily journey for the given day.
  ///
  /// Throws an exception if the repository fails to fetch the data.
  @override
  Future<DailyJourney> build(int dayNumber) async {
    final repository = ref.watch(dailyJourneyRepositoryProvider);
    return await repository.getJourneyForDay(dayNumber);
  }

  /// Updates the single priority for the current day.
  ///
  /// Takes the [priority] text and persists it. Updates the state to reflect
  /// the new priority value.
  Future<void> updateSinglePriority(String priority) async {
    // Get the current state
    final currentState = state.value;
    if (currentState == null) return;

    // TODO: Persist to repository/local storage
    // For now, we'll just update the local state

    // Update state with new priority
    state = AsyncValue.data(
      currentState.copyWith(singlePriority: priority),
    );
  }

  /// Updates a journal entry for a specific prompt.
  ///
  /// Takes the [promptId] to identify which prompt is being answered and
  /// the [response] text entered by the user. Persists the journal entry.
  Future<void> updateJournalEntry(String promptId, String response) async {
    // Get the current state
    final currentState = state.value;
    if (currentState == null) return;

    // TODO: Persist to repository/local storage
    // For now, we'll just log the journal entry
    // In a real implementation, you would:
    // 1. Save to local storage (e.g., Hive, SQLite)
    // 2. Optionally sync to backend
    // 3. Update the state to reflect saved entries

    // Could update state to track saved journal entries
    // state = AsyncValue.data(currentState);
  }
}
