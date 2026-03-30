// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_gender_prefs.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserGenderPrefsCollection on Isar {
  IsarCollection<UserGenderPrefs> get userGenderPrefs => this.collection();
}

const UserGenderPrefsSchema = CollectionSchema(
  name: r'UserGenderPrefs',
  id: 5115538336334899428,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isMale': PropertySchema(
      id: 1,
      name: r'isMale',
      type: IsarType.bool,
    ),
    r'onboardingDone': PropertySchema(
      id: 2,
      name: r'onboardingDone',
      type: IsarType.bool,
    )
  },
  estimateSize: _userGenderPrefsEstimateSize,
  serialize: _userGenderPrefsSerialize,
  deserialize: _userGenderPrefsDeserialize,
  deserializeProp: _userGenderPrefsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userGenderPrefsGetId,
  getLinks: _userGenderPrefsGetLinks,
  attach: _userGenderPrefsAttach,
  version: '3.1.0+1',
);

int _userGenderPrefsEstimateSize(
  UserGenderPrefs object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _userGenderPrefsSerialize(
  UserGenderPrefs object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeBool(offsets[1], object.isMale);
  writer.writeBool(offsets[2], object.onboardingDone);
}

UserGenderPrefs _userGenderPrefsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserGenderPrefs();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.isMale = reader.readBool(offsets[1]);
  object.onboardingDone = reader.readBool(offsets[2]);
  return object;
}

P _userGenderPrefsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userGenderPrefsGetId(UserGenderPrefs object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userGenderPrefsGetLinks(UserGenderPrefs object) {
  return [];
}

void _userGenderPrefsAttach(
    IsarCollection<dynamic> col, Id id, UserGenderPrefs object) {
  object.id = id;
}

extension UserGenderPrefsQueryWhereSort
    on QueryBuilder<UserGenderPrefs, UserGenderPrefs, QWhere> {
  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserGenderPrefsQueryWhere
    on QueryBuilder<UserGenderPrefs, UserGenderPrefs, QWhereClause> {
  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterWhereClause>
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

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterWhereClause> idBetween(
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

extension UserGenderPrefsQueryFilter
    on QueryBuilder<UserGenderPrefs, UserGenderPrefs, QFilterCondition> {
  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterFilterCondition>
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

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterFilterCondition>
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

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterFilterCondition>
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

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterFilterCondition>
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

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterFilterCondition>
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

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterFilterCondition>
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

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterFilterCondition>
      isMaleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isMale',
        value: value,
      ));
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterFilterCondition>
      onboardingDoneEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'onboardingDone',
        value: value,
      ));
    });
  }
}

extension UserGenderPrefsQueryObject
    on QueryBuilder<UserGenderPrefs, UserGenderPrefs, QFilterCondition> {}

extension UserGenderPrefsQueryLinks
    on QueryBuilder<UserGenderPrefs, UserGenderPrefs, QFilterCondition> {}

extension UserGenderPrefsQuerySortBy
    on QueryBuilder<UserGenderPrefs, UserGenderPrefs, QSortBy> {
  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy> sortByIsMale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMale', Sort.asc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy>
      sortByIsMaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMale', Sort.desc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy>
      sortByOnboardingDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingDone', Sort.asc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy>
      sortByOnboardingDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingDone', Sort.desc);
    });
  }
}

extension UserGenderPrefsQuerySortThenBy
    on QueryBuilder<UserGenderPrefs, UserGenderPrefs, QSortThenBy> {
  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy> thenByIsMale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMale', Sort.asc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy>
      thenByIsMaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isMale', Sort.desc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy>
      thenByOnboardingDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingDone', Sort.asc);
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QAfterSortBy>
      thenByOnboardingDoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingDone', Sort.desc);
    });
  }
}

extension UserGenderPrefsQueryWhereDistinct
    on QueryBuilder<UserGenderPrefs, UserGenderPrefs, QDistinct> {
  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QDistinct> distinctByIsMale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isMale');
    });
  }

  QueryBuilder<UserGenderPrefs, UserGenderPrefs, QDistinct>
      distinctByOnboardingDone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingDone');
    });
  }
}

extension UserGenderPrefsQueryProperty
    on QueryBuilder<UserGenderPrefs, UserGenderPrefs, QQueryProperty> {
  QueryBuilder<UserGenderPrefs, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserGenderPrefs, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<UserGenderPrefs, bool, QQueryOperations> isMaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isMale');
    });
  }

  QueryBuilder<UserGenderPrefs, bool, QQueryOperations>
      onboardingDoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingDone');
    });
  }
}
