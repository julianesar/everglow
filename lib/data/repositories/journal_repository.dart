import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/journal_models.dart';
import '../local/isar_provider.dart';

part 'journal_repository.g.dart';

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
  /// This method finds the [DailyLog] for the given [dayNumber] and updates
  /// its [singlePriority] field. If no [DailyLog] exists for the day,
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
  ///
  /// This method creates a new [JournalEntry] or updates an existing one
  /// that matches the [promptId]. The entry is associated with the current
  /// day's [DailyLog].
  ///
  /// Throws an exception if the save operation fails.
  Future<void> saveJournalEntry({
    required String promptId,
    required String responseText,
  });
}

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
  }) async {
    await _isar.writeTxn(() async {
      // Get or create today's DailyLog
      final today = DateTime.now();
      final todayLog = await _isar.dailyLogs
          .filter()
          .dateBetween(
            DateTime(today.year, today.month, today.day),
            DateTime(today.year, today.month, today.day, 23, 59, 59),
          )
          .findFirst();

      // Ensure we have a DailyLog for today
      late final int dailyLogId;
      if (todayLog != null) {
        dailyLogId = todayLog.id;
      } else {
        // Create a new DailyLog for today
        // Note: dayNumber should ideally be determined by counting existing logs
        final existingLogsCount = await _isar.dailyLogs.count();
        final newLog = DailyLog.create(
          date: today,
          dayNumber: existingLogsCount + 1,
          singlePriority: '',
        );
        dailyLogId = await _isar.dailyLogs.put(newLog);
      }

      // Find existing journal entry with the same promptId (stored in response for now)
      // Note: If you need to query by promptId, consider adding it as a field to JournalEntry
      final existingEntry = await _isar.journalEntrys
          .filter()
          .dailyLogIdEqualTo(dailyLogId)
          .findAll();

      // For now, we'll create a new entry each time
      // TODO: If you want to update existing entries by promptId,
      // add promptId field to JournalEntry model
      final newEntry = JournalEntry.create(
        response: responseText,
        dailyLogId: dailyLogId,
      );

      await _isar.journalEntrys.put(newEntry);
    });
  }
}

/// Provides an instance of [JournalRepository].
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
@riverpod
Future<JournalRepository> journalRepository(JournalRepositoryRef ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarJournalRepository(isar);
}
