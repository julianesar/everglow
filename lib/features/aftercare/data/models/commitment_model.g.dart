// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commitment_model.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const CommitmentModelSchema = Schema(
  name: r'CommitmentModel',
  id: -8021081126001043361,
  properties: {
    r'commitmentText': PropertySchema(
      id: 0,
      name: r'commitmentText',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'sourceDay': PropertySchema(
      id: 2,
      name: r'sourceDay',
      type: IsarType.long,
    )
  },
  estimateSize: _commitmentModelEstimateSize,
  serialize: _commitmentModelSerialize,
  deserialize: _commitmentModelDeserialize,
  deserializeProp: _commitmentModelDeserializeProp,
);

int _commitmentModelEstimateSize(
  CommitmentModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.commitmentText.length * 3;
  bytesCount += 3 + object.id.length * 3;
  return bytesCount;
}

void _commitmentModelSerialize(
  CommitmentModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.commitmentText);
  writer.writeString(offsets[1], object.id);
  writer.writeLong(offsets[2], object.sourceDay);
}

CommitmentModel _commitmentModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CommitmentModel();
  object.commitmentText = reader.readString(offsets[0]);
  object.id = reader.readString(offsets[1]);
  object.sourceDay = reader.readLong(offsets[2]);
  return object;
}

P _commitmentModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension CommitmentModelQueryFilter
    on QueryBuilder<CommitmentModel, CommitmentModel, QFilterCondition> {
  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      commitmentTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commitmentText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      commitmentTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commitmentText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      commitmentTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commitmentText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      commitmentTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commitmentText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      commitmentTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commitmentText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      commitmentTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commitmentText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      commitmentTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commitmentText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      commitmentTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commitmentText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      commitmentTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commitmentText',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      commitmentTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commitmentText',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      sourceDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      sourceDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      sourceDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceDay',
        value: value,
      ));
    });
  }

  QueryBuilder<CommitmentModel, CommitmentModel, QAfterFilterCondition>
      sourceDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CommitmentModelQueryObject
    on QueryBuilder<CommitmentModel, CommitmentModel, QFilterCondition> {}
