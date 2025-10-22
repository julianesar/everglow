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

  /// Adds a manually created commitment to the user's commitment list.
  ///
  /// This method:
  /// - Retrieves existing commitments from cache
  /// - Creates a new commitment with the provided text and source day
  /// - Appends it to the existing commitments list
  /// - Saves the updated list to the database
  ///
  /// [commitmentText] The text describing the commitment
  /// [sourceDay] The day number (1, 2, or 3) associated with this commitment
  ///
  /// Returns the newly created [Commitment] object.
  Future<Commitment> addManualCommitment({
    required String commitmentText,
    required int sourceDay,
  });

  /// Deletes a commitment from the user's commitment list.
  ///
  /// This method removes the commitment with the specified [commitmentId]
  /// from the database.
  ///
  /// [commitmentId] The unique identifier of the commitment to delete
  ///
  /// Throws an exception if the deletion fails.
  Future<void> deleteCommitment(String commitmentId);
}
