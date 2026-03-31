// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mujahadah_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMujahadahRecordCollection on Isar {
  IsarCollection<MujahadahRecord> get mujahadahRecords => this.collection();
}

const MujahadahRecordSchema = CollectionSchema(
  name: r'MujahadahRecord',
  id: 5827748971629324194,
  properties: {
    r'currentStreak': PropertySchema(
      id: 0,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'lastCheckInDate': PropertySchema(
      id: 1,
      name: r'lastCheckInDate',
      type: IsarType.dateTime,
    ),
    r'lastRelapseDate': PropertySchema(
      id: 2,
      name: r'lastRelapseDate',
      type: IsarType.dateTime,
    ),
    r'longestStreak': PropertySchema(
      id: 3,
      name: r'longestStreak',
      type: IsarType.long,
    ),
    r'startDate': PropertySchema(
      id: 4,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 5,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _mujahadahRecordEstimateSize,
  serialize: _mujahadahRecordSerialize,
  deserialize: _mujahadahRecordDeserialize,
  deserializeProp: _mujahadahRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mujahadahRecordGetId,
  getLinks: _mujahadahRecordGetLinks,
  attach: _mujahadahRecordAttach,
  version: '3.1.0+1',
);

int _mujahadahRecordEstimateSize(
  MujahadahRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _mujahadahRecordSerialize(
  MujahadahRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.currentStreak);
  writer.writeDateTime(offsets[1], object.lastCheckInDate);
  writer.writeDateTime(offsets[2], object.lastRelapseDate);
  writer.writeLong(offsets[3], object.longestStreak);
  writer.writeDateTime(offsets[4], object.startDate);
  writer.writeString(offsets[5], object.title);
}

MujahadahRecord _mujahadahRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MujahadahRecord();
  object.currentStreak = reader.readLong(offsets[0]);
  object.id = id;
  object.lastCheckInDate = reader.readDateTimeOrNull(offsets[1]);
  object.lastRelapseDate = reader.readDateTimeOrNull(offsets[2]);
  object.longestStreak = reader.readLong(offsets[3]);
  object.startDate = reader.readDateTime(offsets[4]);
  object.title = reader.readString(offsets[5]);
  return object;
}

P _mujahadahRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mujahadahRecordGetId(MujahadahRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mujahadahRecordGetLinks(MujahadahRecord object) {
  return [];
}

void _mujahadahRecordAttach(
    IsarCollection<dynamic> col, Id id, MujahadahRecord object) {
  object.id = id;
}

extension MujahadahRecordByIndex on IsarCollection<MujahadahRecord> {
  Future<MujahadahRecord?> getByTitle(String title) {
    return getByIndex(r'title', [title]);
  }

  MujahadahRecord? getByTitleSync(String title) {
    return getByIndexSync(r'title', [title]);
  }

  Future<bool> deleteByTitle(String title) {
    return deleteByIndex(r'title', [title]);
  }

  bool deleteByTitleSync(String title) {
    return deleteByIndexSync(r'title', [title]);
  }

  Future<List<MujahadahRecord?>> getAllByTitle(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return getAllByIndex(r'title', values);
  }

  List<MujahadahRecord?> getAllByTitleSync(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'title', values);
  }

  Future<int> deleteAllByTitle(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'title', values);
  }

  int deleteAllByTitleSync(List<String> titleValues) {
    final values = titleValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'title', values);
  }

  Future<Id> putByTitle(MujahadahRecord object) {
    return putByIndex(r'title', object);
  }

  Id putByTitleSync(MujahadahRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'title', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTitle(List<MujahadahRecord> objects) {
    return putAllByIndex(r'title', objects);
  }

  List<Id> putAllByTitleSync(List<MujahadahRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'title', objects, saveLinks: saveLinks);
  }
}

extension MujahadahRecordQueryWhereSort
    on QueryBuilder<MujahadahRecord, MujahadahRecord, QWhere> {
  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MujahadahRecordQueryWhere
    on QueryBuilder<MujahadahRecord, MujahadahRecord, QWhereClause> {
  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterWhereClause>
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

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterWhereClause>
      titleEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [title],
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterWhereClause>
      titleNotEqualTo(String title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MujahadahRecordQueryFilter
    on QueryBuilder<MujahadahRecord, MujahadahRecord, QFilterCondition> {
  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastCheckInDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCheckInDate',
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastCheckInDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCheckInDate',
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastCheckInDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCheckInDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastCheckInDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCheckInDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastCheckInDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCheckInDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastCheckInDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCheckInDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastRelapseDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastRelapseDate',
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastRelapseDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastRelapseDate',
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastRelapseDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastRelapseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastRelapseDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastRelapseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastRelapseDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastRelapseDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      lastRelapseDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastRelapseDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      longestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      longestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      longestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      longestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension MujahadahRecordQueryObject
    on QueryBuilder<MujahadahRecord, MujahadahRecord, QFilterCondition> {}

extension MujahadahRecordQueryLinks
    on QueryBuilder<MujahadahRecord, MujahadahRecord, QFilterCondition> {}

extension MujahadahRecordQuerySortBy
    on QueryBuilder<MujahadahRecord, MujahadahRecord, QSortBy> {
  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByLastCheckInDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInDate', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByLastCheckInDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInDate', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByLastRelapseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelapseDate', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByLastRelapseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelapseDate', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension MujahadahRecordQuerySortThenBy
    on QueryBuilder<MujahadahRecord, MujahadahRecord, QSortThenBy> {
  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByLastCheckInDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInDate', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByLastCheckInDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCheckInDate', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByLastRelapseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelapseDate', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByLastRelapseDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastRelapseDate', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension MujahadahRecordQueryWhereDistinct
    on QueryBuilder<MujahadahRecord, MujahadahRecord, QDistinct> {
  QueryBuilder<MujahadahRecord, MujahadahRecord, QDistinct>
      distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QDistinct>
      distinctByLastCheckInDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCheckInDate');
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QDistinct>
      distinctByLastRelapseDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastRelapseDate');
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QDistinct>
      distinctByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longestStreak');
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QDistinct>
      distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<MujahadahRecord, MujahadahRecord, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension MujahadahRecordQueryProperty
    on QueryBuilder<MujahadahRecord, MujahadahRecord, QQueryProperty> {
  QueryBuilder<MujahadahRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MujahadahRecord, int, QQueryOperations> currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<MujahadahRecord, DateTime?, QQueryOperations>
      lastCheckInDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCheckInDate');
    });
  }

  QueryBuilder<MujahadahRecord, DateTime?, QQueryOperations>
      lastRelapseDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastRelapseDate');
    });
  }

  QueryBuilder<MujahadahRecord, int, QQueryOperations> longestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longestStreak');
    });
  }

  QueryBuilder<MujahadahRecord, DateTime, QQueryOperations>
      startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<MujahadahRecord, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
