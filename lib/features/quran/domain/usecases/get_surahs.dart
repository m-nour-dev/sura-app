import 'package:fpdart/fpdart.dart';
import 'package:sura_app/core/error/failures.dart';
import 'package:sura_app/features/quran/domain/entities/surah.dart';
import 'package:sura_app/features/quran/domain/repositories/quran_repository.dart';

class GetSurahs {
  GetSurahs(this.repository);
  final QuranRepository repository;

  Future<Either<Failure, List<Surah>>> call() async {
    return await repository.getSurahs();
  }
}

