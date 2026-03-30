// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hifz_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHifzSettingsCollection on Isar {
  IsarCollection<HifzSettings> get hifzSettings => this.collection();
}

const HifzSettingsSchema = CollectionSchema(
  name: r'HifzSettings',
  id: 4892524597130124933,
  properties: {
    r'attemptsBeforeHint': PropertySchema(
      id: 0,
      name: r'attemptsBeforeHint',
      type: IsarType.long,
    ),
    r'ayahsPerSession': PropertySchema(
      id: 1,
      name: r'ayahsPerSession',
      type: IsarType.long,
    ),
    r'beginnerMode': PropertySchema(
      id: 2,
      name: r'beginnerMode',
      type: IsarType.bool,
    ),
    r'hideVisibleDiacritics': PropertySchema(
      id: 3,
      name: r'hideVisibleDiacritics',
      type: IsarType.bool,
    ),
    r'hintDelaySeconds': PropertySchema(
      id: 4,
      name: r'hintDelaySeconds',
      type: IsarType.long,
    ),
    r'listenRepeats': PropertySchema(
      id: 5,
      name: r'listenRepeats',
      type: IsarType.long,
    ),
    r'nightMode': PropertySchema(
      id: 6,
      name: r'nightMode',
      type: IsarType.bool,
    ),
    r'playCorrectOnError': PropertySchema(
      id: 7,
      name: r'playCorrectOnError',
      type: IsarType.bool,
    ),
    r'smartStrictness': PropertySchema(
      id: 8,
      name: r'smartStrictness',
      type: IsarType.bool,
    ),
    r'verificationModeIndex': PropertySchema(
      id: 9,
      name: r'verificationModeIndex',
      type: IsarType.long,
    )
  },
  estimateSize: _hifzSettingsEstimateSize,
  serialize: _hifzSettingsSerialize,
  deserialize: _hifzSettingsDeserialize,
  deserializeProp: _hifzSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _hifzSettingsGetId,
  getLinks: _hifzSettingsGetLinks,
  attach: _hifzSettingsAttach,
  version: '3.1.0+1',
);

int _hifzSettingsEstimateSize(
  HifzSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _hifzSettingsSerialize(
  HifzSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attemptsBeforeHint);
  writer.writeLong(offsets[1], object.ayahsPerSession);
  writer.writeBool(offsets[2], object.beginnerMode);
  writer.writeBool(offsets[3], object.hideVisibleDiacritics);
  writer.writeLong(offsets[4], object.hintDelaySeconds);
  writer.writeLong(offsets[5], object.listenRepeats);
  writer.writeBool(offsets[6], object.nightMode);
  writer.writeBool(offsets[7], object.playCorrectOnError);
  writer.writeBool(offsets[8], object.smartStrictness);
  writer.writeLong(offsets[9], object.verificationModeIndex);
}

HifzSettings _hifzSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HifzSettings();
  object.attemptsBeforeHint = reader.readLong(offsets[0]);
  object.ayahsPerSession = reader.readLong(offsets[1]);
  object.beginnerMode = reader.readBool(offsets[2]);
  object.hideVisibleDiacritics = reader.readBool(offsets[3]);
  object.hintDelaySeconds = reader.readLong(offsets[4]);
  object.id = id;
  object.listenRepeats = reader.readLong(offsets[5]);
  object.nightMode = reader.readBool(offsets[6]);
  object.playCorrectOnError = reader.readBool(offsets[7]);
  object.smartStrictness = reader.readBool(offsets[8]);
  object.verificationModeIndex = reader.readLong(offsets[9]);
  return object;
}

P _hifzSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hifzSettingsGetId(HifzSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hifzSettingsGetLinks(HifzSettings object) {
  return [];
}

void _hifzSettingsAttach(
    IsarCollection<dynamic> col, Id id, HifzSettings object) {
  object.id = id;
}

extension HifzSettingsQueryWhereSort
    on QueryBuilder<HifzSettings, HifzSettings, QWhere> {
  QueryBuilder<HifzSettings, HifzSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HifzSettingsQueryWhere
    on QueryBuilder<HifzSettings, HifzSettings, QWhereClause> {
  QueryBuilder<HifzSettings, HifzSettings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<HifzSettings, HifzSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterWhereClause> idBetween(
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

extension HifzSettingsQueryFilter
    on QueryBuilder<HifzSettings, HifzSettings, QFilterCondition> {
  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      attemptsBeforeHintEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attemptsBeforeHint',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      attemptsBeforeHintGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attemptsBeforeHint',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      attemptsBeforeHintLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attemptsBeforeHint',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      attemptsBeforeHintBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attemptsBeforeHint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      ayahsPerSessionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahsPerSession',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      ayahsPerSessionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ayahsPerSession',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      ayahsPerSessionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ayahsPerSession',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      ayahsPerSessionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ayahsPerSession',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      beginnerModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'beginnerMode',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      hideVisibleDiacriticsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hideVisibleDiacritics',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      hintDelaySecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hintDelaySeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      hintDelaySecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hintDelaySeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      hintDelaySecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hintDelaySeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      hintDelaySecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hintDelaySeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      listenRepeatsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'listenRepeats',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      listenRepeatsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'listenRepeats',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      listenRepeatsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'listenRepeats',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      listenRepeatsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'listenRepeats',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      nightModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nightMode',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      playCorrectOnErrorEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playCorrectOnError',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      smartStrictnessEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'smartStrictness',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      verificationModeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verificationModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      verificationModeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verificationModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      verificationModeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verificationModeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterFilterCondition>
      verificationModeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verificationModeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HifzSettingsQueryObject
    on QueryBuilder<HifzSettings, HifzSettings, QFilterCondition> {}

extension HifzSettingsQueryLinks
    on QueryBuilder<HifzSettings, HifzSettings, QFilterCondition> {}

extension HifzSettingsQuerySortBy
    on QueryBuilder<HifzSettings, HifzSettings, QSortBy> {
  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByAttemptsBeforeHint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptsBeforeHint', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByAttemptsBeforeHintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptsBeforeHint', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByAyahsPerSession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahsPerSession', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByAyahsPerSessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahsPerSession', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy> sortByBeginnerMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerMode', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByBeginnerModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerMode', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByHideVisibleDiacritics() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideVisibleDiacritics', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByHideVisibleDiacriticsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideVisibleDiacritics', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByHintDelaySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hintDelaySeconds', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByHintDelaySecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hintDelaySeconds', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy> sortByListenRepeats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenRepeats', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByListenRepeatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenRepeats', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy> sortByNightMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightMode', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy> sortByNightModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightMode', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByPlayCorrectOnError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCorrectOnError', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByPlayCorrectOnErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCorrectOnError', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortBySmartStrictness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartStrictness', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortBySmartStrictnessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartStrictness', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByVerificationModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verificationModeIndex', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      sortByVerificationModeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verificationModeIndex', Sort.desc);
    });
  }
}

extension HifzSettingsQuerySortThenBy
    on QueryBuilder<HifzSettings, HifzSettings, QSortThenBy> {
  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByAttemptsBeforeHint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptsBeforeHint', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByAttemptsBeforeHintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptsBeforeHint', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByAyahsPerSession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahsPerSession', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByAyahsPerSessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahsPerSession', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy> thenByBeginnerMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerMode', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByBeginnerModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'beginnerMode', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByHideVisibleDiacritics() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideVisibleDiacritics', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByHideVisibleDiacriticsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hideVisibleDiacritics', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByHintDelaySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hintDelaySeconds', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByHintDelaySecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hintDelaySeconds', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy> thenByListenRepeats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenRepeats', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByListenRepeatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'listenRepeats', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy> thenByNightMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightMode', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy> thenByNightModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightMode', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByPlayCorrectOnError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCorrectOnError', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByPlayCorrectOnErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playCorrectOnError', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenBySmartStrictness() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartStrictness', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenBySmartStrictnessDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartStrictness', Sort.desc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByVerificationModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verificationModeIndex', Sort.asc);
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QAfterSortBy>
      thenByVerificationModeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verificationModeIndex', Sort.desc);
    });
  }
}

extension HifzSettingsQueryWhereDistinct
    on QueryBuilder<HifzSettings, HifzSettings, QDistinct> {
  QueryBuilder<HifzSettings, HifzSettings, QDistinct>
      distinctByAttemptsBeforeHint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attemptsBeforeHint');
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QDistinct>
      distinctByAyahsPerSession() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayahsPerSession');
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QDistinct> distinctByBeginnerMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'beginnerMode');
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QDistinct>
      distinctByHideVisibleDiacritics() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hideVisibleDiacritics');
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QDistinct>
      distinctByHintDelaySeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hintDelaySeconds');
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QDistinct>
      distinctByListenRepeats() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'listenRepeats');
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QDistinct> distinctByNightMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nightMode');
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QDistinct>
      distinctByPlayCorrectOnError() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playCorrectOnError');
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QDistinct>
      distinctBySmartStrictness() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'smartStrictness');
    });
  }

  QueryBuilder<HifzSettings, HifzSettings, QDistinct>
      distinctByVerificationModeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verificationModeIndex');
    });
  }
}

extension HifzSettingsQueryProperty
    on QueryBuilder<HifzSettings, HifzSettings, QQueryProperty> {
  QueryBuilder<HifzSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HifzSettings, int, QQueryOperations>
      attemptsBeforeHintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attemptsBeforeHint');
    });
  }

  QueryBuilder<HifzSettings, int, QQueryOperations> ayahsPerSessionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayahsPerSession');
    });
  }

  QueryBuilder<HifzSettings, bool, QQueryOperations> beginnerModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'beginnerMode');
    });
  }

  QueryBuilder<HifzSettings, bool, QQueryOperations>
      hideVisibleDiacriticsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hideVisibleDiacritics');
    });
  }

  QueryBuilder<HifzSettings, int, QQueryOperations> hintDelaySecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hintDelaySeconds');
    });
  }

  QueryBuilder<HifzSettings, int, QQueryOperations> listenRepeatsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'listenRepeats');
    });
  }

  QueryBuilder<HifzSettings, bool, QQueryOperations> nightModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nightMode');
    });
  }

  QueryBuilder<HifzSettings, bool, QQueryOperations>
      playCorrectOnErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playCorrectOnError');
    });
  }

  QueryBuilder<HifzSettings, bool, QQueryOperations> smartStrictnessProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'smartStrictness');
    });
  }

  QueryBuilder<HifzSettings, int, QQueryOperations>
      verificationModeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verificationModeIndex');
    });
  }
}
