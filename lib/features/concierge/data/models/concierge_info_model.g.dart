// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concierge_info_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetConciergeInfoModelCollection on Isar {
  IsarCollection<ConciergeInfoModel> get conciergeInfoModels =>
      this.collection();
}

const ConciergeInfoModelSchema = CollectionSchema(
  name: r'ConciergeInfoModel',
  id: -7290458879063234416,
  properties: {
    r'bookingId': PropertySchema(
      id: 0,
      name: r'bookingId',
      type: IsarType.string,
    ),
    r'checkInInstructions': PropertySchema(
      id: 1,
      name: r'checkInInstructions',
      type: IsarType.string,
    ),
    r'driverName': PropertySchema(
      id: 2,
      name: r'driverName',
      type: IsarType.string,
    ),
    r'driverPhone': PropertySchema(
      id: 3,
      name: r'driverPhone',
      type: IsarType.string,
    ),
    r'villaAddress': PropertySchema(
      id: 4,
      name: r'villaAddress',
      type: IsarType.string,
    ),
    r'villaImageUrl': PropertySchema(
      id: 5,
      name: r'villaImageUrl',
      type: IsarType.string,
    )
  },
  estimateSize: _conciergeInfoModelEstimateSize,
  serialize: _conciergeInfoModelSerialize,
  deserialize: _conciergeInfoModelDeserialize,
  deserializeProp: _conciergeInfoModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'bookingId': IndexSchema(
      id: 4804924406505946939,
      name: r'bookingId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bookingId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _conciergeInfoModelGetId,
  getLinks: _conciergeInfoModelGetLinks,
  attach: _conciergeInfoModelAttach,
  version: '3.1.0+1',
);

int _conciergeInfoModelEstimateSize(
  ConciergeInfoModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookingId.length * 3;
  bytesCount += 3 + object.checkInInstructions.length * 3;
  bytesCount += 3 + object.driverName.length * 3;
  bytesCount += 3 + object.driverPhone.length * 3;
  bytesCount += 3 + object.villaAddress.length * 3;
  bytesCount += 3 + object.villaImageUrl.length * 3;
  return bytesCount;
}

void _conciergeInfoModelSerialize(
  ConciergeInfoModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bookingId);
  writer.writeString(offsets[1], object.checkInInstructions);
  writer.writeString(offsets[2], object.driverName);
  writer.writeString(offsets[3], object.driverPhone);
  writer.writeString(offsets[4], object.villaAddress);
  writer.writeString(offsets[5], object.villaImageUrl);
}

ConciergeInfoModel _conciergeInfoModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ConciergeInfoModel();
  object.bookingId = reader.readString(offsets[0]);
  object.checkInInstructions = reader.readString(offsets[1]);
  object.driverName = reader.readString(offsets[2]);
  object.driverPhone = reader.readString(offsets[3]);
  object.isarId = id;
  object.villaAddress = reader.readString(offsets[4]);
  object.villaImageUrl = reader.readString(offsets[5]);
  return object;
}

P _conciergeInfoModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _conciergeInfoModelGetId(ConciergeInfoModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _conciergeInfoModelGetLinks(
    ConciergeInfoModel object) {
  return [];
}

void _conciergeInfoModelAttach(
    IsarCollection<dynamic> col, Id id, ConciergeInfoModel object) {
  object.isarId = id;
}

extension ConciergeInfoModelByIndex on IsarCollection<ConciergeInfoModel> {
  Future<ConciergeInfoModel?> getByBookingId(String bookingId) {
    return getByIndex(r'bookingId', [bookingId]);
  }

  ConciergeInfoModel? getByBookingIdSync(String bookingId) {
    return getByIndexSync(r'bookingId', [bookingId]);
  }

  Future<bool> deleteByBookingId(String bookingId) {
    return deleteByIndex(r'bookingId', [bookingId]);
  }

  bool deleteByBookingIdSync(String bookingId) {
    return deleteByIndexSync(r'bookingId', [bookingId]);
  }

  Future<List<ConciergeInfoModel?>> getAllByBookingId(
      List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'bookingId', values);
  }

  List<ConciergeInfoModel?> getAllByBookingIdSync(
      List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'bookingId', values);
  }

  Future<int> deleteAllByBookingId(List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'bookingId', values);
  }

  int deleteAllByBookingIdSync(List<String> bookingIdValues) {
    final values = bookingIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'bookingId', values);
  }

  Future<Id> putByBookingId(ConciergeInfoModel object) {
    return putByIndex(r'bookingId', object);
  }

  Id putByBookingIdSync(ConciergeInfoModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'bookingId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByBookingId(List<ConciergeInfoModel> objects) {
    return putAllByIndex(r'bookingId', objects);
  }

  List<Id> putAllByBookingIdSync(List<ConciergeInfoModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'bookingId', objects, saveLinks: saveLinks);
  }
}

extension ConciergeInfoModelQueryWhereSort
    on QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QWhere> {
  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ConciergeInfoModelQueryWhere
    on QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QWhereClause> {
  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterWhereClause>
      bookingIdEqualTo(String bookingId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookingId',
        value: [bookingId],
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterWhereClause>
      bookingIdNotEqualTo(String bookingId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingId',
              lower: [],
              upper: [bookingId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingId',
              lower: [bookingId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingId',
              lower: [bookingId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookingId',
              lower: [],
              upper: [bookingId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ConciergeInfoModelQueryFilter
    on QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QFilterCondition> {
  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      bookingIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      bookingIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      bookingIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      bookingIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookingId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      bookingIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      bookingIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      bookingIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookingId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      bookingIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookingId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      bookingIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookingId',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      bookingIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookingId',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      checkInInstructionsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkInInstructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      checkInInstructionsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checkInInstructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      checkInInstructionsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checkInInstructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      checkInInstructionsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checkInInstructions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      checkInInstructionsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checkInInstructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      checkInInstructionsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checkInInstructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      checkInInstructionsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checkInInstructions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      checkInInstructionsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checkInInstructions',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      checkInInstructionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checkInInstructions',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      checkInInstructionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checkInInstructions',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'driverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'driverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'driverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'driverName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'driverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'driverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'driverName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'driverName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'driverName',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'driverName',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverPhoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'driverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverPhoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'driverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverPhoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'driverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverPhoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'driverPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'driverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'driverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'driverPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'driverPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'driverPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      driverPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'driverPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaAddressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'villaAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaAddressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'villaAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaAddressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'villaAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaAddressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'villaAddress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaAddressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'villaAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaAddressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'villaAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaAddressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'villaAddress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaAddressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'villaAddress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaAddressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'villaAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaAddressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'villaAddress',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaImageUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'villaImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaImageUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'villaImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaImageUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'villaImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaImageUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'villaImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'villaImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'villaImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaImageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'villaImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaImageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'villaImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'villaImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterFilterCondition>
      villaImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'villaImageUrl',
        value: '',
      ));
    });
  }
}

extension ConciergeInfoModelQueryObject
    on QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QFilterCondition> {}

extension ConciergeInfoModelQueryLinks
    on QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QFilterCondition> {}

extension ConciergeInfoModelQuerySortBy
    on QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QSortBy> {
  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByBookingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByBookingIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByCheckInInstructions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInInstructions', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByCheckInInstructionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInInstructions', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByDriverName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverName', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByDriverNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverName', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByDriverPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverPhone', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByDriverPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverPhone', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByVillaAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'villaAddress', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByVillaAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'villaAddress', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByVillaImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'villaImageUrl', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      sortByVillaImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'villaImageUrl', Sort.desc);
    });
  }
}

extension ConciergeInfoModelQuerySortThenBy
    on QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QSortThenBy> {
  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByBookingId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByBookingIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingId', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByCheckInInstructions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInInstructions', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByCheckInInstructionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkInInstructions', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByDriverName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverName', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByDriverNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverName', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByDriverPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverPhone', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByDriverPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driverPhone', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByVillaAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'villaAddress', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByVillaAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'villaAddress', Sort.desc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByVillaImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'villaImageUrl', Sort.asc);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QAfterSortBy>
      thenByVillaImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'villaImageUrl', Sort.desc);
    });
  }
}

extension ConciergeInfoModelQueryWhereDistinct
    on QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QDistinct> {
  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QDistinct>
      distinctByBookingId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookingId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QDistinct>
      distinctByCheckInInstructions({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkInInstructions',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QDistinct>
      distinctByDriverName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'driverName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QDistinct>
      distinctByDriverPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'driverPhone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QDistinct>
      distinctByVillaAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'villaAddress', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QDistinct>
      distinctByVillaImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'villaImageUrl',
          caseSensitive: caseSensitive);
    });
  }
}

extension ConciergeInfoModelQueryProperty
    on QueryBuilder<ConciergeInfoModel, ConciergeInfoModel, QQueryProperty> {
  QueryBuilder<ConciergeInfoModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ConciergeInfoModel, String, QQueryOperations>
      bookingIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookingId');
    });
  }

  QueryBuilder<ConciergeInfoModel, String, QQueryOperations>
      checkInInstructionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkInInstructions');
    });
  }

  QueryBuilder<ConciergeInfoModel, String, QQueryOperations>
      driverNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'driverName');
    });
  }

  QueryBuilder<ConciergeInfoModel, String, QQueryOperations>
      driverPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'driverPhone');
    });
  }

  QueryBuilder<ConciergeInfoModel, String, QQueryOperations>
      villaAddressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'villaAddress');
    });
  }

  QueryBuilder<ConciergeInfoModel, String, QQueryOperations>
      villaImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'villaImageUrl');
    });
  }
}
