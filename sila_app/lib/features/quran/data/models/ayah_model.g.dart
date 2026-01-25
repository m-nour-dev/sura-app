// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AyahModel _$AyahModelFromJson(Map<String, dynamic> json) => AyahModel(
      number: (json['number'] as num).toInt(),
      text: json['text'] as String,
      translation: json['translation'] as String,
      audioUrl: json['audioUrl'] as String?,
    );

Map<String, dynamic> _$AyahModelToJson(AyahModel instance) => <String, dynamic>{
      'number': instance.number,
      'text': instance.text,
      'translation': instance.translation,
      'audioUrl': instance.audioUrl,
    };
