// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBookingModelCollection on Isar {
  IsarCollection<BookingModel> get bookingModels => this.collection();
}

const BookingModelSchema = CollectionSchema(
  name: r'BookingModel',
  id: 643181679485769242,
  properties: {
    r'endDateMillis': PropertySchema(
      id: 0,
      name: r'endDateMillis',
      type: IsarType.long,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'isCheckedIn': PropertySchema(
      id: 2,
      name: r'isCheckedIn',
      type: IsarType.bool,
    ),
    r'startDateMillis': PropertySchema(
      id: 3,
      name: r'startDateMillis',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(
      id: 4,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _bookingModelEstimateSize,
  serialize: _bookingModelSerialize,
  deserialize: _bookingModelDeserialize,
  deserializeProp: _bookingModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bookingModelGetId,
  getLinks: _bookingModelGetLinks,
  attach: _bookingModelAttach,
  version: '3.1.0+1',
);

int _bookingModelEstimateSize(
  BookingModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _bookingModelSerialize(
  BookingModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.endDateMillis);
  writer.writeString(offsets[1], object.id);
  writer.writeBool(offsets[2], object.isCheckedIn);
  writer.writeLong(offsets[3], object.startDateMillis);
  writer.writeString(offsets[4], object.userId);
}

BookingModel _bookingModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BookingModel();
  object.endDateMillis = reader.readLong(offsets[0]);
  object.id = reader.readString(offsets[1]);
  object.isCheckedIn = reader.readBool(offsets[2]);
  object.isarId = id;
  object.startDateMillis = reader.readLong(offsets[3]);
  object.userId = reader.readString(offsets[4]);
  return object;
}

P _bookingModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bookingModelGetId(BookingModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _bookingModelGetLinks(BookingModel object) {
  return [];
}

void _bookingModelAttach(
    IsarCollection<dynamic> col, Id id, BookingModel object) {
  object.isarId = id;
}

extension BookingModelByIndex on IsarCollection<BookingModel> {
  Future<BookingModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  BookingModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<BookingModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<BookingModel?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(BookingModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(BookingModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<BookingModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<BookingModel> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension BookingModelQueryWhereSort
    on QueryBuilder<BookingModel, BookingModel, QWhere> {
  QueryBuilder<BookingModel, BookingModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BookingModelQueryWhere
    on QueryBuilder<BookingModel, BookingModel, QWhereClause> {
  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> idNotEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> userIdEqualTo(
      String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterWhereClause> userIdNotEqualTo(
      String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BookingModelQueryFilter
    on QueryBuilder<BookingModel, BookingModel, QFilterCondition> {
  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      endDateMillisEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDateMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      endDateMillisGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDateMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      endDateMillisLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDateMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      endDateMillisBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDateMillis',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      isCheckedInEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCheckedIn',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      startDateMillisEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDateMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      startDateMillisGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDateMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      startDateMillisLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDateMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      startDateMillisBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDateMillis',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension BookingModelQueryObject
    on QueryBuilder<BookingModel, BookingModel, QFilterCondition> {}

extension BookingModelQueryLinks
    on QueryBuilder<BookingModel, BookingModel, QFilterCondition> {}

extension BookingModelQuerySortBy
    on QueryBuilder<BookingModel, BookingModel, QSortBy> {
  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByEndDateMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateMillis', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      sortByEndDateMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateMillis', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByIsCheckedIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCheckedIn', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      sortByIsCheckedInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCheckedIn', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      sortByStartDateMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateMillis', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      sortByStartDateMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateMillis', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BookingModelQuerySortThenBy
    on QueryBuilder<BookingModel, BookingModel, QSortThenBy> {
  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByEndDateMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateMillis', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      thenByEndDateMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateMillis', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByIsCheckedIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCheckedIn', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      thenByIsCheckedInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCheckedIn', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      thenByStartDateMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateMillis', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy>
      thenByStartDateMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDateMillis', Sort.desc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BookingModelQueryWhereDistinct
    on QueryBuilder<BookingModel, BookingModel, QDistinct> {
  QueryBuilder<BookingModel, BookingModel, QDistinct>
      distinctByEndDateMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDateMillis');
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByIsCheckedIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCheckedIn');
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct>
      distinctByStartDateMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDateMillis');
    });
  }

  QueryBuilder<BookingModel, BookingModel, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension BookingModelQueryProperty
    on QueryBuilder<BookingModel, BookingModel, QQueryProperty> {
  QueryBuilder<BookingModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<BookingModel, int, QQueryOperations> endDateMillisProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDateMillis');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BookingModel, bool, QQueryOperations> isCheckedInProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCheckedIn');
    });
  }

  QueryBuilder<BookingModel, int, QQueryOperations> startDateMillisProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDateMillis');
    });
  }

  QueryBuilder<BookingModel, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
