import 'package:isar/isar.dart';

part 'journal_models.g.dart';

/// User entity representing the app user with their integration statement
///
/// This model stores user information including their personal integration
/// statement for the EverGlow journaling process.
@collection
class User {
  /// Auto-incremental unique identifier
  Id id = Isar.autoIncrement;

  /// User's name
  String name = '';

  /// User's integration statement for personal growth
  String integrationStatement = '';

  /// Cached AI-generated report for the user
  String? generatedReport;

  /// Flag indicating whether the user has completed the onboarding process
  bool hasCompletedOnboarding = false;

  /// Default constructor
  User();

  /// Named constructor with parameters
  User.create({required this.name, required this.integrationStatement});
}

/// Daily log entity representing a single day's log entry
///
/// This model stores daily information including the date, day number,
/// the single priority for that day, and completed tasks.
@collection
class DailyLog {
  /// Auto-incremental unique identifier
  Id id = Isar.autoIncrement;

  /// Date of the daily log
  @Index()
  DateTime date = DateTime.now();

  /// Sequential day number in the journaling journey
  int dayNumber = 1;

  /// Single priority focus for the day
  String singlePriority = '';

  /// List of completed task IDs for gamification tracking
  List<String> completedTasks = [];

  /// Default constructor
  DailyLog();

  /// Named constructor with parameters
  DailyLog.create({
    required this.date,
    required this.dayNumber,
    required this.singlePriority,
    List<String>? completedTasks,
  }) {
    this.completedTasks = completedTasks ?? [];
  }
}

/// Journal entry entity representing a response to a journal prompt
///
/// This model stores individual journal entry responses throughout
/// the EverGlow journaling process.
@collection
class JournalEntry {
  /// Auto-incremental unique identifier
  Id id = Isar.autoIncrement;

  /// Unique identifier for the journal prompt
  @Index()
  String promptId = '';

  /// Response text for the journal entry
  String response = '';

  /// Timestamp when the entry was created
  @Index()
  DateTime createdAt = DateTime.now();

  /// Reference to the daily log this entry belongs to
  int dailyLogId = 0;

  /// Default constructor
  JournalEntry();

  /// Named constructor with parameters
  JournalEntry.create({
    required this.promptId,
    required this.response,
    required this.dailyLogId,
    DateTime? createdAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
  }
}
