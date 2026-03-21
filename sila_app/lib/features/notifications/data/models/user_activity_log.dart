import 'package:isar/isar.dart';

part 'user_activity_log.g.dart';

@collection
class UserActivityLog {
  Id id = Isar.autoIncrement;

  late String featureKey;
  DateTime lastOpened = DateTime.now();
  DateTime lastCompleted = DateTime.now();
  int streakDays = 0;
  DateTime streakStartDate = DateTime.now();
  int totalSessions = 0;
}
