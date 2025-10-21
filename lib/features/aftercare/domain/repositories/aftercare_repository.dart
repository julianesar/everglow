import '../entities/commitment.dart';

/// Repository contract for aftercare-related operations.
///
/// Handles extraction and management of user commitments from journal entries.
abstract class AftercareRepository {
  /// Extracts commitments from the user's journal entries using AI analysis.
  ///
  /// This method:
  /// - Retrieves all user journal data
  /// - Uses AI to identify 3-5 key actionable commitments
  /// - Caches the results to avoid redundant AI calls
  ///
  /// [forceRefresh] If true, bypasses the cache and regenerates commitments
  ///
  /// Returns a list of [Commitment] objects representing the user's
  /// actionable commitments made during their journey.
  Future<List<Commitment>> extractCommitmentsFromJournal({
    bool forceRefresh = false,
  });
}
