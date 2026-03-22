import 'package:isar/isar.dart';

part 'reciter_settings.g.dart';

@collection
class ReciterSettings {
  Id id = Isar.autoIncrement;

  late String selectedReciterId;
  late DateTime updatedAt;
}
