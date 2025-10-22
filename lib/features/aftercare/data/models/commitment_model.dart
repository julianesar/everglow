import 'package:isar/isar.dart';
import '../../domain/entities/commitment.dart';

part 'commitment_model.g.dart';

/// Embedded model for storing commitment data.
///
/// This model is used for serialization and persistence with Isar.
/// It can be embedded in other collections (like User).
@embedded
class CommitmentModel {
  /// Unique identifier for the commitment.
  late String id;

  /// The text describing the commitment.
  late String commitmentText;

  /// The day number from which this commitment was extracted (1, 2, or 3).
  late int sourceDay;

  /// Default constructor for Isar
  CommitmentModel();

  /// Creates a CommitmentModel from a domain entity.
  CommitmentModel.fromEntity(Commitment commitment)
    : id = commitment.id,
      commitmentText = commitment.commitmentText,
      sourceDay = commitment.sourceDay;

  /// Converts this model to a domain entity.
  Commitment toEntity() {
    return Commitment(
      id: id,
      commitmentText: commitmentText,
      sourceDay: sourceDay,
    );
  }

  /// Creates a CommitmentModel from JSON.
  factory CommitmentModel.fromJson(Map<String, dynamic> json) {
    return CommitmentModel()
      ..id = json['id'] as String
      ..commitmentText = json['commitmentText'] as String
      ..sourceDay = json['sourceDay'] as int;
  }

  /// Converts this model to JSON.
  Map<String, dynamic> toJson() {
    return {'id': id, 'commitmentText': commitmentText, 'sourceDay': sourceDay};
  }
}
