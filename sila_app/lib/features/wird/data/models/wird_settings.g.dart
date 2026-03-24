// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wird_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWirdSettingsCollection on Isar {
  IsarCollection<WirdSettings> get wirdSettings => this.collection();
}

const WirdSettingsSchema = CollectionSchema(
  name: r'WirdSettings',
  id: 5980852363758198336,
  properties: {
    r'bookmarkPage': PropertySchema(
      id: 0,
      name: r'bookmarkPage',
      type: IsarType.long,
    ),
    r'currentPage': PropertySchema(
      id: 1,
      name: r'currentPage',
      type: IsarType.long,
    ),
    r'goalType': PropertySchema(
      id: 2,
      name: r'goalType',
      type: IsarType.byte,
      enumMap: _WirdSettingsgoalTypeEnumValueMap,
    ),
    r'goalValue': PropertySchema(
      id: 3,
      name: r'goalValue',
      type: IsarType.long,
    ),
    r'hasConfiguredGoal': PropertySchema(
      id: 4,
      name: r'hasConfiguredGoal',
      type: IsarType.bool,
    ),
    r'khatmaStartDate': PropertySchema(
      id: 5,
      name: r'khatmaStartDate',
      type: IsarType.dateTime,
    ),
    r'lastCompletionDate': PropertySchema(
      id: 6,
      name: r'lastCompletionDate',
      type: IsarType.dateTime,
    ),
    r'pagesPerDay': PropertySchema(
      id: 7,
      name: r'pagesPerDay',
      type: IsarType.long,
    )
  },
  estimateSize: _wirdSettingsEstimateSize,
  serialize: _wirdSettingsSerialize,
  deserialize: _wirdSettingsDeserialize,
  deserializeProp: _wirdSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _wirdSettingsGetId,
  getLinks: _wirdSettingsGetLinks,
  attach: _wirdSettingsAttach,
  version: '3.1.0+1',
);

int _wirdSettingsEstimateSize(
  WirdSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _wirdSettingsSerialize(
  WirdSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bookmarkPage);
  writer.writeLong(offsets[1], object.currentPage);
  writer.writeByte(offsets[2], object.goalType.index);
  writer.writeLong(offsets[3], object.goalValue);
  writer.writeBool(offsets[4], object.hasConfiguredGoal);
  writer.writeDateTime(offsets[5], object.khatmaStartDate);
  writer.writeDateTime(offsets[6], object.lastCompletionDate);
  writer.writeLong(offsets[7], object.pagesPerDay);
}

WirdSettings _wirdSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WirdSettings();
  object.bookmarkPage = reader.readLongOrNull(offsets[0]);
  object.currentPage = reader.readLong(offsets[1]);
  object.goalType =
      _WirdSettingsgoalTypeValueEnumMap[reader.readByteOrNull(offsets[2])] ??
          WirdGoalType.page;
  object.goalValue = reader.readLong(offsets[3]);
  object.hasConfiguredGoal = reader.readBool(offsets[4]);
  object.id = id;
  object.khatmaStartDate = reader.readDateTimeOrNull(offsets[5]);
  object.lastCompletionDate = reader.readDateTimeOrNull(offsets[6]);
  object.pagesPerDay = reader.readLong(offsets[7]);
  return object;
}

P _wirdSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (_WirdSettingsgoalTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          WirdGoalType.page) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _WirdSettingsgoalTypeEnumValueMap = {
  'page': 0,
  'juz': 1,
  'hizb': 2,
};
const _WirdSettingsgoalTypeValueEnumMap = {
  0: WirdGoalType.page,
  1: WirdGoalType.juz,
  2: WirdGoalType.hizb,
};

Id _wirdSettingsGetId(WirdSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wirdSettingsGetLinks(WirdSettings object) {
  return [];
}

void _wirdSettingsAttach(
    IsarCollection<dynamic> col, Id id, WirdSettings object) {
  object.id = id;
}

extension WirdSettingsQueryWhereSort
    on QueryBuilder<WirdSettings, WirdSettings, QWhere> {
  QueryBuilder<WirdSettings, WirdSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WirdSettingsQueryWhere
    on QueryBuilder<WirdSettings, WirdSettings, QWhereClause> {
  QueryBuilder<WirdSettings, WirdSettings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<WirdSettings, WirdSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterWhereClause> idBetween(
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

extension WirdSettingsQueryFilter
    on QueryBuilder<WirdSettings, WirdSettings, QFilterCondition> {
  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      bookmarkPageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bookmarkPage',
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      bookmarkPageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bookmarkPage',
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      bookmarkPageEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookmarkPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      bookmarkPageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookmarkPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      bookmarkPageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookmarkPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      bookmarkPageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookmarkPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      currentPageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      currentPageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      currentPageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentPage',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      currentPageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentPage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      goalTypeEqualTo(WirdGoalType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalType',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      goalTypeGreaterThan(
    WirdGoalType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalType',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      goalTypeLessThan(
    WirdGoalType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalType',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      goalTypeBetween(
    WirdGoalType lower,
    WirdGoalType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      goalValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goalValue',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      goalValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goalValue',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      goalValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goalValue',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      goalValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goalValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      hasConfiguredGoalEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasConfiguredGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      khatmaStartDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'khatmaStartDate',
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      khatmaStartDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'khatmaStartDate',
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      khatmaStartDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'khatmaStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      khatmaStartDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'khatmaStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      khatmaStartDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'khatmaStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      khatmaStartDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'khatmaStartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      lastCompletionDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCompletionDate',
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      lastCompletionDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCompletionDate',
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      lastCompletionDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCompletionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      lastCompletionDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCompletionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      lastCompletionDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCompletionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      lastCompletionDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCompletionDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      pagesPerDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pagesPerDay',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      pagesPerDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pagesPerDay',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      pagesPerDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pagesPerDay',
        value: value,
      ));
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterFilterCondition>
      pagesPerDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pagesPerDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WirdSettingsQueryObject
    on QueryBuilder<WirdSettings, WirdSettings, QFilterCondition> {}

extension WirdSettingsQueryLinks
    on QueryBuilder<WirdSettings, WirdSettings, QFilterCondition> {}

extension WirdSettingsQuerySortBy
    on QueryBuilder<WirdSettings, WirdSettings, QSortBy> {
  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> sortByBookmarkPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarkPage', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      sortByBookmarkPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarkPage', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> sortByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      sortByCurrentPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> sortByGoalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalType', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> sortByGoalTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalType', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> sortByGoalValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalValue', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> sortByGoalValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalValue', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      sortByHasConfiguredGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasConfiguredGoal', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      sortByHasConfiguredGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasConfiguredGoal', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      sortByKhatmaStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'khatmaStartDate', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      sortByKhatmaStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'khatmaStartDate', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      sortByLastCompletionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletionDate', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      sortByLastCompletionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletionDate', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> sortByPagesPerDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pagesPerDay', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      sortByPagesPerDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pagesPerDay', Sort.desc);
    });
  }
}

extension WirdSettingsQuerySortThenBy
    on QueryBuilder<WirdSettings, WirdSettings, QSortThenBy> {
  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> thenByBookmarkPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarkPage', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      thenByBookmarkPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookmarkPage', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> thenByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      thenByCurrentPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPage', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> thenByGoalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalType', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> thenByGoalTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalType', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> thenByGoalValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalValue', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> thenByGoalValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goalValue', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      thenByHasConfiguredGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasConfiguredGoal', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      thenByHasConfiguredGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasConfiguredGoal', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      thenByKhatmaStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'khatmaStartDate', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      thenByKhatmaStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'khatmaStartDate', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      thenByLastCompletionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletionDate', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      thenByLastCompletionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletionDate', Sort.desc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy> thenByPagesPerDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pagesPerDay', Sort.asc);
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QAfterSortBy>
      thenByPagesPerDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pagesPerDay', Sort.desc);
    });
  }
}

extension WirdSettingsQueryWhereDistinct
    on QueryBuilder<WirdSettings, WirdSettings, QDistinct> {
  QueryBuilder<WirdSettings, WirdSettings, QDistinct> distinctByBookmarkPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookmarkPage');
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QDistinct> distinctByCurrentPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPage');
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QDistinct> distinctByGoalType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalType');
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QDistinct> distinctByGoalValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goalValue');
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QDistinct>
      distinctByHasConfiguredGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasConfiguredGoal');
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QDistinct>
      distinctByKhatmaStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'khatmaStartDate');
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QDistinct>
      distinctByLastCompletionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCompletionDate');
    });
  }

  QueryBuilder<WirdSettings, WirdSettings, QDistinct> distinctByPagesPerDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pagesPerDay');
    });
  }
}

extension WirdSettingsQueryProperty
    on QueryBuilder<WirdSettings, WirdSettings, QQueryProperty> {
  QueryBuilder<WirdSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WirdSettings, int?, QQueryOperations> bookmarkPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookmarkPage');
    });
  }

  QueryBuilder<WirdSettings, int, QQueryOperations> currentPageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPage');
    });
  }

  QueryBuilder<WirdSettings, WirdGoalType, QQueryOperations>
      goalTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalType');
    });
  }

  QueryBuilder<WirdSettings, int, QQueryOperations> goalValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goalValue');
    });
  }

  QueryBuilder<WirdSettings, bool, QQueryOperations>
      hasConfiguredGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasConfiguredGoal');
    });
  }

  QueryBuilder<WirdSettings, DateTime?, QQueryOperations>
      khatmaStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'khatmaStartDate');
    });
  }

  QueryBuilder<WirdSettings, DateTime?, QQueryOperations>
      lastCompletionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCompletionDate');
    });
  }

  QueryBuilder<WirdSettings, int, QQueryOperations> pagesPerDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pagesPerDay');
    });
  }
}
