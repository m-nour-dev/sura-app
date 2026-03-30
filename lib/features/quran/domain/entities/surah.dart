import 'package:equatable/equatable.dart';
import 'package:sila_app/features/quran/domain/entities/ayah.dart';

class Surah extends Equatable { // Nullable, loaded only when reading

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameTurkish,
    required this.englishName,
    required this.numberOfAyahs,
    required this.revelationType,
    this.ayahs,
  });
  final int number;
  final String nameArabic;
  final String nameTurkish; // For localized UI
  final String englishName; // Fallback/System
  final int numberOfAyahs;
  final String revelationType; // Meccan or Medinan
  final List<Ayah>? ayahs;

  @override
  List<Object?> get props => [
        number,
        nameArabic,
        nameTurkish,
        englishName,
        numberOfAyahs,
        revelationType,
        ayahs,
      ];
}
