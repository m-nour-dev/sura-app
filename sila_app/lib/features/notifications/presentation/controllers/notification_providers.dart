import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/core/services/notification_service.dart';
import 'package:sila_app/features/notifications/data/repositories/i_notification_repository.dart';
import 'package:sila_app/features/notifications/data/repositories/isar_notification_repository.dart';
import 'package:sila_app/features/notifications/domain/smart_notification_engine.dart';
import 'package:sila_app/features/notifications/domain/streak_tracker.dart';
import 'package:sila_app/features/vefa/presentation/riverpod/vefa_providers.dart';

final notificationRepositoryProvider = FutureProvider<INotificationRepository>((
  ref,
) async {
  final isar = await ref.watch(isarInstanceProvider.future);
  final repo = IsarNotificationRepository(isar);
  try {
    await repo.seedInitialContentIfNeeded();
  } catch (e) {
    debugPrint('Notification seed failed, continue without seed: $e');
  }
  return repo;
});

final smartNotificationEngineProvider =
    FutureProvider<SmartNotificationEngine>((
  ref,
) async {
  final repo = await ref.watch(notificationRepositoryProvider.future);
  return SmartNotificationEngine(repository: repo);
});

final streakTrackerProvider = FutureProvider<StreakTracker>((ref) async {
  final repo = await ref.watch(notificationRepositoryProvider.future);
  return StreakTracker(
    repository: repo,
    notificationService: NotificationService(),
  );
});

final featureStreakProvider =
    FutureProvider.family<int, String>((ref, featureKey) async {
  final repo = await ref.watch(notificationRepositoryProvider.future);
  return (await repo.getActivityLog(featureKey)).streakDays;
});

final streakSummaryProvider = FutureProvider<Map<String, int>>((ref) async {
  final repo = await ref.watch(notificationRepositoryProvider.future);
  const keys = ['azkar', 'wird', 'hifz', 'tasmi', 'tasbih'];
  final map = <String, int>{};
  for (final key in keys) {
    map[key] = (await repo.getActivityLog(key)).streakDays;
  }
  return map;
});
