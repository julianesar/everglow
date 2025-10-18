import 'package:isar/isar.dart';

part 'daily_log_model.g.dart';

/// Daily log model representing a single day's log entry
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
