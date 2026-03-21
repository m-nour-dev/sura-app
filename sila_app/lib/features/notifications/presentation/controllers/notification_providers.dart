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
  await repo.seedInitialContentIfNeeded();
  return repo;
});

final smartNotificationEngineProvider = FutureProvider<SmartNotificationEngine>((
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
