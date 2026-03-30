// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vefa_person_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVefaPersonModelCollection on Isar {
  IsarCollection<VefaPersonModel> get vefaPersonModels => this.collection();
}

const VefaPersonModelSchema = CollectionSchema(
  name: r'VefaPersonModel',
  id: -6013139107813053430,
  properties: {
    r'deathDate': PropertySchema(
      id: 0,
      name: r'deathDate',
      type: IsarType.dateTime,
    ),
    r'giftCount': PropertySchema(
      id: 1,
      name: r'giftCount',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'relation': PropertySchema(
      id: 3,
      name: r'relation',
      type: IsarType.string,
    )
  },
  estimateSize: _vefaPersonModelEstimateSize,
  serialize: _vefaPersonModelSerialize,
  deserialize: _vefaPersonModelDeserialize,
  deserializeProp: _vefaPersonModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _vefaPersonModelGetId,
  getLinks: _vefaPersonModelGetLinks,
  attach: _vefaPersonModelAttach,
  version: '3.1.0+1',
);

int _vefaPersonModelEstimateSize(
  VefaPersonModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.relation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _vefaPersonModelSerialize(
  VefaPersonModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.deathDate);
  writer.writeLong(offsets[1], object.giftCount);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.relation);
}

VefaPersonModel _vefaPersonModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VefaPersonModel();
  object.deathDate = reader.readDateTimeOrNull(offsets[0]);
  object.giftCount = reader.readLong(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  object.relation = reader.readStringOrNull(offsets[3]);
  return object;
}

P _vefaPersonModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _vefaPersonModelGetId(VefaPersonModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _vefaPersonModelGetLinks(VefaPersonModel object) {
  return [];
}

void _vefaPersonModelAttach(
    IsarCollection<dynamic> col, Id id, VefaPersonModel object) {
  object.id = id;
}

extension VefaPersonModelQueryWhereSort
    on QueryBuilder<VefaPersonModel, VefaPersonModel, QWhere> {
  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VefaPersonModelQueryWhere
    on QueryBuilder<VefaPersonModel, VefaPersonModel, QWhereClause> {
  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterWhereClause>
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

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterWhereClause> idBetween(
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

extension VefaPersonModelQueryFilter
    on QueryBuilder<VefaPersonModel, VefaPersonModel, QFilterCondition> {
  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      deathDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deathDate',
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      deathDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deathDate',
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      deathDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deathDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      deathDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deathDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      deathDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deathDate',
        value: value,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      deathDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deathDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      giftCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'giftCount',
        value: value,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      giftCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'giftCount',
        value: value,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      giftCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'giftCount',
        value: value,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      giftCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'giftCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
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

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
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

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
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

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'relation',
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'relation',
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relation',
        value: '',
      ));
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterFilterCondition>
      relationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relation',
        value: '',
      ));
    });
  }
}

extension VefaPersonModelQueryObject
    on QueryBuilder<VefaPersonModel, VefaPersonModel, QFilterCondition> {}

extension VefaPersonModelQueryLinks
    on QueryBuilder<VefaPersonModel, VefaPersonModel, QFilterCondition> {}

extension VefaPersonModelQuerySortBy
    on QueryBuilder<VefaPersonModel, VefaPersonModel, QSortBy> {
  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      sortByDeathDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathDate', Sort.asc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      sortByDeathDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathDate', Sort.desc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      sortByGiftCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftCount', Sort.asc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      sortByGiftCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftCount', Sort.desc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      sortByRelation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relation', Sort.asc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      sortByRelationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relation', Sort.desc);
    });
  }
}

extension VefaPersonModelQuerySortThenBy
    on QueryBuilder<VefaPersonModel, VefaPersonModel, QSortThenBy> {
  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      thenByDeathDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathDate', Sort.asc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      thenByDeathDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deathDate', Sort.desc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      thenByGiftCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftCount', Sort.asc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      thenByGiftCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'giftCount', Sort.desc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      thenByRelation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relation', Sort.asc);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QAfterSortBy>
      thenByRelationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relation', Sort.desc);
    });
  }
}

extension VefaPersonModelQueryWhereDistinct
    on QueryBuilder<VefaPersonModel, VefaPersonModel, QDistinct> {
  QueryBuilder<VefaPersonModel, VefaPersonModel, QDistinct>
      distinctByDeathDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deathDate');
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QDistinct>
      distinctByGiftCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'giftCount');
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VefaPersonModel, VefaPersonModel, QDistinct> distinctByRelation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relation', caseSensitive: caseSensitive);
    });
  }
}

extension VefaPersonModelQueryProperty
    on QueryBuilder<VefaPersonModel, VefaPersonModel, QQueryProperty> {
  QueryBuilder<VefaPersonModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VefaPersonModel, DateTime?, QQueryOperations>
      deathDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deathDate');
    });
  }

  QueryBuilder<VefaPersonModel, int, QQueryOperations> giftCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'giftCount');
    });
  }

  QueryBuilder<VefaPersonModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<VefaPersonModel, String?, QQueryOperations> relationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relation');
    });
  }
}
