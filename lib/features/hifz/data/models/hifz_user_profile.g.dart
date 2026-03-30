// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hifz_user_profile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHifzUserProfileCollection on Isar {
  IsarCollection<HifzUserProfile> get hifzUserProfiles => this.collection();
}

const HifzUserProfileSchema = CollectionSchema(
  name: r'HifzUserProfile',
  id: -7280259985666773314,
  properties: {
    r'ageGroup': PropertySchema(
      id: 0,
      name: r'ageGroup',
      type: IsarType.long,
    ),
    r'autoAdapt': PropertySchema(
      id: 1,
      name: r'autoAdapt',
      type: IsarType.bool,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dailyMinutes': PropertySchema(
      id: 3,
      name: r'dailyMinutes',
      type: IsarType.long,
    ),
    r'goal': PropertySchema(
      id: 4,
      name: r'goal',
      type: IsarType.long,
    ),
    r'learningStyle': PropertySchema(
      id: 5,
      name: r'learningStyle',
      type: IsarType.long,
    )
  },
  estimateSize: _hifzUserProfileEstimateSize,
  serialize: _hifzUserProfileSerialize,
  deserialize: _hifzUserProfileDeserialize,
  deserializeProp: _hifzUserProfileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _hifzUserProfileGetId,
  getLinks: _hifzUserProfileGetLinks,
  attach: _hifzUserProfileAttach,
  version: '3.1.0+1',
);

int _hifzUserProfileEstimateSize(
  HifzUserProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _hifzUserProfileSerialize(
  HifzUserProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ageGroup);
  writer.writeBool(offsets[1], object.autoAdapt);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeLong(offsets[3], object.dailyMinutes);
  writer.writeLong(offsets[4], object.goal);
  writer.writeLong(offsets[5], object.learningStyle);
}

HifzUserProfile _hifzUserProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HifzUserProfile();
  object.ageGroup = reader.readLong(offsets[0]);
  object.autoAdapt = reader.readBool(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.dailyMinutes = reader.readLong(offsets[3]);
  object.goal = reader.readLong(offsets[4]);
  object.id = id;
  object.learningStyle = reader.readLong(offsets[5]);
  return object;
}

P _hifzUserProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hifzUserProfileGetId(HifzUserProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hifzUserProfileGetLinks(HifzUserProfile object) {
  return [];
}

void _hifzUserProfileAttach(
    IsarCollection<dynamic> col, Id id, HifzUserProfile object) {
  object.id = id;
}

extension HifzUserProfileQueryWhereSort
    on QueryBuilder<HifzUserProfile, HifzUserProfile, QWhere> {
  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HifzUserProfileQueryWhere
    on QueryBuilder<HifzUserProfile, HifzUserProfile, QWhereClause> {
  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterWhereClause>
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

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterWhereClause> idBetween(
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

extension HifzUserProfileQueryFilter
    on QueryBuilder<HifzUserProfile, HifzUserProfile, QFilterCondition> {
  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      ageGroupEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ageGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      ageGroupGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ageGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      ageGroupLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ageGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      ageGroupBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ageGroup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      autoAdaptEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoAdapt',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
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

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      dailyMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      dailyMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      dailyMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      dailyMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      goalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'goal',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      goalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'goal',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      goalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'goal',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      goalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'goal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
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

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
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

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
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

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      learningStyleEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningStyle',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      learningStyleGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'learningStyle',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      learningStyleLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'learningStyle',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterFilterCondition>
      learningStyleBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'learningStyle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HifzUserProfileQueryObject
    on QueryBuilder<HifzUserProfile, HifzUserProfile, QFilterCondition> {}

extension HifzUserProfileQueryLinks
    on QueryBuilder<HifzUserProfile, HifzUserProfile, QFilterCondition> {}

extension HifzUserProfileQuerySortBy
    on QueryBuilder<HifzUserProfile, HifzUserProfile, QSortBy> {
  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByAgeGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageGroup', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByAgeGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageGroup', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByAutoAdapt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAdapt', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByAutoAdaptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAdapt', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByDailyMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMinutes', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByDailyMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMinutes', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy> sortByGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goal', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goal', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByLearningStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningStyle', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      sortByLearningStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningStyle', Sort.desc);
    });
  }
}

extension HifzUserProfileQuerySortThenBy
    on QueryBuilder<HifzUserProfile, HifzUserProfile, QSortThenBy> {
  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByAgeGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageGroup', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByAgeGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageGroup', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByAutoAdapt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAdapt', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByAutoAdaptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoAdapt', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByDailyMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMinutes', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByDailyMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyMinutes', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy> thenByGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goal', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goal', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByLearningStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningStyle', Sort.asc);
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QAfterSortBy>
      thenByLearningStyleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningStyle', Sort.desc);
    });
  }
}

extension HifzUserProfileQueryWhereDistinct
    on QueryBuilder<HifzUserProfile, HifzUserProfile, QDistinct> {
  QueryBuilder<HifzUserProfile, HifzUserProfile, QDistinct>
      distinctByAgeGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ageGroup');
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QDistinct>
      distinctByAutoAdapt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoAdapt');
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QDistinct>
      distinctByDailyMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyMinutes');
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QDistinct> distinctByGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goal');
    });
  }

  QueryBuilder<HifzUserProfile, HifzUserProfile, QDistinct>
      distinctByLearningStyle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'learningStyle');
    });
  }
}

extension HifzUserProfileQueryProperty
    on QueryBuilder<HifzUserProfile, HifzUserProfile, QQueryProperty> {
  QueryBuilder<HifzUserProfile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HifzUserProfile, int, QQueryOperations> ageGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ageGroup');
    });
  }

  QueryBuilder<HifzUserProfile, bool, QQueryOperations> autoAdaptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoAdapt');
    });
  }

  QueryBuilder<HifzUserProfile, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<HifzUserProfile, int, QQueryOperations> dailyMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyMinutes');
    });
  }

  QueryBuilder<HifzUserProfile, int, QQueryOperations> goalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goal');
    });
  }

  QueryBuilder<HifzUserProfile, int, QQueryOperations> learningStyleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'learningStyle');
    });
  }
}
