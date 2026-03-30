import 'package:sila_app/core/services/notification_service.dart';
import 'package:sila_app/features/notifications/data/repositories/i_notification_repository.dart';

class StreakTracker {

  StreakTracker({
    required this.repository,
    required this.notificationService,
  });
  final INotificationRepository repository;
  final NotificationService notificationService;

  Future<void> logActivity(String featureKey) async {
    final log = await repository.getActivityLog(featureKey);
    final now = DateTime.now();
    final lastOpenedDate = DateTime(
      log.lastOpened.year,
      log.lastOpened.month,
      log.lastOpened.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    final daysDiff = today.difference(lastOpenedDate).inDays;
    var streakAdvanced = false;

    if (daysDiff == 1) {
      log.streakDays++;
      streakAdvanced = true;
    } else if (daysDiff > 1) {
      log.streakDays = 1;
      log.streakStartDate = now;
      streakAdvanced = true;
    } else if (log.streakDays == 0) {
      log.streakDays = 1;
      log.streakStartDate = now;
      streakAdvanced = true;
    }

    log.lastOpened = now;
    log.totalSessions++;
    await repository.saveActivityLog(log);
    if (streakAdvanced) {
      await _checkStreakMilestone(featureKey, log.streakDays);
    }
  }

  Future<int> getStreak(String featureKey) async {
    final log = await repository.getActivityLog(featureKey);
    return log.streakDays;
  }

  Future<void> _checkStreakMilestone(String featureKey, int days) async {
    const milestones = [3, 7, 14, 30, 60, 100];
    if (!milestones.contains(days)) return;
    await notificationService.showInstantNotification(
      id: 110,
      title: 'ما شاء الله! ✦ $days يوم متواصل',
      body: 'لا تكسر سلسلة ${_featureName(featureKey)} — استمر!',
      payload: featureKey,
    );
  }

  String _featureName(String key) {
    switch (key) {
      case 'azkar':
        return 'الأذكار';
      case 'wird':
        return 'الورد';
      case 'hifz':
        return 'الحفظ';
      case 'tasmi':
        return 'التسميع';
      case 'tasbih':
        return 'التسبيح';
      case 'salah':
        return 'الصلاة';
      default:
        return key;
    }
  }
}
