import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:uuid/uuid.dart';

import '../../../../core/network/supabase_provider.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_remote_datasource.dart';

part 'journal_repository_impl_supabase.g.dart';

/// Supabase implementation of [JournalRepository].
///
/// This class provides persistent storage using Supabase backend.
/// Journal entries and task completions are stored remotely.
class SupabaseJournalRepository implements JournalRepository {
  final JournalRemoteDatasource _remoteDatasource;
  final SupabaseClient _supabase;
  final Uuid _uuid;

  /// Creates an instance of [SupabaseJournalRepository].
  const SupabaseJournalRepository(
    this._remoteDatasource,
    this._supabase,
    this._uuid,
  );

  String? get _userId => _supabase.auth.currentUser?.id;

  @override
  Future<void> saveSinglePriority({
    required int dayNumber,
    required String priorityText,
  }) async {
    // Validate day number (only days 1-3 are allowed)
    if (dayNumber < 1 || dayNumber > 3) {
      throw ArgumentError('Day number must be between 1 and 3, got $dayNumber');
    }

    final userId = _userId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Note: The current Supabase schema doesn't have a "single priority" field
    // We'll need to either:
    // 1. Add a special journal prompt for "single priority"
    // 2. Add a new table for daily priorities
    // 3. Use user_profiles table with a JSONB field for daily data
    //
    // For now, we'll create a special journal entry with a reserved promptId
    final priorityPromptId = 'priority_day_$dayNumber';

    await _remoteDatasource.saveJournalResponse(
      JournalResponseData(
        id: _uuid.v4(),
        userId: userId,
        promptId: priorityPromptId,
        dayNumber: dayNumber,
        responseText: priorityText,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
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

    final userId = _userId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _remoteDatasource.saveJournalResponse(
      JournalResponseData(
        id: _uuid.v4(),
        userId: userId,
        promptId: promptId,
        dayNumber: dayNumber,
        responseText: responseText,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<String?> getSinglePriorityForDay(int dayNumber) async {
    final userId = _userId;
    if (userId == null) return null;

    final priorityPromptId = 'priority_day_$dayNumber';
    final responses = await _remoteDatasource.getJournalResponsesByDay(
      userId,
      dayNumber,
    );

    // Find the priority entry
    for (final response in responses) {
      if (response.promptId == priorityPromptId) {
        return response.responseText;
      }
    }

    return null;
  }

  @override
  Future<Map<String, String>> getJournalEntriesForDay(int dayNumber) async {
    final userId = _userId;
    if (userId == null) return {};

    final responses = await _remoteDatasource.getJournalResponsesByDay(
      userId,
      dayNumber,
    );

    final entries = <String, String>{};
    final priorityPromptId = 'priority_day_$dayNumber';

    for (final response in responses) {
      // Skip priority entries (they're handled separately)
      if (response.promptId != priorityPromptId) {
        entries[response.promptId] = response.responseText;
      }
    }

    return entries;
  }

  @override
  Future<Map<String, dynamic>> getAllUserData() async {
    final userId = _userId;
    if (userId == null) return {};

    final allResponses = await _remoteDatasource.getUserJournalResponses(userId);

    // Structure data by day
    final result = <String, dynamic>{};

    for (int day = 1; day <= 3; day++) {
      final dayKey = 'day_$day';
      final priorityPromptId = 'priority_day_$day';

      String? priority;
      final journalEntries = <String, String>{};

      // Filter responses for this day
      for (final response in allResponses) {
        if (response.dayNumber == day) {
          if (response.promptId == priorityPromptId) {
            priority = response.responseText;
          } else {
            journalEntries[response.promptId] = response.responseText;
          }
        }
      }

      result[dayKey] = {
        'priority': priority ?? '',
        'journal_entries': journalEntries,
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

    final userId = _userId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Check if task is already completed
    final existingCompletions = await _remoteDatasource.getTaskCompletionsByDay(
      userId,
      dayNumber,
    );

    // If task is already completed, do nothing
    final alreadyCompleted = existingCompletions.any(
      (completion) => completion.itineraryItemId == taskId,
    );

    if (!alreadyCompleted) {
      await _remoteDatasource.completeTask(
        userId: userId,
        itineraryItemId: taskId,
        dayNumber: dayNumber,
      );
    }
  }

  @override
  Future<Set<String>> getCompletedTasksForDay(int dayNumber) async {
    final userId = _userId;
    if (userId == null) return {};

    final completions = await _remoteDatasource.getTaskCompletionsByDay(
      userId,
      dayNumber,
    );

    return completions.map((c) => c.itineraryItemId).toSet();
  }
}

/// Provides the UUID generator.
@riverpod
Uuid uuid(UuidRef ref) {
  return const Uuid();
}

/// Provides the journal remote datasource.
@riverpod
JournalRemoteDatasource journalRemoteDatasource(
    JournalRemoteDatasourceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return JournalRemoteDatasource(supabase);
}

/// Provides an instance of [JournalRepository].
///
/// This provider creates and manages the [SupabaseJournalRepository] instance,
/// which uses Supabase for persistent storage.
@riverpod
Future<JournalRepository> journalRepository(JournalRepositoryRef ref) async {
  final datasource = ref.watch(journalRemoteDatasourceProvider);
  final supabase = ref.watch(supabaseClientProvider);
  final uuid = ref.watch(uuidProvider);
  return SupabaseJournalRepository(datasource, supabase, uuid);
}
