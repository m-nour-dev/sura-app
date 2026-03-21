// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ibadah_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIbadahRecordCollection on Isar {
  IsarCollection<IbadahRecord> get ibadahRecords => this.collection();
}

const IbadahRecordSchema = CollectionSchema(
  name: r'IbadahRecord',
  id: -423423060324282746,
  properties: {
    r'asrInMasjid': PropertySchema(
      id: 0,
      name: r'asrInMasjid',
      type: IsarType.bool,
    ),
    r'asrStatus': PropertySchema(
      id: 1,
      name: r'asrStatus',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'dhuhrInMasjid': PropertySchema(
      id: 3,
      name: r'dhuhrInMasjid',
      type: IsarType.bool,
    ),
    r'dhuhrStatus': PropertySchema(
      id: 4,
      name: r'dhuhrStatus',
      type: IsarType.long,
    ),
    r'didHifz': PropertySchema(
      id: 5,
      name: r'didHifz',
      type: IsarType.bool,
    ),
    r'didTasbih': PropertySchema(
      id: 6,
      name: r'didTasbih',
      type: IsarType.bool,
    ),
    r'didTasmi': PropertySchema(
      id: 7,
      name: r'didTasmi',
      type: IsarType.bool,
    ),
    r'fajrInMasjid': PropertySchema(
      id: 8,
      name: r'fajrInMasjid',
      type: IsarType.bool,
    ),
    r'fajrStatus': PropertySchema(
      id: 9,
      name: r'fajrStatus',
      type: IsarType.long,
    ),
    r'ishaInMasjid': PropertySchema(
      id: 10,
      name: r'ishaInMasjid',
      type: IsarType.bool,
    ),
    r'ishaStatus': PropertySchema(
      id: 11,
      name: r'ishaStatus',
      type: IsarType.long,
    ),
    r'lastUpdated': PropertySchema(
      id: 12,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'maghribInMasjid': PropertySchema(
      id: 13,
      name: r'maghribInMasjid',
      type: IsarType.bool,
    ),
    r'maghribStatus': PropertySchema(
      id: 14,
      name: r'maghribStatus',
      type: IsarType.long,
    ),
    r'personalNote': PropertySchema(
      id: 15,
      name: r'personalNote',
      type: IsarType.string,
    ),
    r'readAzkarMasa': PropertySchema(
      id: 16,
      name: r'readAzkarMasa',
      type: IsarType.bool,
    ),
    r'readAzkarSabah': PropertySchema(
      id: 17,
      name: r'readAzkarSabah',
      type: IsarType.bool,
    ),
    r'readWird': PropertySchema(
      id: 18,
      name: r'readWird',
      type: IsarType.bool,
    ),
    r'rememberedAllah': PropertySchema(
      id: 19,
      name: r'rememberedAllah',
      type: IsarType.bool,
    )
  },
  estimateSize: _ibadahRecordEstimateSize,
  serialize: _ibadahRecordSerialize,
  deserialize: _ibadahRecordDeserialize,
  deserializeProp: _ibadahRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: true,
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
  getId: _ibadahRecordGetId,
  getLinks: _ibadahRecordGetLinks,
  attach: _ibadahRecordAttach,
  version: '3.1.0+1',
);

int _ibadahRecordEstimateSize(
  IbadahRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.personalNote;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _ibadahRecordSerialize(
  IbadahRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.asrInMasjid);
  writer.writeLong(offsets[1], object.asrStatus);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeBool(offsets[3], object.dhuhrInMasjid);
  writer.writeLong(offsets[4], object.dhuhrStatus);
  writer.writeBool(offsets[5], object.didHifz);
  writer.writeBool(offsets[6], object.didTasbih);
  writer.writeBool(offsets[7], object.didTasmi);
  writer.writeBool(offsets[8], object.fajrInMasjid);
  writer.writeLong(offsets[9], object.fajrStatus);
  writer.writeBool(offsets[10], object.ishaInMasjid);
  writer.writeLong(offsets[11], object.ishaStatus);
  writer.writeDateTime(offsets[12], object.lastUpdated);
  writer.writeBool(offsets[13], object.maghribInMasjid);
  writer.writeLong(offsets[14], object.maghribStatus);
  writer.writeString(offsets[15], object.personalNote);
  writer.writeBool(offsets[16], object.readAzkarMasa);
  writer.writeBool(offsets[17], object.readAzkarSabah);
  writer.writeBool(offsets[18], object.readWird);
  writer.writeBool(offsets[19], object.rememberedAllah);
}

IbadahRecord _ibadahRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IbadahRecord();
  object.asrInMasjid = reader.readBoolOrNull(offsets[0]);
  object.asrStatus = reader.readLong(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.dhuhrInMasjid = reader.readBoolOrNull(offsets[3]);
  object.dhuhrStatus = reader.readLong(offsets[4]);
  object.didHifz = reader.readBool(offsets[5]);
  object.didTasbih = reader.readBool(offsets[6]);
  object.didTasmi = reader.readBool(offsets[7]);
  object.fajrInMasjid = reader.readBoolOrNull(offsets[8]);
  object.fajrStatus = reader.readLong(offsets[9]);
  object.id = id;
  object.ishaInMasjid = reader.readBoolOrNull(offsets[10]);
  object.ishaStatus = reader.readLong(offsets[11]);
  object.lastUpdated = reader.readDateTime(offsets[12]);
  object.maghribInMasjid = reader.readBoolOrNull(offsets[13]);
  object.maghribStatus = reader.readLong(offsets[14]);
  object.personalNote = reader.readStringOrNull(offsets[15]);
  object.readAzkarMasa = reader.readBool(offsets[16]);
  object.readAzkarSabah = reader.readBool(offsets[17]);
  object.readWird = reader.readBool(offsets[18]);
  object.rememberedAllah = reader.readBool(offsets[19]);
  return object;
}

P _ibadahRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readBoolOrNull(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    case 19:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ibadahRecordGetId(IbadahRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ibadahRecordGetLinks(IbadahRecord object) {
  return [];
}

void _ibadahRecordAttach(
    IsarCollection<dynamic> col, Id id, IbadahRecord object) {
  object.id = id;
}

extension IbadahRecordByIndex on IsarCollection<IbadahRecord> {
  Future<IbadahRecord?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  IbadahRecord? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<IbadahRecord?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<IbadahRecord?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(IbadahRecord object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(IbadahRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<IbadahRecord> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<IbadahRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension IbadahRecordQueryWhereSort
    on QueryBuilder<IbadahRecord, IbadahRecord, QWhere> {
  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension IbadahRecordQueryWhere
    on QueryBuilder<IbadahRecord, IbadahRecord, QWhereClause> {
  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhereClause> dateNotEqualTo(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhereClause> dateGreaterThan(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhereClause> dateLessThan(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterWhereClause> dateBetween(
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

extension IbadahRecordQueryFilter
    on QueryBuilder<IbadahRecord, IbadahRecord, QFilterCondition> {
  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      asrInMasjidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'asrInMasjid',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      asrInMasjidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'asrInMasjid',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      asrInMasjidEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'asrInMasjid',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      asrStatusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'asrStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      asrStatusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'asrStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      asrStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'asrStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      asrStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'asrStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      dateGreaterThan(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      dhuhrInMasjidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dhuhrInMasjid',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      dhuhrInMasjidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dhuhrInMasjid',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      dhuhrInMasjidEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dhuhrInMasjid',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      dhuhrStatusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dhuhrStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      dhuhrStatusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dhuhrStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      dhuhrStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dhuhrStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      dhuhrStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dhuhrStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      didHifzEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'didHifz',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      didTasbihEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'didTasbih',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      didTasmiEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'didTasmi',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      fajrInMasjidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fajrInMasjid',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      fajrInMasjidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fajrInMasjid',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      fajrInMasjidEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fajrInMasjid',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      fajrStatusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fajrStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      fajrStatusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fajrStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      fajrStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fajrStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      fajrStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fajrStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      ishaInMasjidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ishaInMasjid',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      ishaInMasjidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ishaInMasjid',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      ishaInMasjidEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ishaInMasjid',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      ishaStatusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ishaStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      ishaStatusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ishaStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      ishaStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ishaStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      ishaStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ishaStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      maghribInMasjidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maghribInMasjid',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      maghribInMasjidIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maghribInMasjid',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      maghribInMasjidEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maghribInMasjid',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      maghribStatusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maghribStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      maghribStatusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maghribStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      maghribStatusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maghribStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      maghribStatusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maghribStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'personalNote',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'personalNote',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'personalNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'personalNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'personalNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'personalNote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'personalNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'personalNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'personalNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'personalNote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'personalNote',
        value: '',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      personalNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'personalNote',
        value: '',
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      readAzkarMasaEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readAzkarMasa',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      readAzkarSabahEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readAzkarSabah',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      readWirdEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'readWird',
        value: value,
      ));
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterFilterCondition>
      rememberedAllahEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rememberedAllah',
        value: value,
      ));
    });
  }
}

extension IbadahRecordQueryObject
    on QueryBuilder<IbadahRecord, IbadahRecord, QFilterCondition> {}

extension IbadahRecordQueryLinks
    on QueryBuilder<IbadahRecord, IbadahRecord, QFilterCondition> {}

extension IbadahRecordQuerySortBy
    on QueryBuilder<IbadahRecord, IbadahRecord, QSortBy> {
  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByAsrInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrInMasjid', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByAsrInMasjidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrInMasjid', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByAsrStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrStatus', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByAsrStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrStatus', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByDhuhrInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrInMasjid', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByDhuhrInMasjidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrInMasjid', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByDhuhrStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrStatus', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByDhuhrStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrStatus', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByDidHifz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didHifz', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByDidHifzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didHifz', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByDidTasbih() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didTasbih', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByDidTasbihDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didTasbih', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByDidTasmi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didTasmi', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByDidTasmiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didTasmi', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByFajrInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrInMasjid', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByFajrInMasjidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrInMasjid', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByFajrStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrStatus', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByFajrStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrStatus', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByIshaInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaInMasjid', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByIshaInMasjidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaInMasjid', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByIshaStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaStatus', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByIshaStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaStatus', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByMaghribInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribInMasjid', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByMaghribInMasjidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribInMasjid', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByMaghribStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribStatus', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByMaghribStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribStatus', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByPersonalNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personalNote', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByPersonalNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personalNote', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByReadAzkarMasa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAzkarMasa', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByReadAzkarMasaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAzkarMasa', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByReadAzkarSabah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAzkarSabah', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByReadAzkarSabahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAzkarSabah', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByReadWird() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readWird', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> sortByReadWirdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readWird', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByRememberedAllah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberedAllah', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      sortByRememberedAllahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberedAllah', Sort.desc);
    });
  }
}

extension IbadahRecordQuerySortThenBy
    on QueryBuilder<IbadahRecord, IbadahRecord, QSortThenBy> {
  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByAsrInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrInMasjid', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByAsrInMasjidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrInMasjid', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByAsrStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrStatus', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByAsrStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrStatus', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByDhuhrInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrInMasjid', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByDhuhrInMasjidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrInMasjid', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByDhuhrStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrStatus', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByDhuhrStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrStatus', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByDidHifz() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didHifz', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByDidHifzDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didHifz', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByDidTasbih() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didTasbih', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByDidTasbihDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didTasbih', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByDidTasmi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didTasmi', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByDidTasmiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'didTasmi', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByFajrInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrInMasjid', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByFajrInMasjidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrInMasjid', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByFajrStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrStatus', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByFajrStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrStatus', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByIshaInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaInMasjid', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByIshaInMasjidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaInMasjid', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByIshaStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaStatus', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByIshaStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaStatus', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByMaghribInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribInMasjid', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByMaghribInMasjidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribInMasjid', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByMaghribStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribStatus', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByMaghribStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribStatus', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByPersonalNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personalNote', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByPersonalNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personalNote', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByReadAzkarMasa() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAzkarMasa', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByReadAzkarMasaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAzkarMasa', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByReadAzkarSabah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAzkarSabah', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByReadAzkarSabahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readAzkarSabah', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByReadWird() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readWird', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy> thenByReadWirdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readWird', Sort.desc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByRememberedAllah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberedAllah', Sort.asc);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QAfterSortBy>
      thenByRememberedAllahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rememberedAllah', Sort.desc);
    });
  }
}

extension IbadahRecordQueryWhereDistinct
    on QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> {
  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByAsrInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'asrInMasjid');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByAsrStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'asrStatus');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct>
      distinctByDhuhrInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dhuhrInMasjid');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByDhuhrStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dhuhrStatus');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByDidHifz() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'didHifz');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByDidTasbih() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'didTasbih');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByDidTasmi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'didTasmi');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByFajrInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fajrInMasjid');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByFajrStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fajrStatus');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByIshaInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ishaInMasjid');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByIshaStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ishaStatus');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct>
      distinctByMaghribInMasjid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maghribInMasjid');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct>
      distinctByMaghribStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maghribStatus');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByPersonalNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'personalNote', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct>
      distinctByReadAzkarMasa() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readAzkarMasa');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct>
      distinctByReadAzkarSabah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readAzkarSabah');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct> distinctByReadWird() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readWird');
    });
  }

  QueryBuilder<IbadahRecord, IbadahRecord, QDistinct>
      distinctByRememberedAllah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rememberedAllah');
    });
  }
}

extension IbadahRecordQueryProperty
    on QueryBuilder<IbadahRecord, IbadahRecord, QQueryProperty> {
  QueryBuilder<IbadahRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IbadahRecord, bool?, QQueryOperations> asrInMasjidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'asrInMasjid');
    });
  }

  QueryBuilder<IbadahRecord, int, QQueryOperations> asrStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'asrStatus');
    });
  }

  QueryBuilder<IbadahRecord, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<IbadahRecord, bool?, QQueryOperations> dhuhrInMasjidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dhuhrInMasjid');
    });
  }

  QueryBuilder<IbadahRecord, int, QQueryOperations> dhuhrStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dhuhrStatus');
    });
  }

  QueryBuilder<IbadahRecord, bool, QQueryOperations> didHifzProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'didHifz');
    });
  }

  QueryBuilder<IbadahRecord, bool, QQueryOperations> didTasbihProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'didTasbih');
    });
  }

  QueryBuilder<IbadahRecord, bool, QQueryOperations> didTasmiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'didTasmi');
    });
  }

  QueryBuilder<IbadahRecord, bool?, QQueryOperations> fajrInMasjidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fajrInMasjid');
    });
  }

  QueryBuilder<IbadahRecord, int, QQueryOperations> fajrStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fajrStatus');
    });
  }

  QueryBuilder<IbadahRecord, bool?, QQueryOperations> ishaInMasjidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ishaInMasjid');
    });
  }

  QueryBuilder<IbadahRecord, int, QQueryOperations> ishaStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ishaStatus');
    });
  }

  QueryBuilder<IbadahRecord, DateTime, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<IbadahRecord, bool?, QQueryOperations>
      maghribInMasjidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maghribInMasjid');
    });
  }

  QueryBuilder<IbadahRecord, int, QQueryOperations> maghribStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maghribStatus');
    });
  }

  QueryBuilder<IbadahRecord, String?, QQueryOperations> personalNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personalNote');
    });
  }

  QueryBuilder<IbadahRecord, bool, QQueryOperations> readAzkarMasaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readAzkarMasa');
    });
  }

  QueryBuilder<IbadahRecord, bool, QQueryOperations> readAzkarSabahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readAzkarSabah');
    });
  }

  QueryBuilder<IbadahRecord, bool, QQueryOperations> readWirdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readWird');
    });
  }

  QueryBuilder<IbadahRecord, bool, QQueryOperations> rememberedAllahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rememberedAllah');
    });
  }
}
