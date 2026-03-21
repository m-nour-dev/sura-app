// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_content.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationContentCollection on Isar {
  IsarCollection<NotificationContent> get notificationContents =>
      this.collection();
}

const NotificationContentSchema = CollectionSchema(
  name: r'NotificationContent',
  id: -8683313133503290466,
  properties: {
    r'arabicText': PropertySchema(
      id: 0,
      name: r'arabicText',
      type: IsarType.string,
    ),
    r'ayahNumber': PropertySchema(
      id: 1,
      name: r'ayahNumber',
      type: IsarType.long,
    ),
    r'category': PropertySchema(
      id: 2,
      name: r'category',
      type: IsarType.string,
    ),
    r'contentId': PropertySchema(
      id: 3,
      name: r'contentId',
      type: IsarType.string,
    ),
    r'grade': PropertySchema(
      id: 4,
      name: r'grade',
      type: IsarType.string,
    ),
    r'isFavorited': PropertySchema(
      id: 5,
      name: r'isFavorited',
      type: IsarType.bool,
    ),
    r'lastShown': PropertySchema(
      id: 6,
      name: r'lastShown',
      type: IsarType.dateTime,
    ),
    r'seasonTags': PropertySchema(
      id: 7,
      name: r'seasonTags',
      type: IsarType.stringList,
    ),
    r'shortExplanation': PropertySchema(
      id: 8,
      name: r'shortExplanation',
      type: IsarType.string,
    ),
    r'shownCount': PropertySchema(
      id: 9,
      name: r'shownCount',
      type: IsarType.long,
    ),
    r'source': PropertySchema(
      id: 10,
      name: r'source',
      type: IsarType.string,
    ),
    r'surahNumber': PropertySchema(
      id: 11,
      name: r'surahNumber',
      type: IsarType.long,
    ),
    r'triggerTags': PropertySchema(
      id: 12,
      name: r'triggerTags',
      type: IsarType.stringList,
    ),
    r'type': PropertySchema(
      id: 13,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _notificationContentEstimateSize,
  serialize: _notificationContentSerialize,
  deserialize: _notificationContentDeserialize,
  deserializeProp: _notificationContentDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notificationContentGetId,
  getLinks: _notificationContentGetLinks,
  attach: _notificationContentAttach,
  version: '3.1.0+1',
);

int _notificationContentEstimateSize(
  NotificationContent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.arabicText.length * 3;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.contentId.length * 3;
  bytesCount += 3 + object.grade.length * 3;
  bytesCount += 3 + object.seasonTags.length * 3;
  {
    for (var i = 0; i < object.seasonTags.length; i++) {
      final value = object.seasonTags[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.shortExplanation.length * 3;
  bytesCount += 3 + object.source.length * 3;
  bytesCount += 3 + object.triggerTags.length * 3;
  {
    for (var i = 0; i < object.triggerTags.length; i++) {
      final value = object.triggerTags[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _notificationContentSerialize(
  NotificationContent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.arabicText);
  writer.writeLong(offsets[1], object.ayahNumber);
  writer.writeString(offsets[2], object.category);
  writer.writeString(offsets[3], object.contentId);
  writer.writeString(offsets[4], object.grade);
  writer.writeBool(offsets[5], object.isFavorited);
  writer.writeDateTime(offsets[6], object.lastShown);
  writer.writeStringList(offsets[7], object.seasonTags);
  writer.writeString(offsets[8], object.shortExplanation);
  writer.writeLong(offsets[9], object.shownCount);
  writer.writeString(offsets[10], object.source);
  writer.writeLong(offsets[11], object.surahNumber);
  writer.writeStringList(offsets[12], object.triggerTags);
  writer.writeString(offsets[13], object.type);
}

NotificationContent _notificationContentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationContent();
  object.arabicText = reader.readString(offsets[0]);
  object.ayahNumber = reader.readLong(offsets[1]);
  object.category = reader.readString(offsets[2]);
  object.contentId = reader.readString(offsets[3]);
  object.grade = reader.readString(offsets[4]);
  object.id = id;
  object.isFavorited = reader.readBool(offsets[5]);
  object.lastShown = reader.readDateTimeOrNull(offsets[6]);
  object.seasonTags = reader.readStringList(offsets[7]) ?? [];
  object.shortExplanation = reader.readString(offsets[8]);
  object.shownCount = reader.readLong(offsets[9]);
  object.source = reader.readString(offsets[10]);
  object.surahNumber = reader.readLong(offsets[11]);
  object.triggerTags = reader.readStringList(offsets[12]) ?? [];
  object.type = reader.readString(offsets[13]);
  return object;
}

P _notificationContentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readStringList(offset) ?? []) as P;
    case 13:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationContentGetId(NotificationContent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationContentGetLinks(
    NotificationContent object) {
  return [];
}

void _notificationContentAttach(
    IsarCollection<dynamic> col, Id id, NotificationContent object) {
  object.id = id;
}

extension NotificationContentQueryWhereSort
    on QueryBuilder<NotificationContent, NotificationContent, QWhere> {
  QueryBuilder<NotificationContent, NotificationContent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationContentQueryWhere
    on QueryBuilder<NotificationContent, NotificationContent, QWhereClause> {
  QueryBuilder<NotificationContent, NotificationContent, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterWhereClause>
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

  QueryBuilder<NotificationContent, NotificationContent, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterWhereClause>
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

extension NotificationContentQueryFilter on QueryBuilder<NotificationContent,
    NotificationContent, QFilterCondition> {
  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      arabicTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      arabicTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      arabicTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      arabicTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'arabicText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      arabicTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      arabicTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      arabicTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'arabicText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      arabicTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'arabicText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      arabicTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arabicText',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      arabicTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'arabicText',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      ayahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      ayahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      ayahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ayahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      ayahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ayahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      contentIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      contentIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      contentIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      contentIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contentId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      contentIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      contentIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      contentIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contentId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      contentIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contentId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      contentIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contentId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      contentIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contentId',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      gradeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      gradeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      gradeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      gradeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      gradeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      gradeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      gradeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      gradeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'grade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      gradeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grade',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      gradeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'grade',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
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

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
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

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
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

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      isFavoritedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorited',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      lastShownIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastShown',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      lastShownIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastShown',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      lastShownEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastShown',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      lastShownGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastShown',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      lastShownLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastShown',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      lastShownBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastShown',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seasonTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seasonTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seasonTags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'seasonTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'seasonTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'seasonTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'seasonTags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seasonTags',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'seasonTags',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonTags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonTags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonTags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonTags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonTags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      seasonTagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'seasonTags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shortExplanationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortExplanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shortExplanationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'shortExplanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shortExplanationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'shortExplanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shortExplanationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shortExplanation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shortExplanationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'shortExplanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shortExplanationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'shortExplanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shortExplanationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'shortExplanation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shortExplanationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'shortExplanation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shortExplanationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shortExplanation',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shortExplanationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shortExplanation',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shownCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'shownCount',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shownCountGreaterThan(
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

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shownCountLessThan(
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

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      shownCountBetween(
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

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      surahNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      surahNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      surahNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surahNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      surahNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surahNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerTags',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'triggerTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'triggerTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'triggerTags',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'triggerTags',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerTags',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'triggerTags',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggerTags',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggerTags',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggerTags',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggerTags',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggerTags',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      triggerTagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'triggerTags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension NotificationContentQueryObject on QueryBuilder<NotificationContent,
    NotificationContent, QFilterCondition> {}

extension NotificationContentQueryLinks on QueryBuilder<NotificationContent,
    NotificationContent, QFilterCondition> {}

extension NotificationContentQuerySortBy
    on QueryBuilder<NotificationContent, NotificationContent, QSortBy> {
  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByArabicText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arabicText', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByArabicTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arabicText', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByContentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByIsFavorited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorited', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByIsFavoritedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorited', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByLastShown() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShown', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByLastShownDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShown', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByShortExplanation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortExplanation', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByShortExplanationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortExplanation', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByShownCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownCount', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByShownCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownCount', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension NotificationContentQuerySortThenBy
    on QueryBuilder<NotificationContent, NotificationContent, QSortThenBy> {
  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByArabicText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arabicText', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByArabicTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arabicText', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByAyahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ayahNumber', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByContentId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByContentIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contentId', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByIsFavorited() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorited', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByIsFavoritedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorited', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByLastShown() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShown', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByLastShownDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastShown', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByShortExplanation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortExplanation', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByShortExplanationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shortExplanation', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByShownCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownCount', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByShownCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shownCount', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenBySurahNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surahNumber', Sort.desc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension NotificationContentQueryWhereDistinct
    on QueryBuilder<NotificationContent, NotificationContent, QDistinct> {
  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByArabicText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arabicText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByAyahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ayahNumber');
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByContentId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contentId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByGrade({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grade', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByIsFavorited() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorited');
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByLastShown() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastShown');
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctBySeasonTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seasonTags');
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByShortExplanation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shortExplanation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByShownCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shownCount');
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctBySource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctBySurahNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surahNumber');
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByTriggerTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerTags');
    });
  }

  QueryBuilder<NotificationContent, NotificationContent, QDistinct>
      distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension NotificationContentQueryProperty
    on QueryBuilder<NotificationContent, NotificationContent, QQueryProperty> {
  QueryBuilder<NotificationContent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationContent, String, QQueryOperations>
      arabicTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arabicText');
    });
  }

  QueryBuilder<NotificationContent, int, QQueryOperations>
      ayahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ayahNumber');
    });
  }

  QueryBuilder<NotificationContent, String, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<NotificationContent, String, QQueryOperations>
      contentIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contentId');
    });
  }

  QueryBuilder<NotificationContent, String, QQueryOperations> gradeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grade');
    });
  }

  QueryBuilder<NotificationContent, bool, QQueryOperations>
      isFavoritedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorited');
    });
  }

  QueryBuilder<NotificationContent, DateTime?, QQueryOperations>
      lastShownProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastShown');
    });
  }

  QueryBuilder<NotificationContent, List<String>, QQueryOperations>
      seasonTagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seasonTags');
    });
  }

  QueryBuilder<NotificationContent, String, QQueryOperations>
      shortExplanationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shortExplanation');
    });
  }

  QueryBuilder<NotificationContent, int, QQueryOperations>
      shownCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shownCount');
    });
  }

  QueryBuilder<NotificationContent, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<NotificationContent, int, QQueryOperations>
      surahNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surahNumber');
    });
  }

  QueryBuilder<NotificationContent, List<String>, QQueryOperations>
      triggerTagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerTags');
    });
  }

  QueryBuilder<NotificationContent, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
