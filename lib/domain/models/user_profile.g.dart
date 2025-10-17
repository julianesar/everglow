// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMedicalProfileCollection on Isar {
  IsarCollection<MedicalProfile> get medicalProfiles => this.collection();
}

const MedicalProfileSchema = CollectionSchema(
  name: r'MedicalProfile',
  id: -9138320194384164083,
  properties: {
    r'allergies': PropertySchema(
      id: 0,
      name: r'allergies',
      type: IsarType.stringList,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'hasSignedConsent': PropertySchema(
      id: 2,
      name: r'hasSignedConsent',
      type: IsarType.bool,
    ),
    r'medicalConditions': PropertySchema(
      id: 3,
      name: r'medicalConditions',
      type: IsarType.stringList,
    ),
    r'medications': PropertySchema(
      id: 4,
      name: r'medications',
      type: IsarType.stringList,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _medicalProfileEstimateSize,
  serialize: _medicalProfileSerialize,
  deserialize: _medicalProfileDeserialize,
  deserializeProp: _medicalProfileDeserializeProp,
  idName: r'id',
  indexes: {
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _medicalProfileGetId,
  getLinks: _medicalProfileGetLinks,
  attach: _medicalProfileAttach,
  version: '3.1.0+1',
);

int _medicalProfileEstimateSize(
  MedicalProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.allergies.length * 3;
  {
    for (var i = 0; i < object.allergies.length; i++) {
      final value = object.allergies[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.medicalConditions.length * 3;
  {
    for (var i = 0; i < object.medicalConditions.length; i++) {
      final value = object.medicalConditions[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.medications.length * 3;
  {
    for (var i = 0; i < object.medications.length; i++) {
      final value = object.medications[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _medicalProfileSerialize(
  MedicalProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.allergies);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeBool(offsets[2], object.hasSignedConsent);
  writer.writeStringList(offsets[3], object.medicalConditions);
  writer.writeStringList(offsets[4], object.medications);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

MedicalProfile _medicalProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MedicalProfile();
  object.allergies = reader.readStringList(offsets[0]) ?? [];
  object.createdAt = reader.readDateTime(offsets[1]);
  object.hasSignedConsent = reader.readBool(offsets[2]);
  object.id = id;
  object.medicalConditions = reader.readStringList(offsets[3]) ?? [];
  object.medications = reader.readStringList(offsets[4]) ?? [];
  object.updatedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _medicalProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _medicalProfileGetId(MedicalProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _medicalProfileGetLinks(MedicalProfile object) {
  return [];
}

void _medicalProfileAttach(
  IsarCollection<dynamic> col,
  Id id,
  MedicalProfile object,
) {
  object.id = id;
}

extension MedicalProfileQueryWhereSort
    on QueryBuilder<MedicalProfile, MedicalProfile, QWhere> {
  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension MedicalProfileQueryWhere
    on QueryBuilder<MedicalProfile, MedicalProfile, QWhereClause> {
  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhereClause>
  createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'createdAt', value: [createdAt]),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhereClause>
  createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhereClause>
  createdAtGreaterThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [createdAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhereClause>
  createdAtLessThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [],
          upper: [createdAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterWhereClause>
  createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [lowerCreatedAt],
          includeLower: includeLower,
          upper: [upperCreatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MedicalProfileQueryFilter
    on QueryBuilder<MedicalProfile, MedicalProfile, QFilterCondition> {
  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'allergies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'allergies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'allergies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'allergies',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'allergies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'allergies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'allergies',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'allergies',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'allergies', value: ''),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'allergies', value: ''),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'allergies', length, true, length, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'allergies', 0, true, 0, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'allergies', 0, false, 999999, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'allergies', 0, true, length, include);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'allergies', length, include, 999999, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  allergiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'allergies',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  hasSignedConsentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hasSignedConsent', value: value),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'medicalConditions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'medicalConditions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'medicalConditions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'medicalConditions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'medicalConditions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'medicalConditions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'medicalConditions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'medicalConditions',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'medicalConditions', value: ''),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'medicalConditions', value: ''),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'medicalConditions', length, true, length, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'medicalConditions', 0, true, 0, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'medicalConditions', 0, false, 999999, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'medicalConditions', 0, true, length, include);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medicalConditions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicalConditionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medicalConditions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'medications',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'medications',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'medications',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'medications',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'medications',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'medications',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'medications',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'medications',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'medications', value: ''),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'medications', value: ''),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'medications', length, true, length, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'medications', 0, true, 0, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'medications', 0, false, 999999, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'medications', 0, true, length, include);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'medications', length, include, 999999, true);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  medicationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension MedicalProfileQueryObject
    on QueryBuilder<MedicalProfile, MedicalProfile, QFilterCondition> {}

extension MedicalProfileQueryLinks
    on QueryBuilder<MedicalProfile, MedicalProfile, QFilterCondition> {}

extension MedicalProfileQuerySortBy
    on QueryBuilder<MedicalProfile, MedicalProfile, QSortBy> {
  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy>
  sortByHasSignedConsent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSignedConsent', Sort.asc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy>
  sortByHasSignedConsentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSignedConsent', Sort.desc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MedicalProfileQuerySortThenBy
    on QueryBuilder<MedicalProfile, MedicalProfile, QSortThenBy> {
  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy>
  thenByHasSignedConsent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSignedConsent', Sort.asc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy>
  thenByHasSignedConsentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasSignedConsent', Sort.desc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MedicalProfileQueryWhereDistinct
    on QueryBuilder<MedicalProfile, MedicalProfile, QDistinct> {
  QueryBuilder<MedicalProfile, MedicalProfile, QDistinct>
  distinctByAllergies() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allergies');
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QDistinct>
  distinctByHasSignedConsent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasSignedConsent');
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QDistinct>
  distinctByMedicalConditions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicalConditions');
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QDistinct>
  distinctByMedications() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medications');
    });
  }

  QueryBuilder<MedicalProfile, MedicalProfile, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MedicalProfileQueryProperty
    on QueryBuilder<MedicalProfile, MedicalProfile, QQueryProperty> {
  QueryBuilder<MedicalProfile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MedicalProfile, List<String>, QQueryOperations>
  allergiesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allergies');
    });
  }

  QueryBuilder<MedicalProfile, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MedicalProfile, bool, QQueryOperations>
  hasSignedConsentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasSignedConsent');
    });
  }

  QueryBuilder<MedicalProfile, List<String>, QQueryOperations>
  medicalConditionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicalConditions');
    });
  }

  QueryBuilder<MedicalProfile, List<String>, QQueryOperations>
  medicationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medications');
    });
  }

  QueryBuilder<MedicalProfile, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetConciergePreferencesCollection on Isar {
  IsarCollection<ConciergePreferences> get conciergePreferences =>
      this.collection();
}

const ConciergePreferencesSchema = CollectionSchema(
  name: r'ConciergePreferences',
  id: -883058343996303665,
  properties: {
    r'coffeeOrTea': PropertySchema(
      id: 0,
      name: r'coffeeOrTea',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dietaryRestrictions': PropertySchema(
      id: 2,
      name: r'dietaryRestrictions',
      type: IsarType.stringList,
    ),
    r'roomTemperature': PropertySchema(
      id: 3,
      name: r'roomTemperature',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _conciergePreferencesEstimateSize,
  serialize: _conciergePreferencesSerialize,
  deserialize: _conciergePreferencesDeserialize,
  deserializeProp: _conciergePreferencesDeserializeProp,
  idName: r'id',
  indexes: {
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _conciergePreferencesGetId,
  getLinks: _conciergePreferencesGetLinks,
  attach: _conciergePreferencesAttach,
  version: '3.1.0+1',
);

int _conciergePreferencesEstimateSize(
  ConciergePreferences object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.coffeeOrTea.length * 3;
  bytesCount += 3 + object.dietaryRestrictions.length * 3;
  {
    for (var i = 0; i < object.dietaryRestrictions.length; i++) {
      final value = object.dietaryRestrictions[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.roomTemperature.length * 3;
  return bytesCount;
}

void _conciergePreferencesSerialize(
  ConciergePreferences object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.coffeeOrTea);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeStringList(offsets[2], object.dietaryRestrictions);
  writer.writeString(offsets[3], object.roomTemperature);
  writer.writeDateTime(offsets[4], object.updatedAt);
}

ConciergePreferences _conciergePreferencesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ConciergePreferences();
  object.coffeeOrTea = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.dietaryRestrictions = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.roomTemperature = reader.readString(offsets[3]);
  object.updatedAt = reader.readDateTime(offsets[4]);
  return object;
}

P _conciergePreferencesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _conciergePreferencesGetId(ConciergePreferences object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _conciergePreferencesGetLinks(
  ConciergePreferences object,
) {
  return [];
}

void _conciergePreferencesAttach(
  IsarCollection<dynamic> col,
  Id id,
  ConciergePreferences object,
) {
  object.id = id;
}

extension ConciergePreferencesQueryWhereSort
    on QueryBuilder<ConciergePreferences, ConciergePreferences, QWhere> {
  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhere>
  anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension ConciergePreferencesQueryWhere
    on QueryBuilder<ConciergePreferences, ConciergePreferences, QWhereClause> {
  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhereClause>
  createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'createdAt', value: [createdAt]),
      );
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhereClause>
  createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhereClause>
  createdAtGreaterThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [createdAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhereClause>
  createdAtLessThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [],
          upper: [createdAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterWhereClause>
  createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [lowerCreatedAt],
          includeLower: includeLower,
          upper: [upperCreatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ConciergePreferencesQueryFilter
    on
        QueryBuilder<
          ConciergePreferences,
          ConciergePreferences,
          QFilterCondition
        > {
  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  coffeeOrTeaEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coffeeOrTea',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  coffeeOrTeaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coffeeOrTea',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  coffeeOrTeaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coffeeOrTea',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  coffeeOrTeaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coffeeOrTea',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  coffeeOrTeaStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coffeeOrTea',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  coffeeOrTeaEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coffeeOrTea',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  coffeeOrTeaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coffeeOrTea',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  coffeeOrTeaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coffeeOrTea',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  coffeeOrTeaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coffeeOrTea', value: ''),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  coffeeOrTeaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'coffeeOrTea', value: ''),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dietaryRestrictions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dietaryRestrictions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dietaryRestrictions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dietaryRestrictions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dietaryRestrictions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dietaryRestrictions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsElementContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dietaryRestrictions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dietaryRestrictions',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dietaryRestrictions', value: ''),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'dietaryRestrictions',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dietaryRestrictions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'dietaryRestrictions', 0, true, 0, true);
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'dietaryRestrictions', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'dietaryRestrictions', 0, true, length, include);
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dietaryRestrictions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  dietaryRestrictionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dietaryRestrictions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  roomTemperatureEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'roomTemperature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  roomTemperatureGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'roomTemperature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  roomTemperatureLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'roomTemperature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  roomTemperatureBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'roomTemperature',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  roomTemperatureStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'roomTemperature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  roomTemperatureEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'roomTemperature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  roomTemperatureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'roomTemperature',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  roomTemperatureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'roomTemperature',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  roomTemperatureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'roomTemperature', value: ''),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  roomTemperatureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'roomTemperature', value: ''),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ConciergePreferences,
    ConciergePreferences,
    QAfterFilterCondition
  >
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ConciergePreferencesQueryObject
    on
        QueryBuilder<
          ConciergePreferences,
          ConciergePreferences,
          QFilterCondition
        > {}

extension ConciergePreferencesQueryLinks
    on
        QueryBuilder<
          ConciergePreferences,
          ConciergePreferences,
          QFilterCondition
        > {}

extension ConciergePreferencesQuerySortBy
    on QueryBuilder<ConciergePreferences, ConciergePreferences, QSortBy> {
  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  sortByCoffeeOrTea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coffeeOrTea', Sort.asc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  sortByCoffeeOrTeaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coffeeOrTea', Sort.desc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  sortByRoomTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roomTemperature', Sort.asc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  sortByRoomTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roomTemperature', Sort.desc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ConciergePreferencesQuerySortThenBy
    on QueryBuilder<ConciergePreferences, ConciergePreferences, QSortThenBy> {
  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  thenByCoffeeOrTea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coffeeOrTea', Sort.asc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  thenByCoffeeOrTeaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coffeeOrTea', Sort.desc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  thenByRoomTemperature() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roomTemperature', Sort.asc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  thenByRoomTemperatureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roomTemperature', Sort.desc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ConciergePreferencesQueryWhereDistinct
    on QueryBuilder<ConciergePreferences, ConciergePreferences, QDistinct> {
  QueryBuilder<ConciergePreferences, ConciergePreferences, QDistinct>
  distinctByCoffeeOrTea({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coffeeOrTea', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QDistinct>
  distinctByDietaryRestrictions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dietaryRestrictions');
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QDistinct>
  distinctByRoomTemperature({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'roomTemperature',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ConciergePreferences, ConciergePreferences, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ConciergePreferencesQueryProperty
    on
        QueryBuilder<
          ConciergePreferences,
          ConciergePreferences,
          QQueryProperty
        > {
  QueryBuilder<ConciergePreferences, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ConciergePreferences, String, QQueryOperations>
  coffeeOrTeaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coffeeOrTea');
    });
  }

  QueryBuilder<ConciergePreferences, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ConciergePreferences, List<String>, QQueryOperations>
  dietaryRestrictionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dietaryRestrictions');
    });
  }

  QueryBuilder<ConciergePreferences, String, QQueryOperations>
  roomTemperatureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roomTemperature');
    });
  }

  QueryBuilder<ConciergePreferences, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
