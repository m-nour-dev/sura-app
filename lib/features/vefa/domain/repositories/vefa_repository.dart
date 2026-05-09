import 'package:dartz/dartz.dart';
import 'package:sura_app/core/error/failure.dart';
import 'package:sura_app/features/vefa/domain/entities/vefa_person.dart';

abstract class VefaRepository {
  Future<Either<Failure, List<VefaPerson>>> getVefaList();
  Future<Either<Failure, int>> addPerson(VefaPerson person);
  Future<Either<Failure, void>> updatePerson(VefaPerson person);
  Future<Either<Failure, void>> deletePerson(int id);
  Future<Either<Failure, void>> incrementGiftCount(int id);
}

