// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wird_history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWirdHistoryCollection on Isar {
  IsarCollection<WirdHistory> get wirdHistorys => this.collection();
}

const WirdHistorySchema = CollectionSchema(
  name: r'WirdHistory',
  id: -7569269835253382667,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'endPage': PropertySchema(
      id: 2,
      name: r'endPage',
      type: IsarType.long,
    ),
    r'isFullCompletion': PropertySchema(
      id: 3,
      name: r'isFullCompletion',
      type: IsarType.bool,
    ),
    r'startPage': PropertySchema(
      id: 4,
      name: r'startPage',
      type: IsarType.long,
    )
  },
  estimateSize: _wirdHistoryEstimateSize,
  serialize: _wirdHistorySerialize,
  deserialize: _wirdHistoryDeserialize,
  deserializeProp: _wirdHistoryDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _wirdHistoryGetId,
  getLinks: _wirdHistoryGetLinks,
  attach: _wirdHistoryAttach,
  version: '3.1.0+1',
);

int _wirdHistoryEstimateSize(
  WirdHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _wirdHistorySerialize(
  WirdHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeString(offsets[1], object.description);
  writer.writeLong(offsets[2], object.endPage);
  writer.writeBool(offsets[3], object.isFullCompletion);
  writer.writeLong(offsets[4], object.startPage);
}

WirdHistory _wirdHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WirdHistory();
  object.date = reader.readDateTime(offsets[0]);
  object.description = reader.readStringOrNull(offsets[1]);
  object.endPage = reader.readLong(offsets[2]);
  object.id = id;
  object.isFullCompletion = reader.readBool(offsets[3]);
  object.startPage = reader.readLong(offsets[4]);
  return object;
}

P _wirdHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _wirdHistoryGetId(WirdHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wirdHistoryGetLinks(WirdHistory object) {
  return [];
}

void _wirdHistoryAttach(
    IsarCollection<dynamic> col, Id id, WirdHistory object) {
  object.id = id;
}

extension WirdHistoryQueryWhereSort
    on QueryBuilder<WirdHistory, WirdHistory, QWhere> {
  QueryBuilder<WirdHistory, WirdHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension WirdHistoryQueryWhere
    on QueryBuilder<WirdHistory, WirdHistory, QWhereClause> {
  QueryBuilder<WirdHistory, WirdHistory, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<WirdHistory, WirdHistory, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterWhereClause> idBetween(
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

  QueryBuilder<WirdHistory, WirdHistory, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WirdHistoryQueryFilter
    on QueryBuilder<WirdHistory, WirdHistory, QFilterCondition> {
  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> endPageEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      endPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> endPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> endPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      isFullCompletionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFullCompletion',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      startPageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      startPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      startPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterFilterCondition>
      startPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WirdHistoryQueryObject
    on QueryBuilder<WirdHistory, WirdHistory, QFilterCondition> {}

extension WirdHistoryQueryLinks
    on QueryBuilder<WirdHistory, WirdHistory, QFilterCondition> {}

extension WirdHistoryQuerySortBy
    on QueryBuilder<WirdHistory, WirdHistory, QSortBy> {
  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> sortByEndPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPage', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> sortByEndPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPage', Sort.desc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy>
      sortByIsFullCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullCompletion', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy>
      sortByIsFullCompletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullCompletion', Sort.desc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> sortByStartPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startPage', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> sortByStartPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startPage', Sort.desc);
    });
  }
}

extension WirdHistoryQuerySortThenBy
    on QueryBuilder<WirdHistory, WirdHistory, QSortThenBy> {
  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> thenByEndPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPage', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> thenByEndPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPage', Sort.desc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy>
      thenByIsFullCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullCompletion', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy>
      thenByIsFullCompletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullCompletion', Sort.desc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> thenByStartPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startPage', Sort.asc);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QAfterSortBy> thenByStartPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startPage', Sort.desc);
    });
  }
}

extension WirdHistoryQueryWhereDistinct
    on QueryBuilder<WirdHistory, WirdHistory, QDistinct> {
  QueryBuilder<WirdHistory, WirdHistory, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QDistinct> distinctByEndPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endPage');
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QDistinct>
      distinctByIsFullCompletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFullCompletion');
    });
  }

  QueryBuilder<WirdHistory, WirdHistory, QDistinct> distinctByStartPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startPage');
    });
  }
}

extension WirdHistoryQueryProperty
    on QueryBuilder<WirdHistory, WirdHistory, QQueryProperty> {
  QueryBuilder<WirdHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WirdHistory, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<WirdHistory, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<WirdHistory, int, QQueryOperations> endPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endPage');
    });
  }

  QueryBuilder<WirdHistory, bool, QQueryOperations> isFullCompletionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFullCompletion');
    });
  }

  QueryBuilder<WirdHistory, int, QQueryOperations> startPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startPage');
    });
  }
}
