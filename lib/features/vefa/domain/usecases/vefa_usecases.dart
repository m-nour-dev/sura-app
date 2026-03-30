import 'package:dartz/dartz.dart';
import 'package:sila_app/core/error/failure.dart';
import 'package:sila_app/features/vefa/domain/entities/vefa_person.dart';
import 'package:sila_app/features/vefa/domain/repositories/vefa_repository.dart';

class GetVefaListUseCase {
  GetVefaListUseCase(this.repository);
  final VefaRepository repository;

  Future<Either<Failure, List<VefaPerson>>> call() {
    return repository.getVefaList();
  }
}

class AddVefaPersonUseCase {
  AddVefaPersonUseCase(this.repository);
  final VefaRepository repository;

  Future<Either<Failure, int>> call(VefaPerson person) {
    return repository.addPerson(person);
  }
}

class DeleteVefaPersonUseCase {
  DeleteVefaPersonUseCase(this.repository);
  final VefaRepository repository;

  Future<Either<Failure, void>> call(int id) {
    return repository.deletePerson(id);
  }
}

class GiftThawabUseCase {
  GiftThawabUseCase(this.repository);
  final VefaRepository repository;

  Future<Either<Failure, void>> call(int id) {
    return repository.incrementGiftCount(id);
  }
}
