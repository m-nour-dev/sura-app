import 'package:json_annotation/json_annotation.dart';
import 'package:sila_app/features/quran/data/models/ayah_model.dart';
import 'package:sila_app/features/quran/domain/entities/surah.dart';

part 'surah_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SurahModel extends Surah {
  final List<AyahModel>? ayahs;

  const SurahModel({
    required super.number,
    required super.nameArabic,
    required super.nameTurkish,
    required super.englishName,
    required super.numberOfAyahs,
    required super.revelationType,
    this.ayahs,
  }) : super(ayahs: ayahs);

  factory SurahModel.fromJson(Map<String, dynamic> json) =>
      _$SurahModelFromJson(json);

  Map<String, dynamic> toJson() => _$SurahModelToJson(this);
}
