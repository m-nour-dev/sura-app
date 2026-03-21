import 'package:isar/isar.dart';

part 'notification_settings.g.dart';

@collection
class NotificationSettings {
  Id id = Isar.autoIncrement;

  late String featureKey;
  bool isEnabled = true;

  String timingType = 'fixed';
  int fixedHour = 7;
  int fixedMinute = 0;
  String prayerName = 'fajr';
  int minutesAfterPrayer = 0;

  String frequency = 'daily';
  List<int> weekDays = <int>[];

  List<String> preferredTypes = <String>['hadith', 'ayah', 'dhikr', 'hikma'];

  bool endTimeReminderEnabled = false;
}
