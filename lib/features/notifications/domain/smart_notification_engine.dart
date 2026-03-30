import 'package:hijri/hijri_calendar.dart';
import 'package:sila_app/features/notifications/data/models/notification_content.dart';
import 'package:sila_app/features/notifications/data/models/notification_settings.dart';
import 'package:sila_app/features/notifications/data/models/user_activity_log.dart';
import 'package:sila_app/features/notifications/data/repositories/i_notification_repository.dart';
import 'package:sila_app/features/notifications/domain/content_selector.dart';

class SmartNotificationEngine {
  SmartNotificationEngine({
    required this.repository,
    ContentSelector? selector,
  }) : selector = selector ?? ContentSelector();
  final INotificationRepository repository;
  final ContentSelector selector;

  Future<NotificationContent?> selectContent({
    required String featureKey,
    required UserActivityLog activity,
    required NotificationSettings settings,
  }) async {
    final trigger = _detectTrigger(featureKey, activity);
    final season = _detectCurrentSeason();
    final preferredTypes = settings.preferredTypes;
    final bank = await repository.getContentByCategory(featureKey);
    final candidates = selector.filterCandidates(
      bank: bank,
      trigger: trigger,
      season: season,
      preferredTypes: preferredTypes,
    );
    return selector.pickLeastShown(candidates);
  }

  String _detectTrigger(String featureKey, UserActivityLog activity) {
    final hoursSinceLastOpen =
        DateTime.now().difference(activity.lastOpened).inHours;
    final inactivityThresholds = {
      'azkar': 18,
      'wird': 26,
      'hifz': 48,
      'tasmi': 72,
      'tasbih': 20,
      'salah': 16,
    };
    final threshold = inactivityThresholds[featureKey] ?? 24;
    if (hoursSinceLastOpen > threshold) return 'تكاسل_عن_$featureKey';
    return 'تذكير_عام';
  }

  String _detectCurrentSeason() {
    final now = DateTime.now();
    if (now.weekday == DateTime.friday) return 'الجمعة';

    final hijri = HijriCalendar.fromDate(now);
    if (hijri.hMonth == 9) return 'رمضان';
    if (hijri.hMonth == 12 && hijri.hDay <= 10) return 'عشر_ذي_الحجة';
    return 'عام';
  }
}
