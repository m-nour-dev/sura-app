import 'package:isar/isar.dart';
import 'package:sila_app/features/vefa/domain/entities/vefa_person.dart';

part 'vefa_person_model.g.dart';

@collection
class VefaPersonModel {
  Id id = Isar.autoIncrement;

  late String name;

  String? relation;

  DateTime? deathDate;

  int giftCount = 0;

  // Mapper to Entity
  VefaPerson toEntity() {
    return VefaPerson(
      id: id,
      name: name,
      relation: relation,
      deathDate: deathDate,
      giftCount: giftCount,
    );
  }

  // Mapper from Entity
  static VefaPersonModel fromEntity(VefaPerson entity) {
    return VefaPersonModel()
      ..id = entity.id ?? Isar.autoIncrement
      ..name = entity.name
      ..relation = entity.relation
      ..deathDate = entity.deathDate
      ..giftCount = entity.giftCount;
  }
}
