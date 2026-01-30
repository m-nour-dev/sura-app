import 'package:sila_app/core/services/notification_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/features/prayers/domain/entities/prayer_times_entity.dart';
import 'package:sila_app/features/prayers/domain/repositories/prayer_repository.dart';

class AdhanSchedulerService {
  final NotificationService _notificationService = NotificationService();
  final PrefsService _prefsService = PrefsService();

  /// Schedule all daily prayers based on user preferences
  Future<void> scheduleAllPrayers(PrayerTimesEntity prayerTimes) async {
    print('Scheduling all prayers for ${prayerTimes.locationName}');

    // Cancel existing notifications first
    await _notificationService.cancelAllNotifications();

    // Check if Adhan is enabled globally
    final isAdhanEnabled = await _prefsService.isAdhanNotificationsEnabled();
    if (!isAdhanEnabled) {
      print('Adhan notifications are disabled');
      return;
    }

    // Get selected Adhan sound
    final adhanSound = await _prefsService.getAdhanSound();

    // Schedule each prayer if enabled
    await _scheduleIfEnabled('fajr', prayerTimes.fajr, adhanSound);
    await _scheduleIfEnabled('dhuhr', prayerTimes.dhuhr, adhanSound);
    await _scheduleIfEnabled('asr', prayerTimes.asr, adhanSound);
    await _scheduleIfEnabled('maghrib', prayerTimes.maghrib, adhanSound);
    await _scheduleIfEnabled('isha', prayerTimes.isha, adhanSound);

    // Log scheduled notifications
    final pending = await _notificationService.getPendingNotifications();
    print('Total scheduled notifications: ${pending.length}');
    for (final notification in pending) {
      print('  - ID: ${notification.id}, Title: ${notification.title}');
    }
  }

  /// Schedule notification if prayer is enabled
  Future<void> _scheduleIfEnabled(
    String prayerName,
    DateTime prayerTime,
    String soundFile,
  ) async {
    final isEnabled = await _prefsService.isAdhanEnabled(prayerName);
    
    if (isEnabled) {
      final now = DateTime.now();
      
      // Only schedule if prayer time is in the future
      if (prayerTime.isAfter(now)) {
        await _notificationService.scheduleNotification(
          id: NotificationService.getNotificationId(prayerName),
          prayerName: prayerName,
          prayerTime: prayerTime,
          soundFile: soundFile,
        );
      } else {
        print('Skipping $prayerName - time has passed');
      }
    } else {
      print('Adhan disabled for $prayerName');
    }
  }

  /// Reschedule prayers (called daily or when app restarts)
  Future<void> rescheduleDaily(PrayerRepository repository) async {
    print('Rescheduling daily prayers...');
    
    try {
      final prayerTimes = await repository.getPrayerTimes();
      await scheduleAllPrayers(prayerTimes);
      print('Daily reschedule completed successfully');
    } catch (e) {
      print('Error rescheduling prayers: $e');
    }
  }

  /// Cancel all scheduled prayers
  Future<void> cancelAllPrayers() async {
    await _notificationService.cancelAllNotifications();
    print('Cancelled all prayer notifications');
  }

  /// Cancel specific prayer notification
  Future<void> cancelPrayer(String prayerName) async {
    final id = NotificationService.getNotificationId(prayerName);
    await _notificationService.cancelNotification(id);
    print('Cancelled $prayerName notification');
  }

  /// Test Adhan sound
  Future<void> testAdhan(String soundFile) async {
    await _notificationService.playAdhan(soundFile);
  }

  /// Stop playing Adhan
  Future<void> stopAdhan() async {
    await _notificationService.stopAdhan();
  }
}
