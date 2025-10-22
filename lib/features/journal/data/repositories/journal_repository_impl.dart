import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/isar_provider.dart';
import '../../domain/repositories/journal_repository.dart';
import '../models/daily_log_model.dart';
import '../models/journal_entry_model.dart';

// MIGRATION TO SUPABASE: Export the new Supabase implementation
export 'journal_repository_impl_supabase.dart';

/// Isar database implementation of [JournalRepository].
///
/// This class provides persistent storage using Isar database.
/// Journal entries and daily logs are stored locally and survive app restarts.
class IsarJournalRepository implements JournalRepository {
  /// The Isar database instance.
  final Isar _isar;

  /// Creates an instance of [IsarJournalRepository].
  ///
  /// [isar] The Isar database instance to use for storage.
  const IsarJournalRepository(this._isar);

  @override
  Future<void> saveSinglePriority({
    required int dayNumber,
    required String priorityText,
  }) async {
    // Validate day number (only days 1-3 are allowed)
    if (dayNumber < 1 || dayNumber > 3) {
      throw ArgumentError('Day number must be between 1 and 3, got $dayNumber');
    }

    await _isar.writeTxn(() async {
      // Find existing DailyLog for this day number
      final existingLog = await _isar.dailyLogs
          .filter()
          .dayNumberEqualTo(dayNumber)
          .findFirst();

      if (existingLog != null) {
        // Update existing log
        existingLog.singlePriority = priorityText;
        await _isar.dailyLogs.put(existingLog);
      } else {
        // Create new log with current date
        final newLog = DailyLog.create(
          date: DateTime.now(),
          dayNumber: dayNumber,
          singlePriority: priorityText,
        );
        await _isar.dailyLogs.put(newLog);
      }
    });
  }

  @override
  Future<void> saveJournalEntry({
    required String promptId,
    required String responseText,
    required int dayNumber,
  }) async {
    // Validate day number (only days 1-3 are allowed)
    if (dayNumber < 1 || dayNumber > 3) {
      throw ArgumentError('Day number must be between 1 and 3, got $dayNumber');
    }

    await _isar.writeTxn(() async {
      // Find or create the DailyLog for the specified day number
      final existingLog = await _isar.dailyLogs
          .filter()
          .dayNumberEqualTo(dayNumber)
          .findFirst();

      // Ensure we have a DailyLog for this day
      late final int dailyLogId;
      if (existingLog != null) {
        dailyLogId = existingLog.id;
      } else {
        // Create a new DailyLog for this day number
        final newLog = DailyLog.create(
          date: DateTime.now(),
          dayNumber: dayNumber,
          singlePriority: '',
        );
        dailyLogId = await _isar.dailyLogs.put(newLog);
      }

      // Find existing journal entry with the same promptId and dailyLogId
      final existingEntry = await _isar.journalEntrys
          .filter()
          .dailyLogIdEqualTo(dailyLogId)
          .and()
          .promptIdEqualTo(promptId)
          .findFirst();

      if (existingEntry != null) {
        // Update existing entry
        existingEntry.response = responseText;
        existingEntry.createdAt = DateTime.now();
        await _isar.journalEntrys.put(existingEntry);
      } else {
        // Create new entry
        final newEntry = JournalEntry.create(
          promptId: promptId,
          response: responseText,
          dailyLogId: dailyLogId,
        );
        await _isar.journalEntrys.put(newEntry);
      }
    });
  }

  @override
  Future<String?> getSinglePriorityForDay(int dayNumber) async {
    // Find the DailyLog for the specified day number
    final dailyLog = await _isar.dailyLogs
        .filter()
        .dayNumberEqualTo(dayNumber)
        .findFirst();

    // Return the priority if found, otherwise null
    return dailyLog?.singlePriority;
  }

  @override
  Future<Map<String, String>> getJournalEntriesForDay(int dayNumber) async {
    final result = <String, String>{};

    // Find the DailyLog for the specified day number
    final dailyLog = await _isar.dailyLogs
        .filter()
        .dayNumberEqualTo(dayNumber)
        .findFirst();

    // If no DailyLog exists for this day, return empty map
    if (dailyLog == null) {
      return result;
    }

    // Get all journal entries for this daily log
    final journalEntries = await _isar.journalEntrys
        .filter()
        .dailyLogIdEqualTo(dailyLog.id)
        .sortByCreatedAt()
        .findAll();

    // Build the map with promptId as key and response as value
    for (final entry in journalEntries) {
      result[entry.promptId] = entry.response;
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>> getAllUserData() async {
    final result = <String, dynamic>{};

    // Fetch all daily logs sorted by day number
    final dailyLogs = await _isar.dailyLogs.where().sortByDayNumber().findAll();

    // Process each daily log
    for (final dailyLog in dailyLogs) {
      final dayKey = 'day_${dailyLog.dayNumber}';

      // Get all journal entries for this daily log
      final journalEntries = await _isar.journalEntrys
          .filter()
          .dailyLogIdEqualTo(dailyLog.id)
          .sortByCreatedAt()
          .findAll();

      // Build journal entries map using promptId as key
      final entriesMap = <String, String>{};
      for (final entry in journalEntries) {
        entriesMap[entry.promptId] = entry.response;
      }

      // Build the day's data structure
      result[dayKey] = {
        'priority': dailyLog.singlePriority,
        'journal_entries': entriesMap,
      };
    }

    return result;
  }

  @override
  Future<void> completeTask({
    required int dayNumber,
    required String taskId,
  }) async {
    // Validate day number (only days 1-3 are allowed)
    if (dayNumber < 1 || dayNumber > 3) {
      throw ArgumentError('Day number must be between 1 and 3, got $dayNumber');
    }

    await _isar.writeTxn(() async {
      // Find existing DailyLog for this day number
      final existingLog = await _isar.dailyLogs
          .filter()
          .dayNumberEqualTo(dayNumber)
          .findFirst();

      if (existingLog != null) {
        // Check if task is already completed
        if (!existingLog.completedTasks.contains(taskId)) {
          // Create a new growable list from the existing fixed-length list
          existingLog.completedTasks = List<String>.from(existingLog.completedTasks)..add(taskId);
          await _isar.dailyLogs.put(existingLog);
        }
      } else {
        // Create new log with the completed task
        final newLog = DailyLog.create(
          date: DateTime.now(),
          dayNumber: dayNumber,
          singlePriority: '',
          completedTasks: [taskId],
        );
        await _isar.dailyLogs.put(newLog);
      }
    });
  }

  @override
  Future<Set<String>> getCompletedTasksForDay(int dayNumber) async {
    // Find the DailyLog for the specified day number
    final dailyLog = await _isar.dailyLogs
        .filter()
        .dayNumberEqualTo(dayNumber)
        .findFirst();

    // Return the completed tasks as a Set, or empty set if no log exists
    return dailyLog?.completedTasks.toSet() ?? {};
  }
}

/// Provides an instance of [JournalRepository].
///
/// NOTE: This Isar provider is commented out in favor of the Supabase implementation.
/// The Supabase implementation is exported at the top of this file.
///
/// This provider creates and manages the [IsarJournalRepository] instance,
/// which uses Isar for persistent storage.
///
/// The provider watches [isarProvider] to get the database instance
/// and passes it to the repository constructor.
///
/// Usage example:
/// ```dart
/// final journalRepo = await ref.read(journalRepositoryProvider.future);
/// await journalRepo.saveSinglePriority(dayNumber: 1, priorityText: 'Focus on healing');
/// ```
// @riverpod
// Future<JournalRepository> journalRepository(JournalRepositoryRef ref) async {
//   final isar = await ref.watch(isarProvider.future);
//   return IsarJournalRepository(isar);
// }
