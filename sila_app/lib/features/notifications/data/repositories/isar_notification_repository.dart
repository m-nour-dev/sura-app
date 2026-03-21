import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:sila_app/features/notifications/data/models/notification_content.dart';
import 'package:sila_app/features/notifications/data/models/notification_settings.dart';
import 'package:sila_app/features/notifications/data/models/user_activity_log.dart';
import 'package:sila_app/features/notifications/data/repositories/i_notification_repository.dart';

class IsarNotificationRepository implements INotificationRepository {
  final Isar _isar;

  IsarNotificationRepository(this._isar);

  @override
  Future<void> seedInitialContentIfNeeded() async {
    final count = await _isar.notificationContents.count();
    if (count > 0) return;

    final allBanks = <Map<String, dynamic>>[
      ...await _loadBankAsset('assets/banks/salah_bank.json'),
      ...await _loadBankAsset('assets/banks/quran_bank.json'),
      ...await _loadBankAsset('assets/banks/azkar_bank.json'),
      ...await _loadBankAsset('assets/banks/tasbih_bank.json'),
      ...await _loadBankAsset('assets/banks/hifz_bank.json'),
      ...await _loadBankAsset('assets/banks/scholars_bank.json'),
      ...await _loadBankAsset('assets/banks/seasons_bank.json'),
    ];

    final contents = allBanks.map(_mapToContent).toList();
    await _isar.writeTxn(() async {
      await _isar.notificationContents.putAll(contents);
    });
  }

  Future<List<Map<String, dynamic>>> _loadBankAsset(String path) async {
    final raw = await rootBundle.loadString(path);
    final decoded = jsonDecode(raw);
    if (decoded is! List) return <Map<String, dynamic>>[];
    return decoded
        .whereType<Map>()
        .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
  }

  NotificationContent _mapToContent(Map<String, dynamic> map) {
    final content = NotificationContent();
    content.contentId = map['id'] as String;
    content.category = (map['category'] as String?) ?? 'general';
    content.type = (map['type'] as String?) ?? 'hadith';
    content.arabicText = (map['arabic_text'] as String?) ?? '';
    content.source = (map['source'] as String?) ?? '';
    content.grade = (map['grade'] as String?) ?? '';
    content.shortExplanation = (map['short_explanation'] as String?) ?? '';
    content.triggerTags =
        ((map['trigger_tags'] as List?) ?? const []).cast<String>();
    content.seasonTags =
        ((map['season_tags'] as List?) ?? const ['عام']).cast<String>();
    content.surahNumber = (map['surah_number'] as int?) ?? 0;
    content.ayahNumber = (map['ayah_number'] as int?) ?? 0;
    content.shownCount = 0;
    content.lastShown = null;
    content.isFavorited = false;
    return content;
  }

  @override
  Future<List<NotificationContent>> getContentByCategory(
      String category) async {
    final direct = await _isar.notificationContents
        .filter()
        .categoryEqualTo(category)
        .findAll();
    if (category == 'scholars') return direct;
    final scholars = await _isar.notificationContents
        .filter()
        .categoryEqualTo('scholars')
        .findAll();
    if (scholars.isEmpty) return direct;
    return [...direct, ...scholars];
  }

  @override
  Future<NotificationContent?> getContentByContentId(String contentId) {
    return _isar.notificationContents
        .filter()
        .contentIdEqualTo(contentId)
        .findFirst();
  }

  @override
  Future<void> saveContent(NotificationContent content) async {
    await _isar.writeTxn(() async {
      await _isar.notificationContents.put(content);
    });
  }

  @override
  Future<NotificationSettings> getSettings(String featureKey) async {
    final found = await _isar.notificationSettings
        .filter()
        .featureKeyEqualTo(featureKey)
        .findFirst();
    if (found != null) return found;

    final settings = NotificationSettings()..featureKey = featureKey;
    await saveSettings(settings);
    return settings;
  }

  @override
  Future<List<NotificationSettings>> getAllSettings() {
    return _isar.notificationSettings.where().findAll();
  }

  @override
  Future<void> saveSettings(NotificationSettings settings) async {
    await _isar.writeTxn(() async {
      await _isar.notificationSettings.put(settings);
    });
  }

  @override
  Future<UserActivityLog> getActivityLog(String featureKey) async {
    final found = await _isar.userActivityLogs
        .filter()
        .featureKeyEqualTo(featureKey)
        .findFirst();
    if (found != null) return found;

    final now = DateTime.now();
    final log = UserActivityLog()
      ..featureKey = featureKey
      ..lastOpened = now
      ..lastCompleted = now
      ..streakDays = 0
      ..streakStartDate = now
      ..totalSessions = 0;
    await saveActivityLog(log);
    return log;
  }

  @override
  Future<void> saveActivityLog(UserActivityLog log) async {
    await _isar.writeTxn(() async {
      await _isar.userActivityLogs.put(log);
    });
  }
}
