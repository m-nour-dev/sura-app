import 'package:fpdart/fpdart.dart';
import 'package:sila_app/core/error/failures.dart';
import 'package:sila_app/features/quran/domain/entities/surah.dart';
import 'package:sila_app/features/quran/domain/repositories/quran_repository.dart';

class GetSurahs {
  final QuranRepository repository;

  GetSurahs(this.repository);

  Future<Either<Failure, List<Surah>>> call() async {
    return await repository.getSurahs();
  }
}
