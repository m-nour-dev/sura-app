import 'dart:math';

import 'package:sura_app/features/notifications/data/models/notification_content.dart';

class ContentSelector {
  final Random _random = Random();

  List<NotificationContent> filterCandidates({
    required List<NotificationContent> bank,
    required String trigger,
    required String season,
    required List<String> preferredTypes,
  }) {
    final byType = preferredTypes.isEmpty
        ? bank
        : bank.where((item) => preferredTypes.contains(item.type)).toList();

    final byTrigger = byType.where((item) {
      return item.triggerTags.contains(trigger) ||
          item.triggerTags.contains('تذكير_عام');
    }).toList();

    final bySeason = byTrigger.where((item) {
      return item.seasonTags.contains(season) ||
          item.seasonTags.contains('عام');
    }).toList();

    if (bySeason.isNotEmpty) return bySeason;
    if (byTrigger.isNotEmpty) return byTrigger;
    if (byType.isNotEmpty) return byType;
    return bank;
  }

  NotificationContent? pickLeastShown(List<NotificationContent> candidates) {
    if (candidates.isEmpty) return null;
    candidates.sort((a, b) => a.shownCount.compareTo(b.shownCount));
    final shortlist = candidates.take(5).toList();
    return shortlist[_random.nextInt(shortlist.length)];
  }
}

