import 'package:dartz/dartz.dart';
import 'package:sura_app/core/error/failure.dart';
import 'package:sura_app/features/vefa/data/datasources/vefa_local_data_source.dart';
import 'package:sura_app/features/vefa/data/models/vefa_person_model.dart';
import 'package:sura_app/features/vefa/domain/entities/vefa_person.dart';
import 'package:sura_app/features/vefa/domain/repositories/vefa_repository.dart';

class VefaRepositoryImpl implements VefaRepository {
  VefaRepositoryImpl(this.localDataSource);
  final VefaLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<VefaPerson>>> getVefaList() async {
    try {
      final models = await localDataSource.getVefaList();
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, int>> addPerson(VefaPerson person) async {
    try {
      final model = VefaPersonModel.fromEntity(person);
      final id = await localDataSource.addPerson(model);
      return Right(id);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePerson(int id) async {
    try {
      await localDataSource.deletePerson(id);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updatePerson(VefaPerson person) async {
    try {
      final model = VefaPersonModel.fromEntity(person);
      await localDataSource.updatePerson(model);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> incrementGiftCount(int id) async {
    try {
      await localDataSource.incrementGiftCount(id);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}

