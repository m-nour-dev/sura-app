// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hifz_moment.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHifzMomentCollection on Isar {
  IsarCollection<HifzMoment> get hifzMoments => this.collection();
}

const HifzMomentSchema = CollectionSchema(
  name: r'HifzMoment',
  id: 2121716528828343482,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'feeling': PropertySchema(
      id: 1,
      name: r'feeling',
      type: IsarType.string,
    ),
    r'reflection': PropertySchema(
      id: 2,
      name: r'reflection',
      type: IsarType.string,
    ),
    r'surahIndex': PropertySchema(
      id: 3,
      name: r'surahIndex',
      type: IsarType.long,
    ),
    r'verseNumber': PropertySchema(
      id: 4,
      name: r'verseNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _hifzMomentEstimateSize,
  serialize: _hifzMomentSerialize,
  deserialize: _hifzMomentDeserialize,
  deserializeProp: _hifzMomentDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _hifzMomentGetId,
  getLinks: _hifzMomentGetLinks,
  attach: _hifzMomentAttach,
  version: '3.1.0+1',
);

int _hifzMomentEstimateSize(
  HifzMoment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.feeling.length * 3;
  bytesCount += 3 + object.reflection.length * 3;
  return bytesCount;
}

void _hifzMomentSerialize(
  HifzMoment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.feeling);
  writer.writeString(offsets[2], object.reflection);
  writer.writeLong(offsets[3], object.surahIndex);
  writer.writeLong(offsets[4], object.verseNumber);
}

HifzMoment _hifzMomentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HifzMoment();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.feeling = reader.readString(offsets[1]);
  object.id = id;
  object.reflection = reader.readString(offsets[2]);
  object.surahIndex = reader.readLong(offsets[3]);
  object.verseNumber = reader.readLong(offsets[4]);
  return object;
}

P _hifzMomentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hifzMomentGetId(HifzMoment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hifzMomentGetLinks(HifzMoment object) {
  return [];
}

void _hifzMomentAttach(IsarCollection<dynamic> col, Id id, HifzMoment object) {
  object.id = id;
}

extension HifzMomentQueryWhereSort
    on QueryBuilder<HifzMoment, HifzMoment, QWhere> {
  QueryBuilder<HifzMoment, HifzMoment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HifzMomentQueryWhere
    on QueryBuilder<HifzMoment, HifzMoment, QWhereClause> {
  QueryBuilder<HifzMoment, HifzMoment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<HifzMoment, HifzMoment, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterWhereClause> idBetween(
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
}

extension HifzMomentQueryFilter
    on QueryBuilder<HifzMoment, HifzMoment, QFilterCondition> {
  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> feelingEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      feelingGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'feeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> feelingLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'feeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> feelingBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'feeling',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> feelingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'feeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> feelingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'feeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> feelingContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'feeling',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> feelingMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'feeling',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> feelingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'feeling',
        value: '',
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      feelingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'feeling',
        value: '',
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> reflectionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      reflectionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      reflectionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> reflectionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reflection',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      reflectionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      reflectionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      reflectionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> reflectionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reflection',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      reflectionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reflection',
        value: '',
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      reflectionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reflection',
        value: '',
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> surahIndexEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      surahIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      surahIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition> surahIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      verseNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      verseNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      verseNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterFilterCondition>
      verseNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HifzMomentQueryObject
    on QueryBuilder<HifzMoment, HifzMoment, QFilterCondition> {}

extension HifzMomentQueryLinks
    on QueryBuilder<HifzMoment, HifzMoment, QFilterCondition> {}

extension HifzMomentQuerySortBy
    on QueryBuilder<HifzMoment, HifzMoment, QSortBy> {
  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> sortByFeeling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeling', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> sortByFeelingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeling', Sort.desc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> sortByReflection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reflection', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> sortByReflectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reflection', Sort.desc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> sortBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> sortBySurahIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.desc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> sortByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> sortByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }
}

extension HifzMomentQuerySortThenBy
    on QueryBuilder<HifzMoment, HifzMoment, QSortThenBy> {
  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenByFeeling() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeling', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenByFeelingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'feeling', Sort.desc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenByReflection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reflection', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenByReflectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reflection', Sort.desc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenBySurahIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.desc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QAfterSortBy> thenByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }
}

extension HifzMomentQueryWhereDistinct
    on QueryBuilder<HifzMoment, HifzMoment, QDistinct> {
  QueryBuilder<HifzMoment, HifzMoment, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QDistinct> distinctByFeeling(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'feeling', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QDistinct> distinctByReflection(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reflection', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QDistinct> distinctBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahIndex');
    });
  }

  QueryBuilder<HifzMoment, HifzMoment, QDistinct> distinctByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseNumber');
    });
  }
}

extension HifzMomentQueryProperty
    on QueryBuilder<HifzMoment, HifzMoment, QQueryProperty> {
  QueryBuilder<HifzMoment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HifzMoment, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<HifzMoment, String, QQueryOperations> feelingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'feeling');
    });
  }

  QueryBuilder<HifzMoment, String, QQueryOperations> reflectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reflection');
    });
  }

  QueryBuilder<HifzMoment, int, QQueryOperations> surahIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahIndex');
    });
  }

  QueryBuilder<HifzMoment, int, QQueryOperations> verseNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseNumber');
    });
  }
}
