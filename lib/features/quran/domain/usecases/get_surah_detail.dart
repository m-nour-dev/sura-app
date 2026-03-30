import 'package:fpdart/fpdart.dart';
import 'package:sila_app/core/error/failures.dart';
import 'package:sila_app/features/quran/domain/entities/surah.dart';
import 'package:sila_app/features/quran/domain/repositories/quran_repository.dart';

class GetSurahDetail {
  GetSurahDetail(this.repository);
  final QuranRepository repository;

  Future<Either<Failure, Surah>> call(int surahNumber) async {
    return await repository.getSurahDetail(surahNumber);
  }
}
