import 'package:fpdart/fpdart.dart';
import 'package:sila_app/core/error/exceptions.dart';
import 'package:sila_app/core/error/failures.dart';
import 'package:sila_app/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:sila_app/features/quran/domain/entities/surah.dart';
import 'package:sila_app/features/quran/domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {

  QuranRepositoryImpl({required this.localDataSource});
  final QuranLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<Surah>>> getSurahs() async {
    try {
      final surahs = await localDataSource.getSurahs();
      return Right(surahs);
    } on Failure catch (e) {
      return Left(e);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Surah>> getSurahDetail(int number) async {
    try {
      final surah = await localDataSource.getSurahDetail(number);
      return Right(surah);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
