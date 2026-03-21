// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserActivityLogCollection on Isar {
  IsarCollection<UserActivityLog> get userActivityLogs => this.collection();
}

const UserActivityLogSchema = CollectionSchema(
  name: r'UserActivityLog',
  id: 6188362777706037424,
  properties: {
    r'featureKey': PropertySchema(
      id: 0,
      name: r'featureKey',
      type: IsarType.string,
    ),
    r'lastCompleted': PropertySchema(
      id: 1,
      name: r'lastCompleted',
      type: IsarType.dateTime,
    ),
    r'lastOpened': PropertySchema(
      id: 2,
      name: r'lastOpened',
      type: IsarType.dateTime,
    ),
    r'streakDays': PropertySchema(
      id: 3,
      name: r'streakDays',
      type: IsarType.long,
    ),
    r'streakStartDate': PropertySchema(
      id: 4,
      name: r'streakStartDate',
      type: IsarType.dateTime,
    ),
    r'totalSessions': PropertySchema(
      id: 5,
      name: r'totalSessions',
      type: IsarType.long,
    )
  },
  estimateSize: _userActivityLogEstimateSize,
  serialize: _userActivityLogSerialize,
  deserialize: _userActivityLogDeserialize,
  deserializeProp: _userActivityLogDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userActivityLogGetId,
  getLinks: _userActivityLogGetLinks,
  attach: _userActivityLogAttach,
  version: '3.1.0+1',
);

int _userActivityLogEstimateSize(
  UserActivityLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.featureKey.length * 3;
  return bytesCount;
}

void _userActivityLogSerialize(
  UserActivityLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.featureKey);
  writer.writeDateTime(offsets[1], object.lastCompleted);
  writer.writeDateTime(offsets[2], object.lastOpened);
  writer.writeLong(offsets[3], object.streakDays);
  writer.writeDateTime(offsets[4], object.streakStartDate);
  writer.writeLong(offsets[5], object.totalSessions);
}

UserActivityLog _userActivityLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserActivityLog();
  object.featureKey = reader.readString(offsets[0]);
  object.id = id;
  object.lastCompleted = reader.readDateTime(offsets[1]);
  object.lastOpened = reader.readDateTime(offsets[2]);
  object.streakDays = reader.readLong(offsets[3]);
  object.streakStartDate = reader.readDateTime(offsets[4]);
  object.totalSessions = reader.readLong(offsets[5]);
  return object;
}

P _userActivityLogDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
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

Id _userActivityLogGetId(UserActivityLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userActivityLogGetLinks(UserActivityLog object) {
  return [];
}

void _userActivityLogAttach(
    IsarCollection<dynamic> col, Id id, UserActivityLog object) {
  object.id = id;
}

extension UserActivityLogQueryWhereSort
    on QueryBuilder<UserActivityLog, UserActivityLog, QWhere> {
  QueryBuilder<UserActivityLog, UserActivityLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserActivityLogQueryWhere
    on QueryBuilder<UserActivityLog, UserActivityLog, QWhereClause> {
  QueryBuilder<UserActivityLog, UserActivityLog, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterWhereClause>
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

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterWhereClause> idBetween(
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

extension UserActivityLogQueryFilter
    on QueryBuilder<UserActivityLog, UserActivityLog, QFilterCondition> {
  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      featureKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      featureKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'featureKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      featureKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'featureKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      featureKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'featureKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      featureKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'featureKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      featureKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'featureKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      featureKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'featureKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      featureKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'featureKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      featureKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      featureKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'featureKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
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

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
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

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
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

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      lastCompletedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      lastCompletedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      lastCompletedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      lastCompletedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      lastOpenedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastOpened',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      lastOpenedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastOpened',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      lastOpenedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastOpened',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      lastOpenedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastOpened',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      streakDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streakDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      streakDaysGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'streakDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      streakDaysLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'streakDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      streakDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'streakDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      streakStartDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streakStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      streakStartDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'streakStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      streakStartDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'streakStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      streakStartDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'streakStartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      totalSessionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      totalSessionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      totalSessionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterFilterCondition>
      totalSessionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalSessions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserActivityLogQueryObject
    on QueryBuilder<UserActivityLog, UserActivityLog, QFilterCondition> {}

extension UserActivityLogQueryLinks
    on QueryBuilder<UserActivityLog, UserActivityLog, QFilterCondition> {}

extension UserActivityLogQuerySortBy
    on QueryBuilder<UserActivityLog, UserActivityLog, QSortBy> {
  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByFeatureKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureKey', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByFeatureKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureKey', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByLastCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompleted', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByLastCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompleted', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByLastOpened() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpened', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByLastOpenedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpened', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByStreakDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakDays', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByStreakDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakDays', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByStreakStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakStartDate', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByStreakStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakStartDate', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      sortByTotalSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.desc);
    });
  }
}

extension UserActivityLogQuerySortThenBy
    on QueryBuilder<UserActivityLog, UserActivityLog, QSortThenBy> {
  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByFeatureKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureKey', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByFeatureKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureKey', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByLastCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompleted', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByLastCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompleted', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByLastOpened() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpened', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByLastOpenedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastOpened', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByStreakDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakDays', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByStreakDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakDays', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByStreakStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakStartDate', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByStreakStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakStartDate', Sort.desc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.asc);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QAfterSortBy>
      thenByTotalSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.desc);
    });
  }
}

extension UserActivityLogQueryWhereDistinct
    on QueryBuilder<UserActivityLog, UserActivityLog, QDistinct> {
  QueryBuilder<UserActivityLog, UserActivityLog, QDistinct>
      distinctByFeatureKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'featureKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QDistinct>
      distinctByLastCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCompleted');
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QDistinct>
      distinctByLastOpened() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastOpened');
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QDistinct>
      distinctByStreakDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streakDays');
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QDistinct>
      distinctByStreakStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streakStartDate');
    });
  }

  QueryBuilder<UserActivityLog, UserActivityLog, QDistinct>
      distinctByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSessions');
    });
  }
}

extension UserActivityLogQueryProperty
    on QueryBuilder<UserActivityLog, UserActivityLog, QQueryProperty> {
  QueryBuilder<UserActivityLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserActivityLog, String, QQueryOperations> featureKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'featureKey');
    });
  }

  QueryBuilder<UserActivityLog, DateTime, QQueryOperations>
      lastCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCompleted');
    });
  }

  QueryBuilder<UserActivityLog, DateTime, QQueryOperations>
      lastOpenedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastOpened');
    });
  }

  QueryBuilder<UserActivityLog, int, QQueryOperations> streakDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streakDays');
    });
  }

  QueryBuilder<UserActivityLog, DateTime, QQueryOperations>
      streakStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streakStartDate');
    });
  }

  QueryBuilder<UserActivityLog, int, QQueryOperations> totalSessionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSessions');
    });
  }
}
