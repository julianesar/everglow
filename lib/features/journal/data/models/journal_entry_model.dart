import 'package:isar/isar.dart';

part 'journal_entry_model.g.dart';

/// Journal entry model representing a response to a journal prompt
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
