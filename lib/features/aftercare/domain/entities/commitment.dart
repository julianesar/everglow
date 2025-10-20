/// A commitment extracted from the user's journal entries.
///
/// Represents an actionable commitment the user made during their journey,
/// such as lifestyle changes, practices, or behavioral goals.
class Commitment {
  /// Unique identifier for the commitment.
  final String id;

  /// The text describing the commitment.
  final String commitmentText;

  /// The day number from which this commitment was extracted (1, 2, or 3).
  final int sourceDay;

  const Commitment({
    required this.id,
    required this.commitmentText,
    required this.sourceDay,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Commitment &&
        other.id == id &&
        other.commitmentText == commitmentText &&
        other.sourceDay == sourceDay;
  }

  @override
  int get hashCode =>
      id.hashCode ^ commitmentText.hashCode ^ sourceDay.hashCode;

  @override
  String toString() =>
      'Commitment(id: $id, commitmentText: $commitmentText, sourceDay: $sourceDay)';
}
