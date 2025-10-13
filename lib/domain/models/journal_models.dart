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
  late String name;

  /// User's integration statement for personal growth
  late String integrationStatement;

  /// Cached AI-generated report for the user
  String? generatedReport;

  /// Default constructor
  User();

  /// Named constructor with parameters
  User.create({
    required this.name,
    required this.integrationStatement,
  });
}

/// Daily log entity representing a single day's log entry
///
/// This model stores daily information including the date, day number,
/// and the single priority for that day.
@collection
class DailyLog {
  /// Auto-incremental unique identifier
  Id id = Isar.autoIncrement;

  /// Date of the daily log
  @Index()
  late DateTime date;

  /// Sequential day number in the journaling journey
  late int dayNumber;

  /// Single priority focus for the day
  late String singlePriority;

  /// Default constructor
  DailyLog();

  /// Named constructor with parameters
  DailyLog.create({
    required this.date,
    required this.dayNumber,
    required this.singlePriority,
  });
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
  late String promptId;

  /// Response text for the journal entry
  late String response;

  /// Timestamp when the entry was created
  @Index()
  late DateTime createdAt;

  /// Reference to the daily log this entry belongs to
  late int dailyLogId;

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
