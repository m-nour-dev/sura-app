// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurahModel _$SurahModelFromJson(Map<String, dynamic> json) => SurahModel(
      number: (json['number'] as num).toInt(),
      nameArabic: json['nameArabic'] as String,
      nameTurkish: json['nameTurkish'] as String,
      englishName: json['englishName'] as String,
      numberOfAyahs: (json['numberOfAyahs'] as num).toInt(),
      revelationType: json['revelationType'] as String,
      ayahs: (json['ayahs'] as List<dynamic>?)
          ?.map((e) => AyahModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SurahModelToJson(SurahModel instance) =>
    <String, dynamic>{
      'number': instance.number,
      'nameArabic': instance.nameArabic,
      'nameTurkish': instance.nameTurkish,
      'englishName': instance.englishName,
      'numberOfAyahs': instance.numberOfAyahs,
      'revelationType': instance.revelationType,
      'ayahs': instance.ayahs?.map((e) => e.toJson()).toList(),
    };
