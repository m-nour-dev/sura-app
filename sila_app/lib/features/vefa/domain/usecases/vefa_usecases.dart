import 'package:dartz/dartz.dart';
import 'package:sila_app/core/error/failure.dart';
import 'package:sila_app/features/vefa/domain/entities/vefa_person.dart';
import 'package:sila_app/features/vefa/domain/repositories/vefa_repository.dart';

class GetVefaListUseCase {
  final VefaRepository repository;

  GetVefaListUseCase(this.repository);

  Future<Either<Failure, List<VefaPerson>>> call() {
    return repository.getVefaList();
  }
}

class AddVefaPersonUseCase {
  final VefaRepository repository;

  AddVefaPersonUseCase(this.repository);

  Future<Either<Failure, int>> call(VefaPerson person) {
    return repository.addPerson(person);
  }
}

class DeleteVefaPersonUseCase {
   final VefaRepository repository;

  DeleteVefaPersonUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deletePerson(id);
  }
}

class GiftThawabUseCase {
  final VefaRepository repository;

  GiftThawabUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.incrementGiftCount(id);
  }
}
