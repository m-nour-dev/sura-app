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

  // --- New tracking fields for intelligence ---
  DateTime? lastTappedAt;        // آخر مرة فتح المستخدم الإشعار
  int tapCount = 0;              // مجموع الاستجابات
  int dismissCount = 0;          // مجموع التجاهلات  
  int consecutiveIgnored = 0;    // تجاهل متتالي → خطر
  int avgResponseMinutes = -1;   // -1 = لا بيانات بعد
  DateTime? lastShownAt;         // للتحكم في التكرار
  int shownCount = 0;            // كم مرة أُرسل إجمالاً

  // مشتق: معدل الاستجابة
  double get engagementRate {
    final total = tapCount + dismissCount;
    if (total == 0) return 0.5; // افتراضي محايد
    return tapCount / total;
  }

  // مشتق: هل المستخدم تخلى عن هذه الميزة؟
  bool get isAbandoned => consecutiveIgnored >= 7;

  // مشتق: هل يحتاج تغيير الوقت؟
  bool get needsReschedule => consecutiveIgnored >= 3;
}
