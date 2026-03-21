import 'package:isar/isar.dart';

part 'user_gender_prefs.g.dart';

@collection
class UserGenderPrefs {
  Id id = Isar.autoIncrement;

  late bool isMale;
  late bool onboardingDone;
  late DateTime createdAt;
}
