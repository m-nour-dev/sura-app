import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/core/services/isar_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/features/ibadah_tracker/data/repositories/isar_ibadah_repository.dart';
import 'package:sila_app/features/notifications/data/notification_ids.dart';

part 'last_notification_provider.g.dart';

class LastNotification {
  LastNotification({
    required this.id,
    required this.time,
    required this.title,
    required this.body,
    this.payload,
    this.category,
    this.contentId,
  });

  factory LastNotification.fromJson(Map<String, dynamic> json) {
    return LastNotification(
      id: json['id'],
      time: DateTime.parse(json['time']),
      title: json['title'],
      body: json['body'],
      payload: json['payload'],
      category: json['category'],
      contentId: json['contentId'],
    );
  }
  final int id;
  final DateTime time;
  final String title;
  final String body;
  final String? payload;
  final String? category;
  final String? contentId;
}

@riverpod
Future<LastNotification?> lastNotification(LastNotificationRef ref) async {
  final prefs = PrefsService();
  final jsonStr = await prefs.getPlannedNotifications();
  if (jsonStr == null) return null;

  try {
    final List<dynamic> list = jsonDecode(jsonStr);
    final now = DateTime.now();

    // Find notifications that have already passed, sorted by time descending
    var passed = list
        .map((e) => LastNotification.fromJson(e))
        .where((n) => n.time.isBefore(now) || n.time.isAtSameMomentAs(now))
        .toList()
      ..sort((a, b) => b.time.compareTo(a.time));

    final isar = await IsarService().db;
    final repo = IsarIbadahRepository(isar);
    final todayRec = await repo.getRecord(DateTime(now.year, now.month, now.day));
    
    if (todayRec != null) {
      passed = passed.where((n) {
        if (n.id == NotificationIds.dailySlot1 && todayRec.readAzkarSabah) return false; // Morning Azkar
        if (n.id == NotificationIds.dailySlot6 && todayRec.readAzkarMasa) return false;  // Evening Azkar
        if (n.id == NotificationIds.dailySlot4 && todayRec.readWird) return false;       // Wird
        if (n.id == NotificationIds.dailySlot2 && todayRec.didTasbih) return false;      // Tasbih
        // Assuming hifz/tasmi use specific IDs or categories, can be added here if needed
        return true;
      }).toList();
    }

    if (passed.isEmpty) return null;
    return passed.first;
  } catch (e) {
    print('Error parsing last notification: $e');
    return null;
  }
}
