// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hifz_verse_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHifzVerseRecordCollection on Isar {
  IsarCollection<HifzVerseRecord> get hifzVerseRecords => this.collection();
}

const HifzVerseRecordSchema = CollectionSchema(
  name: r'HifzVerseRecord',
  id: -2825327461297993072,
  properties: {
    r'correctSessions': PropertySchema(
      id: 0,
      name: r'correctSessions',
      type: IsarType.long,
    ),
    r'easinessFactor': PropertySchema(
      id: 1,
      name: r'easinessFactor',
      type: IsarType.double,
    ),
    r'intervalDays': PropertySchema(
      id: 2,
      name: r'intervalDays',
      type: IsarType.long,
    ),
    r'lastMethodUsed': PropertySchema(
      id: 3,
      name: r'lastMethodUsed',
      type: IsarType.string,
    ),
    r'lastReviewDate': PropertySchema(
      id: 4,
      name: r'lastReviewDate',
      type: IsarType.dateTime,
    ),
    r'nextReviewDate': PropertySchema(
      id: 5,
      name: r'nextReviewDate',
      type: IsarType.dateTime,
    ),
    r'surahIndex': PropertySchema(
      id: 6,
      name: r'surahIndex',
      type: IsarType.long,
    ),
    r'totalSessions': PropertySchema(
      id: 7,
      name: r'totalSessions',
      type: IsarType.long,
    ),
    r'verseNumber': PropertySchema(
      id: 8,
      name: r'verseNumber',
      type: IsarType.long,
    )
  },
  estimateSize: _hifzVerseRecordEstimateSize,
  serialize: _hifzVerseRecordSerialize,
  deserialize: _hifzVerseRecordDeserialize,
  deserializeProp: _hifzVerseRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _hifzVerseRecordGetId,
  getLinks: _hifzVerseRecordGetLinks,
  attach: _hifzVerseRecordAttach,
  version: '3.1.0+1',
);

int _hifzVerseRecordEstimateSize(
  HifzVerseRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.lastMethodUsed.length * 3;
  return bytesCount;
}

void _hifzVerseRecordSerialize(
  HifzVerseRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.correctSessions);
  writer.writeDouble(offsets[1], object.easinessFactor);
  writer.writeLong(offsets[2], object.intervalDays);
  writer.writeString(offsets[3], object.lastMethodUsed);
  writer.writeDateTime(offsets[4], object.lastReviewDate);
  writer.writeDateTime(offsets[5], object.nextReviewDate);
  writer.writeLong(offsets[6], object.surahIndex);
  writer.writeLong(offsets[7], object.totalSessions);
  writer.writeLong(offsets[8], object.verseNumber);
}

HifzVerseRecord _hifzVerseRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HifzVerseRecord();
  object.correctSessions = reader.readLong(offsets[0]);
  object.easinessFactor = reader.readDouble(offsets[1]);
  object.id = id;
  object.intervalDays = reader.readLong(offsets[2]);
  object.lastMethodUsed = reader.readString(offsets[3]);
  object.lastReviewDate = reader.readDateTime(offsets[4]);
  object.nextReviewDate = reader.readDateTime(offsets[5]);
  object.surahIndex = reader.readLong(offsets[6]);
  object.totalSessions = reader.readLong(offsets[7]);
  object.verseNumber = reader.readLong(offsets[8]);
  return object;
}

P _hifzVerseRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hifzVerseRecordGetId(HifzVerseRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hifzVerseRecordGetLinks(HifzVerseRecord object) {
  return [];
}

void _hifzVerseRecordAttach(
    IsarCollection<dynamic> col, Id id, HifzVerseRecord object) {
  object.id = id;
}

extension HifzVerseRecordQueryWhereSort
    on QueryBuilder<HifzVerseRecord, HifzVerseRecord, QWhere> {
  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HifzVerseRecordQueryWhere
    on QueryBuilder<HifzVerseRecord, HifzVerseRecord, QWhereClause> {
  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterWhereClause>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterWhereClause> idBetween(
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

extension HifzVerseRecordQueryFilter
    on QueryBuilder<HifzVerseRecord, HifzVerseRecord, QFilterCondition> {
  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      correctSessionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'correctSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      correctSessionsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'correctSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      correctSessionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'correctSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      correctSessionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'correctSessions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      easinessFactorEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'easinessFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      easinessFactorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'easinessFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      easinessFactorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'easinessFactor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      easinessFactorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'easinessFactor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      intervalDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      intervalDaysGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      intervalDaysLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      intervalDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastMethodUsedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMethodUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastMethodUsedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMethodUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastMethodUsedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMethodUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastMethodUsedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMethodUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastMethodUsedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastMethodUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastMethodUsedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastMethodUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastMethodUsedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastMethodUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastMethodUsedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastMethodUsed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastMethodUsedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMethodUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastMethodUsedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastMethodUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastReviewDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastReviewDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastReviewDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      lastReviewDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReviewDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      nextReviewDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextReviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      nextReviewDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextReviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      nextReviewDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextReviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      nextReviewDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextReviewDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      surahIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      totalSessionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalSessions',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
      verseNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterFilterCondition>
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

extension HifzVerseRecordQueryObject
    on QueryBuilder<HifzVerseRecord, HifzVerseRecord, QFilterCondition> {}

extension HifzVerseRecordQueryLinks
    on QueryBuilder<HifzVerseRecord, HifzVerseRecord, QFilterCondition> {}

extension HifzVerseRecordQuerySortBy
    on QueryBuilder<HifzVerseRecord, HifzVerseRecord, QSortBy> {
  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByCorrectSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctSessions', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByCorrectSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctSessions', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByEasinessFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easinessFactor', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByEasinessFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easinessFactor', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByLastMethodUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMethodUsed', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByLastMethodUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMethodUsed', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByLastReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReviewDate', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByLastReviewDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReviewDate', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByNextReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewDate', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByNextReviewDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewDate', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortBySurahIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByTotalSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      sortByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }
}

extension HifzVerseRecordQuerySortThenBy
    on QueryBuilder<HifzVerseRecord, HifzVerseRecord, QSortThenBy> {
  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByCorrectSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctSessions', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByCorrectSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctSessions', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByEasinessFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easinessFactor', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByEasinessFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easinessFactor', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByLastMethodUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMethodUsed', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByLastMethodUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMethodUsed', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByLastReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReviewDate', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByLastReviewDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReviewDate', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByNextReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewDate', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByNextReviewDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewDate', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenBySurahIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahIndex', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByTotalSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalSessions', Sort.desc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.asc);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QAfterSortBy>
      thenByVerseNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseNumber', Sort.desc);
    });
  }
}

extension HifzVerseRecordQueryWhereDistinct
    on QueryBuilder<HifzVerseRecord, HifzVerseRecord, QDistinct> {
  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QDistinct>
      distinctByCorrectSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correctSessions');
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QDistinct>
      distinctByEasinessFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'easinessFactor');
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QDistinct>
      distinctByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalDays');
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QDistinct>
      distinctByLastMethodUsed({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMethodUsed',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QDistinct>
      distinctByLastReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReviewDate');
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QDistinct>
      distinctByNextReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextReviewDate');
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QDistinct>
      distinctBySurahIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahIndex');
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QDistinct>
      distinctByTotalSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalSessions');
    });
  }

  QueryBuilder<HifzVerseRecord, HifzVerseRecord, QDistinct>
      distinctByVerseNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseNumber');
    });
  }
}

extension HifzVerseRecordQueryProperty
    on QueryBuilder<HifzVerseRecord, HifzVerseRecord, QQueryProperty> {
  QueryBuilder<HifzVerseRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HifzVerseRecord, int, QQueryOperations>
      correctSessionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correctSessions');
    });
  }

  QueryBuilder<HifzVerseRecord, double, QQueryOperations>
      easinessFactorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'easinessFactor');
    });
  }

  QueryBuilder<HifzVerseRecord, int, QQueryOperations> intervalDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalDays');
    });
  }

  QueryBuilder<HifzVerseRecord, String, QQueryOperations>
      lastMethodUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMethodUsed');
    });
  }

  QueryBuilder<HifzVerseRecord, DateTime, QQueryOperations>
      lastReviewDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReviewDate');
    });
  }

  QueryBuilder<HifzVerseRecord, DateTime, QQueryOperations>
      nextReviewDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextReviewDate');
    });
  }

  QueryBuilder<HifzVerseRecord, int, QQueryOperations> surahIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahIndex');
    });
  }

  QueryBuilder<HifzVerseRecord, int, QQueryOperations> totalSessionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalSessions');
    });
  }

  QueryBuilder<HifzVerseRecord, int, QQueryOperations> verseNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseNumber');
    });
  }
}
