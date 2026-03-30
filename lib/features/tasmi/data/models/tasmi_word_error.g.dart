// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasmi_word_error.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTasmiWordErrorCollection on Isar {
  IsarCollection<TasmiWordError> get tasmiWordErrors => this.collection();
}

const TasmiWordErrorSchema = CollectionSchema(
  name: r'TasmiWordError',
  id: 2677639373556515737,
  properties: {
    r'correctWord': PropertySchema(
      id: 0,
      name: r'correctWord',
      type: IsarType.string,
    ),
    r'errorTypeIndex': PropertySchema(
      id: 1,
      name: r'errorTypeIndex',
      type: IsarType.long,
    ),
    r'spokenWord': PropertySchema(
      id: 2,
      name: r'spokenWord',
      type: IsarType.string,
    ),
    r'surahIndex': PropertySchema(
      id: 3,
      name: r'surahIndex',
      type: IsarType.long,
    ),
    r'timestamp': PropertySchema(
      id: 4,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'verseNumber': PropertySchema(
      id: 5,
      name: r'verseNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _tasmiWordErrorEstimateSize,
  serialize: _tasmiWordErrorSerialize,
  deserialize: _tasmiWordErrorDeserialize,
  deserializeProp: _tasmiWordErrorDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _tasmiWordErrorGetId,
  getLinks: _tasmiWordErrorGetLinks,
  attach: _tasmiWordErrorAttach,
  version: '3.1.0+1',
);

int _tasmiWordErrorEstimateSize(
  TasmiWordError object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.correctWord.length * 3;
  bytesCount += 3 + object.spokenWord.length * 3;
  return bytesCount;
}

void _tasmiWordErrorSerialize(
  TasmiWordError object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.correctWord);
  writer.writeLong(offsets[1], object.errorTypeIndex);
  writer.writeString(offsets[2], object.spokenWord);
  writer.writeLong(offsets[3], object.surahIndex);
  writer.writeDateTime(offsets[4], object.timestamp);
  writer.writeLong(offsets[5], object.verseNumber);
}

TasmiWordError _tasmiWordErrorDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TasmiWordError();
  object.correctWord = reader.readString(offsets[0]);
  object.errorTypeIndex = reader.readLong(offsets[1]);
  object.id = id;
  object.spokenWord = reader.readString(offsets[2]);
  object.surahIndex = reader.readLong(offsets[3]);
  object.timestamp = reader.readDateTime(offsets[4]);
  object.verseNumber = reader.readLong(offsets[5]);
  return object;
}

P _tasmiWordErrorDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tasmiWordErrorGetId(TasmiWordError object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tasmiWordErrorGetLinks(TasmiWordError object) {
  return [];
}

void _tasmiWordErrorAttach(
    IsarCollection<dynamic> col, Id id, TasmiWordError object) {
  object.id = id;
}

extension TasmiWordErrorQueryWhereSort
    on QueryBuilder<TasmiWordError, TasmiWordError, QWhere> {
  QueryBuilder<TasmiWordError, TasmiWordError, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TasmiWordErrorQueryWhere
    on QueryBuilder<TasmiWordError, TasmiWordError, QWhereClause> {
  QueryBuilder<TasmiWordError, TasmiWordError, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterWhereClause> idBetween(
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

extension TasmiWordErrorQueryFilter
    on QueryBuilder<TasmiWordError, TasmiWordError, QFilterCondition> {
  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      correctWordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'correctWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      correctWordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'correctWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      correctWordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'correctWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      correctWordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'correctWord',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      correctWordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'correctWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      correctWordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'correctWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      correctWordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'correctWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      correctWordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'correctWord',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      correctWordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'correctWord',
        value: '',
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      correctWordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'correctWord',
        value: '',
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      errorTypeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      errorTypeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'errorTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      errorTypeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'errorTypeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      errorTypeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'errorTypeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
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

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
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

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      spokenWordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spokenWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      spokenWordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'spokenWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      spokenWordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'spokenWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      spokenWordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'spokenWord',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      spokenWordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'spokenWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      spokenWordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'spokenWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      spokenWordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'spokenWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      spokenWordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'spokenWord',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      spokenWordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spokenWord',
        value: '',
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      spokenWordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'spokenWord',
        value: '',
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      surahIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
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

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
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

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      surahIndexBetween(
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

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
      verseNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
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

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
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

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterFilterCondition>
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

extension TasmiWordErrorQueryObject
    on QueryBuilder<TasmiWordError, TasmiWordError, QFilterCondition> {}

extension TasmiWordErrorQueryLinks
    on QueryBuilder<TasmiWordError, TasmiWordError, QFilterCondition> {}

extension TasmiWordErrorQuerySortBy
    on QueryBuilder<TasmiWordError, TasmiWordError, QSortBy> {
  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortByCorrectWord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctWord', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortByCorrectWordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctWord', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortByErrorTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorTypeIndex', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortByErrorTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorTypeIndex', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortBySpokenWord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spokenWord', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortBySpokenWordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spokenWord', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortBySurahIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      sortByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }
}

extension TasmiWordErrorQuerySortThenBy
    on QueryBuilder<TasmiWordError, TasmiWordError, QSortThenBy> {
  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenByCorrectWord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctWord', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenByCorrectWordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctWord', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenByErrorTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorTypeIndex', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenByErrorTypeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorTypeIndex', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenBySpokenWord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spokenWord', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenBySpokenWordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spokenWord', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenBySurahIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QAfterSortBy>
      thenByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }
}

extension TasmiWordErrorQueryWhereDistinct
    on QueryBuilder<TasmiWordError, TasmiWordError, QDistinct> {
  QueryBuilder<TasmiWordError, TasmiWordError, QDistinct> distinctByCorrectWord(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correctWord', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QDistinct>
      distinctByErrorTypeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorTypeIndex');
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QDistinct> distinctBySpokenWord(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'spokenWord', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QDistinct>
      distinctBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahIndex');
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<TasmiWordError, TasmiWordError, QDistinct>
      distinctByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseNumber');
    });
  }
}

extension TasmiWordErrorQueryProperty
    on QueryBuilder<TasmiWordError, TasmiWordError, QQueryProperty> {
  QueryBuilder<TasmiWordError, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TasmiWordError, String, QQueryOperations> correctWordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correctWord');
    });
  }

  QueryBuilder<TasmiWordError, int, QQueryOperations> errorTypeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorTypeIndex');
    });
  }

  QueryBuilder<TasmiWordError, String, QQueryOperations> spokenWordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'spokenWord');
    });
  }

  QueryBuilder<TasmiWordError, int, QQueryOperations> surahIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahIndex');
    });
  }

  QueryBuilder<TasmiWordError, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<TasmiWordError, int, QQueryOperations> verseNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseNumber');
    });
  }
}
