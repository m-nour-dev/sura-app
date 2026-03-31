// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationSettingsCollection on Isar {
  IsarCollection<NotificationSettings> get notificationSettings =>
      this.collection();
}

const NotificationSettingsSchema = CollectionSchema(
  name: r'NotificationSettings',
  id: 4766171496376314778,
  properties: {
    r'avgResponseMinutes': PropertySchema(
      id: 0,
      name: r'avgResponseMinutes',
      type: IsarType.long,
    ),
    r'consecutiveIgnored': PropertySchema(
      id: 1,
      name: r'consecutiveIgnored',
      type: IsarType.long,
    ),
    r'dismissCount': PropertySchema(
      id: 2,
      name: r'dismissCount',
      type: IsarType.long,
    ),
    r'endTimeReminderEnabled': PropertySchema(
      id: 3,
      name: r'endTimeReminderEnabled',
      type: IsarType.bool,
    ),
    r'engagementRate': PropertySchema(
      id: 4,
      name: r'engagementRate',
      type: IsarType.double,
    ),
    r'featureKey': PropertySchema(
      id: 5,
      name: r'featureKey',
      type: IsarType.string,
    ),
    r'fixedHour': PropertySchema(
      id: 6,
      name: r'fixedHour',
      type: IsarType.long,
    ),
    r'fixedMinute': PropertySchema(
      id: 7,
      name: r'fixedMinute',
      type: IsarType.long,
    ),
    r'frequency': PropertySchema(
      id: 8,
      name: r'frequency',
      type: IsarType.string,
    ),
    r'isAbandoned': PropertySchema(
      id: 9,
      name: r'isAbandoned',
      type: IsarType.bool,
    ),
    r'isEnabled': PropertySchema(
      id: 10,
      name: r'isEnabled',
      type: IsarType.bool,
    ),
    r'lastShownAt': PropertySchema(
      id: 11,
      name: r'lastShownAt',
      type: IsarType.dateTime,
    ),
    r'lastTappedAt': PropertySchema(
      id: 12,
      name: r'lastTappedAt',
      type: IsarType.dateTime,
    ),
    r'minutesAfterPrayer': PropertySchema(
      id: 13,
      name: r'minutesAfterPrayer',
      type: IsarType.long,
    ),
    r'needsReschedule': PropertySchema(
      id: 14,
      name: r'needsReschedule',
      type: IsarType.bool,
    ),
    r'prayerName': PropertySchema(
      id: 15,
      name: r'prayerName',
      type: IsarType.string,
    ),
    r'preferredTypes': PropertySchema(
      id: 16,
      name: r'preferredTypes',
      type: IsarType.stringList,
    ),
    r'shownCount': PropertySchema(
      id: 17,
      name: r'shownCount',
      type: IsarType.long,
    ),
    r'tapCount': PropertySchema(
      id: 18,
      name: r'tapCount',
      type: IsarType.long,
    ),
    r'timingType': PropertySchema(
      id: 19,
      name: r'timingType',
      type: IsarType.string,
    ),
    r'weekDays': PropertySchema(
      id: 20,
      name: r'weekDays',
      type: IsarType.longList,
    )
  },
  estimateSize: _notificationSettingsEstimateSize,
  serialize: _notificationSettingsSerialize,
  deserialize: _notificationSettingsDeserialize,
  deserializeProp: _notificationSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notificationSettingsGetId,
  getLinks: _notificationSettingsGetLinks,
  attach: _notificationSettingsAttach,
  version: '3.1.0+1',
);

int _notificationSettingsEstimateSize(
  NotificationSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.featureKey.length * 3;
  bytesCount += 3 + object.frequency.length * 3;
  bytesCount += 3 + object.prayerName.length * 3;
  bytesCount += 3 + object.preferredTypes.length * 3;
  {
    for (var i = 0; i < object.preferredTypes.length; i++) {
      final value = object.preferredTypes[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.timingType.length * 3;
  bytesCount += 3 + object.weekDays.length * 8;
  return bytesCount;
}

void _notificationSettingsSerialize(
  NotificationSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.avgResponseMinutes);
  writer.writeLong(offsets[1], object.consecutiveIgnored);
  writer.writeLong(offsets[2], object.dismissCount);
  writer.writeBool(offsets[3], object.endTimeReminderEnabled);
  writer.writeDouble(offsets[4], object.engagementRate);
  writer.writeString(offsets[5], object.featureKey);
  writer.writeLong(offsets[6], object.fixedHour);
  writer.writeLong(offsets[7], object.fixedMinute);
  writer.writeString(offsets[8], object.frequency);
  writer.writeBool(offsets[9], object.isAbandoned);
  writer.writeBool(offsets[10], object.isEnabled);
  writer.writeDateTime(offsets[11], object.lastShownAt);
  writer.writeDateTime(offsets[12], object.lastTappedAt);
  writer.writeLong(offsets[13], object.minutesAfterPrayer);
  writer.writeBool(offsets[14], object.needsReschedule);
  writer.writeString(offsets[15], object.prayerName);
  writer.writeStringList(offsets[16], object.preferredTypes);
  writer.writeLong(offsets[17], object.shownCount);
  writer.writeLong(offsets[18], object.tapCount);
  writer.writeString(offsets[19], object.timingType);
  writer.writeLongList(offsets[20], object.weekDays);
}

NotificationSettings _notificationSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationSettings();
  object.avgResponseMinutes = reader.readLong(offsets[0]);
  object.consecutiveIgnored = reader.readLong(offsets[1]);
  object.dismissCount = reader.readLong(offsets[2]);
  object.endTimeReminderEnabled = reader.readBool(offsets[3]);
  object.featureKey = reader.readString(offsets[5]);
  object.fixedHour = reader.readLong(offsets[6]);
  object.fixedMinute = reader.readLong(offsets[7]);
  object.frequency = reader.readString(offsets[8]);
  object.id = id;
  object.isEnabled = reader.readBool(offsets[10]);
  object.lastShownAt = reader.readDateTimeOrNull(offsets[11]);
  object.lastTappedAt = reader.readDateTimeOrNull(offsets[12]);
  object.minutesAfterPrayer = reader.readLong(offsets[13]);
  object.prayerName = reader.readString(offsets[15]);
  object.preferredTypes = reader.readStringList(offsets[16]) ?? [];
  object.shownCount = reader.readLong(offsets[17]);
  object.tapCount = reader.readLong(offsets[18]);
  object.timingType = reader.readString(offsets[19]);
  object.weekDays = reader.readLongList(offsets[20]) ?? [];
  return object;
}

P _notificationSettingsDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readStringList(offset) ?? []) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationSettingsGetId(NotificationSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationSettingsGetLinks(
    NotificationSettings object) {
  return [];
}

void _notificationSettingsAttach(
    IsarCollection<dynamic> col, Id id, NotificationSettings object) {
  object.id = id;
}

extension NotificationSettingsQueryWhereSort
    on QueryBuilder<NotificationSettings, NotificationSettings, QWhere> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationSettingsQueryWhere
    on QueryBuilder<NotificationSettings, NotificationSettings, QWhereClause> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
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

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterWhereClause>
      idBetween(
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

extension NotificationSettingsQueryFilter on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {
  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> avgResponseMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgResponseMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> avgResponseMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgResponseMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> avgResponseMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgResponseMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> avgResponseMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgResponseMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> consecutiveIgnoredEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'consecutiveIgnored',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> consecutiveIgnoredGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'consecutiveIgnored',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> consecutiveIgnoredLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'consecutiveIgnored',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> consecutiveIgnoredBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'consecutiveIgnored',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> dismissCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dismissCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> dismissCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dismissCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> dismissCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dismissCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> dismissCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dismissCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> endTimeReminderEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTimeReminderEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> engagementRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'engagementRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> engagementRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'engagementRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> engagementRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'engagementRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> engagementRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'engagementRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> featureKeyEqualTo(
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

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> featureKeyGreaterThan(
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

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> featureKeyLessThan(
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

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> featureKeyBetween(
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

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> featureKeyStartsWith(
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

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> featureKeyEndsWith(
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

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      featureKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'featureKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      featureKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'featureKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> featureKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'featureKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> featureKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'featureKey',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> fixedHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fixedHour',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> fixedHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fixedHour',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> fixedHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fixedHour',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> fixedHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fixedHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> fixedMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fixedMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> fixedMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fixedMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> fixedMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fixedMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> fixedMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fixedMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> frequencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> frequencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> frequencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> frequencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'frequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> frequencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> frequencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      frequencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'frequency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      frequencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'frequency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> frequencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'frequency',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> frequencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'frequency',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> isAbandonedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAbandoned',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> isEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastShownAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastShownAt',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastShownAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastShownAt',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastShownAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastShownAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastShownAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastShownAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastShownAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastShownAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastShownAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastShownAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastTappedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastTappedAt',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastTappedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastTappedAt',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastTappedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTappedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastTappedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastTappedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastTappedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastTappedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> lastTappedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastTappedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> minutesAfterPrayerEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minutesAfterPrayer',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> minutesAfterPrayerGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minutesAfterPrayer',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> minutesAfterPrayerLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minutesAfterPrayer',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> minutesAfterPrayerBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minutesAfterPrayer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> needsRescheduleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'needsReschedule',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> prayerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prayerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> prayerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prayerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> prayerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prayerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> prayerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prayerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> prayerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prayerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> prayerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prayerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      prayerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prayerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      prayerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prayerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> prayerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prayerName',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> prayerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prayerName',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preferredTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preferredTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preferredTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preferredTypes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preferredTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preferredTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      preferredTypesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preferredTypes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      preferredTypesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preferredTypes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preferredTypes',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preferredTypes',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'preferredTypes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'preferredTypes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'preferredTypes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'preferredTypes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'preferredTypes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> preferredTypesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'preferredTypes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> shownCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shownCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> shownCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shownCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> shownCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shownCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> shownCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shownCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> tapCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> tapCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> tapCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tapCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> tapCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tapCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> timingTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> timingTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> timingTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> timingTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timingType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> timingTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> timingTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      timingTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timingType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
          QAfterFilterCondition>
      timingTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timingType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> timingTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timingType',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> timingTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timingType',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weekDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekDays',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weekDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekDays',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weekDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekDays',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weekDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weekDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weekDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weekDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weekDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weekDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings,
      QAfterFilterCondition> weekDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension NotificationSettingsQueryObject on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {}

extension NotificationSettingsQueryLinks on QueryBuilder<NotificationSettings,
    NotificationSettings, QFilterCondition> {}

extension NotificationSettingsQuerySortBy
    on QueryBuilder<NotificationSettings, NotificationSettings, QSortBy> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByAvgResponseMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgResponseMinutes', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByAvgResponseMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgResponseMinutes', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByConsecutiveIgnored() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveIgnored', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByConsecutiveIgnoredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveIgnored', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByDismissCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissCount', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByDismissCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissCount', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEndTimeReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimeReminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEndTimeReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimeReminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEngagementRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engagementRate', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByEngagementRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engagementRate', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByFeatureKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureKey', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByFeatureKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureKey', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByFixedHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedHour', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByFixedHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedHour', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByFixedMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedMinute', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByFixedMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedMinute', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByIsAbandoned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbandoned', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByIsAbandonedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbandoned', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByLastShownAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShownAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByLastShownAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShownAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByLastTappedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTappedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByLastTappedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTappedAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByMinutesAfterPrayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesAfterPrayer', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByMinutesAfterPrayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesAfterPrayer', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByNeedsReschedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsReschedule', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByNeedsRescheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsReschedule', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByPrayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerName', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByPrayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerName', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByShownCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownCount', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByShownCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownCount', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByTapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapCount', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByTapCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapCount', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByTimingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timingType', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      sortByTimingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timingType', Sort.desc);
    });
  }
}

extension NotificationSettingsQuerySortThenBy
    on QueryBuilder<NotificationSettings, NotificationSettings, QSortThenBy> {
  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByAvgResponseMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgResponseMinutes', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByAvgResponseMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgResponseMinutes', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByConsecutiveIgnored() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveIgnored', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByConsecutiveIgnoredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consecutiveIgnored', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByDismissCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissCount', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByDismissCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dismissCount', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEndTimeReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimeReminderEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEndTimeReminderEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTimeReminderEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEngagementRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engagementRate', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByEngagementRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'engagementRate', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByFeatureKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureKey', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByFeatureKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'featureKey', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByFixedHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedHour', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByFixedHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedHour', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByFixedMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedMinute', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByFixedMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fixedMinute', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequency', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByIsAbandoned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbandoned', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByIsAbandonedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbandoned', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByLastShownAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShownAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByLastShownAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShownAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByLastTappedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTappedAt', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByLastTappedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTappedAt', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByMinutesAfterPrayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesAfterPrayer', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByMinutesAfterPrayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minutesAfterPrayer', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByNeedsReschedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsReschedule', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByNeedsRescheduleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsReschedule', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByPrayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerName', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByPrayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerName', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByShownCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownCount', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByShownCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownCount', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByTapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapCount', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByTapCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tapCount', Sort.desc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByTimingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timingType', Sort.asc);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QAfterSortBy>
      thenByTimingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timingType', Sort.desc);
    });
  }
}

extension NotificationSettingsQueryWhereDistinct
    on QueryBuilder<NotificationSettings, NotificationSettings, QDistinct> {
  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByAvgResponseMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgResponseMinutes');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByConsecutiveIgnored() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consecutiveIgnored');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByDismissCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dismissCount');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByEndTimeReminderEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTimeReminderEnabled');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByEngagementRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'engagementRate');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByFeatureKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'featureKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByFixedHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fixedHour');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByFixedMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fixedMinute');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByFrequency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByIsAbandoned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAbandoned');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEnabled');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByLastShownAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastShownAt');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByLastTappedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTappedAt');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByMinutesAfterPrayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minutesAfterPrayer');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByNeedsReschedule() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'needsReschedule');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByPrayerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prayerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByPreferredTypes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preferredTypes');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByShownCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shownCount');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByTapCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tapCount');
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByTimingType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timingType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationSettings, NotificationSettings, QDistinct>
      distinctByWeekDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekDays');
    });
  }
}

extension NotificationSettingsQueryProperty on QueryBuilder<
    NotificationSettings, NotificationSettings, QQueryProperty> {
  QueryBuilder<NotificationSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      avgResponseMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgResponseMinutes');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      consecutiveIgnoredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consecutiveIgnored');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      dismissCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dismissCount');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      endTimeReminderEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTimeReminderEnabled');
    });
  }

  QueryBuilder<NotificationSettings, double, QQueryOperations>
      engagementRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'engagementRate');
    });
  }

  QueryBuilder<NotificationSettings, String, QQueryOperations>
      featureKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'featureKey');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      fixedHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fixedHour');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      fixedMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fixedMinute');
    });
  }

  QueryBuilder<NotificationSettings, String, QQueryOperations>
      frequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequency');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      isAbandonedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAbandoned');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      isEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEnabled');
    });
  }

  QueryBuilder<NotificationSettings, DateTime?, QQueryOperations>
      lastShownAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastShownAt');
    });
  }

  QueryBuilder<NotificationSettings, DateTime?, QQueryOperations>
      lastTappedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTappedAt');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      minutesAfterPrayerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minutesAfterPrayer');
    });
  }

  QueryBuilder<NotificationSettings, bool, QQueryOperations>
      needsRescheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'needsReschedule');
    });
  }

  QueryBuilder<NotificationSettings, String, QQueryOperations>
      prayerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prayerName');
    });
  }

  QueryBuilder<NotificationSettings, List<String>, QQueryOperations>
      preferredTypesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preferredTypes');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations>
      shownCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shownCount');
    });
  }

  QueryBuilder<NotificationSettings, int, QQueryOperations> tapCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tapCount');
    });
  }

  QueryBuilder<NotificationSettings, String, QQueryOperations>
      timingTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timingType');
    });
  }

  QueryBuilder<NotificationSettings, List<int>, QQueryOperations>
      weekDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekDays');
    });
  }
}
