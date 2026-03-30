import 'package:json_annotation/json_annotation.dart';
import 'package:sila_app/features/quran/domain/entities/ayah.dart';

part 'ayah_model.g.dart';

@JsonSerializable()
class AyahModel extends Ayah {
  const AyahModel({
    required super.number,
    required super.text,
    required super.translation,
    super.audioUrl,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) =>
      _$AyahModelFromJson(json);

  Map<String, dynamic> toJson() => _$AyahModelToJson(this);
}
