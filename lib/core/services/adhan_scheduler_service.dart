import 'dart:convert';

import 'package:sila_app/core/services/isar_service.dart';
import 'package:sila_app/core/services/notification_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/features/ibadah_tracker/data/repositories/isar_ibadah_repository.dart';
import 'package:sila_app/features/notifications/data/notification_ids.dart';
import 'package:sila_app/features/notifications/data/repositories/isar_notification_repository.dart';
import 'package:sila_app/features/notifications/domain/smart_notification_engine.dart';
import 'package:sila_app/features/prayers/domain/entities/prayer_times_entity.dart';
import 'package:sila_app/features/prayers/domain/repositories/prayer_repository.dart';

enum _IbadahSignalType {
  prayer,
  masjid,
  wird,
  azkarSabah,
  azkarMasa,
  hifz,
  tasbih,
  dhikr
}

class _SmartMessage {
  const _SmartMessage({required this.title, required this.body});
  final String title;
  final String body;
}

class AdhanSchedulerService {
  final NotificationService _notificationService = NotificationService();
  final PrefsService _prefsService = PrefsService();

  /// Schedule all daily prayers based on user preferences
  Future<void> scheduleAllPrayers(PrayerTimesEntity prayerTimes) async {
    print('Scheduling all prayers for ${prayerTimes.locationName}');

    // Check if Adhan is enabled globally
    final isAdhanEnabled = await _prefsService.isAdhanNotificationsEnabled();
    if (!isAdhanEnabled) {
      print('Adhan notifications are disabled');
      return;
    }

    // Get selected Adhan sound
    final adhanSound = await _prefsService.getAdhanSound();

    // PERF FIX 5: Schedule all 5 prayers in parallel instead of sequentially
    await Future.wait([
      _scheduleIfEnabled('fajr', prayerTimes.fajr, adhanSound),
      _scheduleIfEnabled('dhuhr', prayerTimes.dhuhr, adhanSound),
      _scheduleIfEnabled('asr', prayerTimes.asr, adhanSound),
      _scheduleIfEnabled('maghrib', prayerTimes.maghrib, adhanSound),
      _scheduleIfEnabled('isha', prayerTimes.isha, adhanSound),
    ]);

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
      DateTime normalizeToNext(DateTime dt) {
        final nowLocal = DateTime.now();
        if (dt.isAfter(nowLocal)) return dt;
        return dt.add(const Duration(days: 1));
      }

      final isar = await IsarService().db;
      final repo = IsarNotificationRepository(isar);
      final ibadahRepo = IsarIbadahRepository(isar);
      await repo.seedInitialContentIfNeeded();
      final engine = SmartNotificationEngine(repository: repo);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final record = await ibadahRepo.getRecord(today);

      final planned = <_PlannedNotification>[];

      // Helper to check if a feature is already completed today
      bool isCompleted(_IbadahSignalType type) {
        if (record == null) return false;
        switch (type) {
          case _IbadahSignalType.wird:
            return record.readWird;
          case _IbadahSignalType.azkarSabah:
            return record.readAzkarSabah;
          case _IbadahSignalType.azkarMasa:
            return record.readAzkarMasa;
          case _IbadahSignalType.tasbih:
            return record.didTasbih;
          case _IbadahSignalType.hifz:
            return record.didHifz || record.didTasmi;
          case _IbadahSignalType.dhikr:
            return record.rememberedAllah;
          case _IbadahSignalType.prayer:
            return record.fajrStatus != 0 &&
                record.dhuhrStatus != 0 &&
                record.asrStatus != 0 &&
                record.maghribStatus != 0 &&
                record.ishaStatus != 0;
          default:
            return false;
        }
      }

      // Helper to add a candidate for a slot
      Future<void> addCandidate({
        required String featureKey,
        required int slotId,
        required int hour,
        required int minute,
        required String defaultTitle,
        _IbadahSignalType? signalType,
      }) async {
        final settings = await repo.getSettings(featureKey);
        if (!settings.isEnabled) return;

        // 1. Frequency Check
        if (settings.frequency == 'weekly') {
          if (!settings.weekDays.contains(now.weekday)) return;
        } else if (settings.frequency == 'smart') {
          final activity = await repo.getActivityLog(featureKey);
          // engine.selectContent handles smart detection or returns null if not "needed"
          // but we also check inactivity here if needed.
        }

        // 2. Skip-if-done Check
        if (signalType != null && isCompleted(signalType)) return;

        // 3. Select Content
        final activity = await repo.getActivityLog(featureKey);
        final selected = await engine.selectContent(
          featureKey: featureKey,
          activity: activity,
          settings: settings,
        );

        if (selected == null) return;

        final when = normalizeToNext(
            DateTime(now.year, now.month, now.day, hour, minute));
        final payload = jsonEncode({
          'content_id': selected.contentId,
          'category': selected.category,
        });

        planned.add(_PlannedNotification(
          id: slotId,
          when: when,
          title: defaultTitle,
          body: selected.arabicText.length > 100
              ? '${selected.arabicText.substring(0, 97)}...'
              : selected.arabicText,
          payload: payload,
          priority: 10,
          selectedContentId: selected.contentId,
          category: selected.category,
        ));
      }

      // Slot 1: After Fajr (Azkar Sabah — between Fajr and Sunrise)
      final azkarSabahTime = prayerTimes.fajr.add(const Duration(minutes: 10));
      await addCandidate(
        featureKey: 'azkar',
        slotId: NotificationIds.dailySlot1,
        hour: azkarSabahTime.hour,
        minute: azkarSabahTime.minute,
        defaultTitle: 'أذكار الصباح 🌅',
        signalType: _IbadahSignalType.azkarSabah,
      );

      // Slot 2: 09:00 (Tasbih/Duha)
      await addCandidate(
        featureKey: 'tasbih',
        slotId: NotificationIds.dailySlot2,
        hour: 9,
        minute: 0,
        defaultTitle: 'لحظة تسبيح وذكر 💎',
        signalType: _IbadahSignalType.tasbih,
      );

      // Slot 3: 12:00 (Salah/Sunnah)
      await addCandidate(
        featureKey: 'salah',
        slotId: NotificationIds.dailySlot3,
        hour: 12,
        minute: 0,
        defaultTitle: 'صلاة الظهر والسنن 🕌',
        signalType: _IbadahSignalType.prayer,
      );

      // Slot 4: 15:00 (Wird/Quran)
      await addCandidate(
        featureKey: 'wird',
        slotId: NotificationIds.dailySlot4,
        hour: 15,
        minute: 0,
        defaultTitle: 'وردك من الكتاب 📖',
        signalType: _IbadahSignalType.wird,
      );

      // Slot 5: 17:00 (Scholars/Dhikr)
      await addCandidate(
        featureKey: 'scholars',
        slotId: NotificationIds.dailySlot5,
        hour: 17,
        minute: 0,
        defaultTitle: 'من أقوال العلماء ✨',
        signalType: _IbadahSignalType.dhikr,
      );

      // Slot 6: After Asr (Azkar Masa — between Asr and Maghrib)
      final azkarMasaTime = prayerTimes.asr.add(const Duration(minutes: 10));
      await addCandidate(
        featureKey: 'azkar',
        slotId: NotificationIds.dailySlot6,
        hour: azkarMasaTime.hour,
        minute: azkarMasaTime.minute,
        defaultTitle: 'أذكار المساء 🌆',
        signalType: _IbadahSignalType.azkarMasa,
      );

      // Sort results by time
      planned.sort((a, b) => a.when.compareTo(b.when));

      // Save to cache for Home card
      final cacheData = planned
          .map((p) => {
                'id': p.id,
                'time': p.when.toIso8601String(),
                'title': p.title,
                'body': p.body,
                'category': p.category,
                'contentId': p.selectedContentId,
              })
          .toList();
      await _prefsService.savePlannedNotifications(jsonEncode(cacheData));

      // Actually schedule
      for (final item in planned) {
        await _notificationService.cancelNotification(item.id);
        await _notificationService.scheduleOneShot(
          id: item.id,
          title: item.title,
          body: item.body,
          dateTime: item.when,
          payload: item.payload,
        );
      }

      // Add back the Daily Report as a bonus
      final reportTime =
          normalizeToNext(prayerTimes.maghrib.add(const Duration(minutes: 30)));
      await _notificationService
          .cancelNotification(NotificationIds.dailyReport);
      await _notificationService.scheduleOneShot(
        id: NotificationIds.dailyReport,
        title: 'تقريرك اليومي جاهز 📋',
        body: 'راجع يومك وخذ خطوة لغد أفضل.',
        dateTime: reportTime,
        payload: jsonEncode({'route': 'daily_report'}),
      );
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
      final nextPrayerTime = prayerTime.isAfter(now)
          ? prayerTime
          : prayerTime.add(const Duration(days: 1));

      final id = NotificationService.getNotificationId(prayerName);
      await _notificationService.cancelNotification(id);
      await _notificationService.scheduleNotification(
        id: id,
        prayerName: prayerName,
        prayerTime: nextPrayerTime,
        soundFile: soundFile,
      );
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
  _PlannedNotification({
    required this.id,
    required this.when,
    required this.title,
    required this.body,
    required this.payload,
    required this.priority,
    this.selectedContentId,
    this.category,
  });
  final int id;
  final DateTime when;
  final String title;
  final String body;
  final String? payload;
  final int priority;
  final String? selectedContentId;
  final String? category;

  _PlannedNotification copyWith({int? priority}) {
    return _PlannedNotification(
      id: id,
      when: when,
      title: title,
      body: body,
      payload: payload,
      priority: priority ?? this.priority,
      selectedContentId: selectedContentId,
      category: category,
    );
  }
}
