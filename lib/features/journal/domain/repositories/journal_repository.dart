/// Abstract repository contract for journal data management.
///
/// This interface defines the contract for journal and daily log operations,
/// following the Repository pattern from Clean Architecture.
abstract class JournalRepository {
  /// Saves or updates the single priority for a specific day.
  ///
  /// [dayNumber] The sequential day number in the journey
  /// [priorityText] The priority text to save
  ///
  /// This method finds the DailyLog for the given [dayNumber] and updates
  /// its singlePriority field. If no DailyLog exists for the day,
  /// a new one will be created with the current date.
  ///
  /// Throws an exception if the save operation fails.
  Future<void> saveSinglePriority({
    required int dayNumber,
    required String priorityText,
  });

  /// Saves or updates a journal entry response.
  ///
  /// [promptId] The unique identifier for the journal prompt
  /// [responseText] The user's response text
  /// [dayNumber] The day number (1-3) this journal entry belongs to
  ///
  /// This method creates a new JournalEntry or updates an existing one
  /// that matches the [promptId]. The entry is associated with the specified
  /// day's DailyLog.
  ///
  /// Throws an exception if the save operation fails.
  Future<void> saveJournalEntry({
    required String promptId,
    required String responseText,
    required int dayNumber,
  });

  /// Retrieves the single priority for a specific day.
  ///
  /// [dayNumber] The sequential day number to retrieve the priority for
  ///
  /// Returns the priority text if it exists, or null if no DailyLog exists
  /// for the given day number or if the priority is not set.
  ///
  /// This is a more efficient method when you only need the priority text
  /// without fetching all journal entries.
  Future<String?> getSinglePriorityForDay(int dayNumber);

  /// Retrieves all journal entries for a specific day.
  ///
  /// [dayNumber] The sequential day number to retrieve entries for
  ///
  /// Returns a Map where the key is the promptId and the value is the response text.
  /// If no DailyLog exists for the given day number, returns an empty map.
  ///
  /// Example return value:
  /// ```dart
  /// {
  ///   "prompt_1": "My response to prompt 1",
  ///   "prompt_2": "My response to prompt 2"
  /// }
  /// ```
  Future<Map<String, String>> getJournalEntriesForDay(int dayNumber);

  /// Retrieves all user data in a structured format for AI processing.
  ///
  /// Returns a Map structured by day number, containing priority and journal entries.
  /// The structure is:
  /// ```json
  /// {
  ///   "day_1": {
  ///     "priority": "The priority text for day 1",
  ///     "journal_entries": {
  ///       "prompt_1": "Response to prompt 1",
  ///       "prompt_2": "Response to prompt 2"
  ///     }
  ///   },
  ///   "day_2": { ... }
  /// }
  /// ```
  ///
  /// Journal entries are keyed by their promptId for easy lookup.
  ///
  /// Handles missing data gracefully:
  /// - Days with no priority will have an empty string
  /// - Days with no journal entries will have an empty map
  Future<Map<String, dynamic>> getAllUserData();

  /// Marks a task as completed for a specific day.
  ///
  /// [dayNumber] The day number (1-3)
  /// [taskId] The unique identifier of the task to mark as completed
  ///
  /// This method adds the taskId to the completedTasks list in the DailyLog
  /// for the specified day. If the task is already completed, it does nothing.
  ///
  /// Throws an exception if the save operation fails.
  Future<void> completeTask({required int dayNumber, required String taskId});

  /// Retrieves the list of completed task IDs for a specific day.
  ///
  /// [dayNumber] The day number (1-3)
  ///
  /// Returns a Set of completed task IDs for the specified day.
  /// If no DailyLog exists for the day, returns an empty set.
  Future<Set<String>> getCompletedTasksForDay(int dayNumber);
}
