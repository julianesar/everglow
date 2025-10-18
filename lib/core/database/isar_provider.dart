import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/booking/data/models/booking_model.dart';
import '../../features/concierge/data/models/concierge_info_model.dart';
import '../../features/journal/data/models/daily_log_model.dart';
import '../../features/journal/data/models/journal_entry_model.dart';
import '../../features/user/data/models/user_model.dart';
import '../../features/user_profile/data/models/user_profile_model.dart';

part 'isar_provider.g.dart';

/// Opens and initializes the Isar database instance.
///
/// This function configures Isar with all necessary collection schemas:
/// - [UserSchema]: User profile and integration statement
/// - [DailyLogSchema]: Daily log entries with date and priority
/// - [JournalEntrySchema]: Individual journal entry responses
///
/// The database is stored in the application documents directory.
///
/// Returns a [Future] that resolves to the initialized [Isar] instance.
///
/// Throws an exception if the database initialization fails.
Future<Isar> openIsar() async {
  // Get the application documents directory for database storage
  final dir = await getApplicationDocumentsDirectory();

  // Open Isar database with all collection schemas
  return await Isar.open(
    [
      UserSchema,
      DailyLogSchema,
      JournalEntrySchema,
      MedicalProfileSchema,
      ConciergePreferencesSchema,
      BookingModelSchema,
      ConciergeInfoModelSchema,
    ],
    directory: dir.path,
    // Inspector is useful for debugging in development
    inspector: true,
  );
}

/// Provides the Isar database instance to the application.
///
/// This provider initializes the Isar database and makes it available
/// throughout the app via Riverpod's dependency injection.
///
/// Usage example:
/// ```dart
/// final isar = await ref.read(isarProvider.future);
/// ```
///
/// The database instance is cached and shared across the entire app.
@Riverpod(keepAlive: true)
Future<Isar> isar(IsarRef ref) async {
  return await openIsar();
}
