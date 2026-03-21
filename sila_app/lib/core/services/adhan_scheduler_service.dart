import 'dart:convert';

import 'package:sila_app/core/services/isar_service.dart';
import 'package:sila_app/core/services/notification_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/features/notifications/data/notification_ids.dart';
import 'package:sila_app/features/notifications/data/repositories/isar_notification_repository.dart';
import 'package:sila_app/features/notifications/domain/smart_notification_engine.dart';
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

    await _scheduleSmartReminders(prayerTimes);

    // Log scheduled notifications
    final pending = await _notificationService.getPendingNotifications();
    print('Total scheduled notifications: ${pending.length}');
    for (final notification in pending) {
      print('  - ID: ${notification.id}, Title: ${notification.title}');
    }
  }

  Future<void> _scheduleSmartReminders(PrayerTimesEntity prayerTimes) async {
    try {
      final isar = await IsarService().db;
      final repo = IsarNotificationRepository(isar);
      await repo.seedInitialContentIfNeeded();
      final engine = SmartNotificationEngine(repository: repo);

      final planned = <_PlannedNotification>[];

      Future<void> addFeaturePlan({
        required String featureKey,
        required int id,
        required DateTime when,
        required String defaultTitle,
        required String defaultBody,
        int priority = 1,
      }) async {
        final settings = await repo.getSettings(featureKey);
        if (!settings.isEnabled) return;
        final activity = await repo.getActivityLog(featureKey);
        final selected = await engine.selectContent(
          featureKey: featureKey,
          activity: activity,
          settings: settings,
        );

        final title = defaultTitle;
        final body = selected?.arabicText.substring(
              0,
              selected.arabicText.length > 100 ? 100 : selected.arabicText.length,
            ) ??
            defaultBody;
        final payload = selected == null
            ? featureKey
            : jsonEncode({
                'content_id': selected.contentId,
                'category': selected.category,
              });

        planned.add(
          _PlannedNotification(
            id: id,
            when: when,
            title: title,
            body: body,
            payload: payload,
            priority: priority,
          ),
        );

        if (selected != null) {
          selected.shownCount = selected.shownCount + 1;
          selected.lastShown = DateTime.now();
          await repo.saveContent(selected);
        }
      }

      await addFeaturePlan(
        featureKey: 'wird',
        id: NotificationIds.wird,
        when: prayerTimes.fajr.add(const Duration(minutes: 30)),
        defaultTitle: 'وقت وردك القرآني 📖',
        defaultBody: 'خصص دقائق لوردك اليومي.',
        priority: 3,
      );

      await addFeaturePlan(
        featureKey: 'azkar',
        id: NotificationIds.azkarSabah,
        when: prayerTimes.fajr.add(const Duration(minutes: 5)),
        defaultTitle: 'أذكار الصباح 🌅',
        defaultBody: 'ابدأ يومك بذكر الله.',
        priority: 4,
      );

      await addFeaturePlan(
        featureKey: 'azkar',
        id: NotificationIds.azkarSabahUrgent,
        when: prayerTimes.sunrise.subtract(const Duration(hours: 1)),
        defaultTitle: 'تبقى ساعة لانتهاء وقت أذكار الصباح ⏰',
        defaultBody: 'لا تفوت أجر أذكار الصباح',
        priority: 2,
      );

      await addFeaturePlan(
        featureKey: 'azkar',
        id: NotificationIds.azkarMasa,
        when: prayerTimes.asr.add(const Duration(minutes: 10)),
        defaultTitle: 'أذكار المساء 🌆',
        defaultBody: 'اختم يومك بطمأنينة الذكر.',
        priority: 4,
      );

      await addFeaturePlan(
        featureKey: 'azkar',
        id: NotificationIds.azkarMasaUrgent,
        when: prayerTimes.maghrib.subtract(const Duration(hours: 1)),
        defaultTitle: 'تبقى ساعة لانتهاء وقت أذكار المساء ⏰',
        defaultBody: 'لا تفوت أجر أذكار المساء',
        priority: 2,
      );

      await addFeaturePlan(
        featureKey: 'hifz',
        id: NotificationIds.hifz,
        when: prayerTimes.fajr.add(const Duration(minutes: 45)),
        defaultTitle: 'وقت الحفظ اليوم 📚',
        defaultBody: 'خطوة واحدة يوميا تصنع حافظا متقنا.',
        priority: 2,
      );

      await addFeaturePlan(
        featureKey: 'tasbih',
        id: NotificationIds.tasbih,
        when: prayerTimes.dhuhr.add(const Duration(minutes: 20)),
        defaultTitle: 'لحظة للذكر والتسبيح 💎',
        defaultBody: 'اجعل لسانك رطبا بذكر الله.',
        priority: 1,
      );

      planned.add(
        _PlannedNotification(
          id: NotificationIds.goldenFajr,
          when: prayerTimes.fajr.add(const Duration(minutes: 5)),
          title: 'صباح النور 🌅 — يومك مع الله',
          body: 'ورد: 2 صفحة | حفظ: 5 آيات | أذكار الصباح في انتظارك',
          payload: 'golden_fajr',
          priority: 5,
        ),
      );

      if (DateTime.now().weekday == DateTime.friday) {
        final base = DateTime.now();
        planned.add(
          _PlannedNotification(
            id: NotificationIds.fridaySpecial,
            when: DateTime(base.year, base.month, base.day, 8),
            title: 'جمعة مباركة 🌟',
            body: 'أكثر من الصلاة على النبي صلى الله عليه وسلم.',
            payload: 'friday_special',
            priority: 5,
          ),
        );
        planned.add(
          _PlannedNotification(
            id: NotificationIds.fridayKahf,
            when: prayerTimes.fajr.add(const Duration(minutes: 30)),
            title: 'تذكير سورة الكهف 📖',
            body: 'لا تنس قراءة سورة الكهف اليوم.',
            payload: 'friday_kahf',
            priority: 5,
          ),
        );
        planned.add(
          _PlannedNotification(
            id: NotificationIds.fridaySalawatA,
            when: DateTime(base.year, base.month, base.day, 10, 0),
            title: 'أكثر من الصلاة على النبي ﷺ',
            body: 'اللهم صل وسلم على نبينا محمد.',
            payload: 'friday_salawat_a',
            priority: 3,
          ),
        );
        planned.add(
          _PlannedNotification(
            id: NotificationIds.fridaySalawatB,
            when: DateTime(base.year, base.month, base.day, 12, 0),
            title: 'ذكر الجمعة المبارك',
            body: 'صل على النبي ﷺ واجعل لسانك رطبًا بالذكر.',
            payload: 'friday_salawat_b',
            priority: 3,
          ),
        );
        planned.add(
          _PlannedNotification(
            id: NotificationIds.fridayResponseHour,
            when: prayerTimes.asr.add(const Duration(minutes: 20)),
            title: 'ساعة الإجابة 🕊️',
            body: 'اغتنم هذا الوقت بالدعاء واليقين.',
            payload: 'friday_response_hour',
            priority: 4,
          ),
        );
      }

      final now = DateTime.now();
      final todayPlans = planned.where((e) => e.when.isAfter(now)).toList();
      todayPlans.sort((a, b) {
        final byPriority = b.priority.compareTo(a.priority);
        if (byPriority != 0) return byPriority;
        return a.when.compareTo(b.when);
      });

      final filtered = <_PlannedNotification>[];
      for (final plan in todayPlans) {
        if (filtered.length >= 3) break;
        if (filtered.isEmpty) {
          filtered.add(plan);
          continue;
        }
        final tooClose = filtered.any(
          (f) => plan.when.difference(f.when).inMinutes.abs() < 120,
        );
        if (!tooClose) {
          filtered.add(plan);
        }
      }

      filtered.sort((a, b) => a.when.compareTo(b.when));

      for (final item in filtered) {
        await _notificationService.cancelNotification(item.id);
        await _notificationService.scheduleOneShot(
          id: item.id,
          title: item.title,
          body: item.body,
          dateTime: item.when,
          payload: item.payload,
        );
      }
    } catch (e) {
      print('Error scheduling smart reminders: $e');
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

class _PlannedNotification {
  final int id;
  final DateTime when;
  final String title;
  final String body;
  final String payload;
  final int priority;

  _PlannedNotification({
    required this.id,
    required this.when,
    required this.title,
    required this.body,
    required this.payload,
    required this.priority,
  });
}
