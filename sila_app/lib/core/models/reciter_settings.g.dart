// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reciter_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReciterSettingsCollection on Isar {
  IsarCollection<ReciterSettings> get reciterSettings => this.collection();
}

const ReciterSettingsSchema = CollectionSchema(
  name: r'ReciterSettings',
  id: 2195479533174431727,
  properties: {
    r'selectedReciterId': PropertySchema(
      id: 0,
      name: r'selectedReciterId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 1,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _reciterSettingsEstimateSize,
  serialize: _reciterSettingsSerialize,
  deserialize: _reciterSettingsDeserialize,
  deserializeProp: _reciterSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _reciterSettingsGetId,
  getLinks: _reciterSettingsGetLinks,
  attach: _reciterSettingsAttach,
  version: '3.1.0+1',
);

int _reciterSettingsEstimateSize(
  ReciterSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.selectedReciterId.length * 3;
  return bytesCount;
}

void _reciterSettingsSerialize(
  ReciterSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.selectedReciterId);
  writer.writeDateTime(offsets[1], object.updatedAt);
}

ReciterSettings _reciterSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReciterSettings();
  object.id = id;
  object.selectedReciterId = reader.readString(offsets[0]);
  object.updatedAt = reader.readDateTime(offsets[1]);
  return object;
}

P _reciterSettingsDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reciterSettingsGetId(ReciterSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reciterSettingsGetLinks(ReciterSettings object) {
  return [];
}

void _reciterSettingsAttach(
    IsarCollection<dynamic> col, Id id, ReciterSettings object) {
  object.id = id;
}

extension ReciterSettingsQueryWhereSort
    on QueryBuilder<ReciterSettings, ReciterSettings, QWhere> {
  QueryBuilder<ReciterSettings, ReciterSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReciterSettingsQueryWhere
    on QueryBuilder<ReciterSettings, ReciterSettings, QWhereClause> {
  QueryBuilder<ReciterSettings, ReciterSettings, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterWhereClause>
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

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterWhereClause> idBetween(
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

extension ReciterSettingsQueryFilter
    on QueryBuilder<ReciterSettings, ReciterSettings, QFilterCondition> {
  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
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

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
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

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
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

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      selectedReciterIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedReciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      selectedReciterIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedReciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      selectedReciterIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedReciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      selectedReciterIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedReciterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      selectedReciterIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedReciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      selectedReciterIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedReciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      selectedReciterIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedReciterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      selectedReciterIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedReciterId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      selectedReciterIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedReciterId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      selectedReciterIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedReciterId',
        value: '',
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReciterSettingsQueryObject
    on QueryBuilder<ReciterSettings, ReciterSettings, QFilterCondition> {}

extension ReciterSettingsQueryLinks
    on QueryBuilder<ReciterSettings, ReciterSettings, QFilterCondition> {}

extension ReciterSettingsQuerySortBy
    on QueryBuilder<ReciterSettings, ReciterSettings, QSortBy> {
  QueryBuilder<ReciterSettings, ReciterSettings, QAfterSortBy>
      sortBySelectedReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedReciterId', Sort.asc);
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterSortBy>
      sortBySelectedReciterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedReciterId', Sort.desc);
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ReciterSettingsQuerySortThenBy
    on QueryBuilder<ReciterSettings, ReciterSettings, QSortThenBy> {
  QueryBuilder<ReciterSettings, ReciterSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterSortBy>
      thenBySelectedReciterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedReciterId', Sort.asc);
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterSortBy>
      thenBySelectedReciterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedReciterId', Sort.desc);
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ReciterSettingsQueryWhereDistinct
    on QueryBuilder<ReciterSettings, ReciterSettings, QDistinct> {
  QueryBuilder<ReciterSettings, ReciterSettings, QDistinct>
      distinctBySelectedReciterId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedReciterId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReciterSettings, ReciterSettings, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ReciterSettingsQueryProperty
    on QueryBuilder<ReciterSettings, ReciterSettings, QQueryProperty> {
  QueryBuilder<ReciterSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReciterSettings, String, QQueryOperations>
      selectedReciterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedReciterId');
    });
  }

  QueryBuilder<ReciterSettings, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
