import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/notifications/data/models/notification_content.dart';
import 'package:sila_app/features/notifications/presentation/controllers/notification_providers.dart';

final notificationDetailProvider = FutureProvider.family<
    NotificationContent?,
    String>((ref, contentId) async {
  final repo = await ref.watch(notificationRepositoryProvider.future);
  return repo.getContentByContentId(contentId);
});
