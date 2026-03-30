import 'package:fpdart/fpdart.dart';
import 'package:sila_app/core/error/failures.dart';
import 'package:sila_app/features/quran/domain/entities/surah.dart';

abstract class QuranRepository {
  Future<Either<Failure, List<Surah>>> getSurahs();
  Future<Either<Failure, Surah>> getSurahDetail(int number);
}
