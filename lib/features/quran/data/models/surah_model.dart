import 'package:json_annotation/json_annotation.dart';
import 'package:sura_app/features/quran/data/models/ayah_model.dart';
import 'package:sura_app/features/quran/domain/entities/surah.dart';

part 'surah_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SurahModel extends Surah {
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
  @override
  final List<AyahModel>? ayahs;

  Map<String, dynamic> toJson() => _$SurahModelToJson(this);
}

