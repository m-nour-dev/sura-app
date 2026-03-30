import 'package:isar/isar.dart';

part 'hifz_user_profile.g.dart';

@collection
class HifzUserProfile {
  Id id = Isar.autoIncrement;

  late int ageGroup;
  late int dailyMinutes;
  late int goal;
  late int learningStyle;
  late bool autoAdapt;
  late DateTime createdAt;
}
