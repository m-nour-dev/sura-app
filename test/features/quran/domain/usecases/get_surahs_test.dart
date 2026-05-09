import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sura_app/features/quran/domain/entities/surah.dart';
import 'package:sura_app/features/quran/domain/repositories/quran_repository.dart';
import 'package:sura_app/features/quran/domain/usecases/get_surahs.dart';

class MockQuranRepository extends Mock implements QuranRepository {}

void main() {
  late GetSurahs usecase;
  late MockQuranRepository mockQuranRepository;

  setUp(() {
    mockQuranRepository = MockQuranRepository();
    usecase = GetSurahs(mockQuranRepository);
  });

  const tSurahList = [
    Surah(
      number: 1,
      nameArabic: 'الفاتحة',
      nameTurkish: 'Fatiha',
      englishName: 'Al-Fatiha',
      numberOfAyahs: 7,
      revelationType: 'Meccan',
    )
  ];

  test(
    'should get list of surahs from the repository',
    () async {
      // arrange
      when(() => mockQuranRepository.getSurahs())
          .thenAnswer((_) async => const Right(tSurahList));
      // act
      final result = await usecase();
      // assert
      expect(result, const Right(tSurahList));
      verify(() => mockQuranRepository.getSurahs());
      verifyNoMoreInteractions(mockQuranRepository);
    },
  );
}

