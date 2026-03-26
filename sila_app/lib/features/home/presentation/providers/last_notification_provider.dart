import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/core/services/prefs_service.dart';

part 'last_notification_provider.g.dart';

class LastNotification {

  LastNotification({
    required this.id,
    required this.time,
    required this.title,
    required this.body,
    this.category,
    this.contentId,
  });

  factory LastNotification.fromJson(Map<String, dynamic> json) {
    return LastNotification(
      id: json['id'],
      time: DateTime.parse(json['time']),
      title: json['title'],
      body: json['body'],
      category: json['category'],
      contentId: json['contentId'],
    );
  }
  final int id;
  final DateTime time;
  final String title;
  final String body;
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
    final passed = list
        .map((e) => LastNotification.fromJson(e))
        .where((n) => n.time.isBefore(now) || n.time.isAtSameMomentAs(now))
        .toList()
      ..sort((a, b) => b.time.compareTo(a.time));

    if (passed.isEmpty) return null;
    return passed.first;
  } catch (e) {
    print('Error parsing last notification: $e');
    return null;
  }
}
