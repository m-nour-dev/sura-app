import 'dart:math';

import 'package:sila_app/features/ibadah_tracker/data/models/ibadah_content.dart';
import 'package:sila_app/features/notifications/data/models/notification_content.dart';
import 'package:sila_app/features/notifications/data/repositories/i_notification_repository.dart';

class IbadahContentSelector {
  IbadahContentSelector({required INotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository;

  final INotificationRepository _notificationRepository;
  final Random _random = Random();

  static const List<Map<String, dynamic>> _masjidIncompleteBank = [
    {
      'id': 'mi_001',
      'type': 'hadith',
      'arabic_text': 'صلاة الجماعة تفضل صلاة الفذ بسبع وعشرين درجة',
      'source': 'متفق عليه',
      'grade': 'صحيح',
    },
    {
      'id': 'mi_002',
      'type': 'hadith',
      'arabic_text': 'من سمع النداء فلم يأته فلا صلاة له إلا من عذر',
      'source': 'رواه ابن ماجه',
      'grade': 'صحيح',
    },
    {
      'id': 'mi_003',
      'type': 'hadith',
      'arabic_text': 'لقد هممت أن آمر بالصلاة فتقام ثم أخالف إلى رجال لا يشهدون الصلاة',
      'source': 'متفق عليه',
      'grade': 'صحيح',
    },
  ];

  Future<IbadahContent> getContent({
    required String ibadahKey,
    required bool? completed,
    required bool? inMasjid,
    required bool isMale,
  }) async {
    if (_isPrayer(ibadahKey) && isMale && completed == true && inMasjid == false) {
      final picked = _masjidIncompleteBank[_random.nextInt(_masjidIncompleteBank.length)];
      return IbadahContent.fromMap(picked);
    }

    if (_isPrayer(ibadahKey) && completed == false) {
      final picked = await _pickWithTag(
        category: 'salah',
        preferredTag: 'تكاسل_عن_salah',
      );
      if (picked != null) {
        return IbadahContent(
          id: picked.contentId,
          type: picked.type,
          arabicText: picked.arabicText,
          shortText: _buildShortText(picked),
          source: picked.source,
          grade: picked.grade,
          surahNumber: picked.surahNumber == 0 ? null : picked.surahNumber,
          ayahNumber: picked.ayahNumber == 0 ? null : picked.ayahNumber,
        );
      }
    }

    final mappedCategory = _mapCategory(ibadahKey);
    final bank = await _notificationRepository.getContentByCategory(mappedCategory);
    final filtered = _filter(bank, ibadahKey: ibadahKey, completed: completed);
    final picked = _pickLeastShown(filtered.isEmpty ? bank : filtered);

    if (picked != null) {
      picked
        ..shownCount = picked.shownCount + 1
        ..lastShown = DateTime.now();
      await _notificationRepository.saveContent(picked);
      return IbadahContent(
        id: picked.contentId,
        type: picked.type,
        arabicText: picked.arabicText,
        shortText: _buildShortText(picked),
        source: picked.source,
        grade: picked.grade,
        surahNumber: picked.surahNumber == 0 ? null : picked.surahNumber,
        ayahNumber: picked.ayahNumber == 0 ? null : picked.ayahNumber,
      );
    }

    return const IbadahContent(
      id: 'fallback_001',
      type: 'hikma',
      arabicText: 'اجعل لك وردا ثابتا، فالقليل الدائم أحب إلى الله من الكثير المنقطع.',
      shortText: 'اجعل لك وردا ثابتا، فالقليل الدائم أحب إلى الله من الكثير المنقطع.',
      source: 'تذكير',
      grade: 'عام',
    );
  }

  String _buildShortText(NotificationContent content) {
    final candidate = content.shortExplanation.trim();
    if (candidate.isNotEmpty) return candidate;
    final raw = content.arabicText.trim();
    if (raw.length <= 170) return raw;
    return '${raw.substring(0, 170)}...';
  }

  List<NotificationContent> _filter(
    List<NotificationContent> bank, {
    required String ibadahKey,
    required bool? completed,
  }) {
    var out = bank;

    if (ibadahKey == 'azkar_sabah') {
      out = out.where((e) => e.triggerTags.contains('أذكار_الصباح')).toList();
    } else if (ibadahKey == 'azkar_masa') {
      out = out.where((e) => e.triggerTags.contains('أذكار_المساء')).toList();
    } else if (ibadahKey == 'dhikr') {
      out = out
          .where(
            (e) =>
                e.triggerTags.contains('تذكير_عام') &&
                !e.triggerTags.contains('أذكار_الصباح') &&
                !e.triggerTags.contains('أذكار_المساء'),
          )
          .toList();
    }

    if (completed == false) {
      final trigger = _incompleteTrigger(ibadahKey);
      final byTrigger = out
          .where((e) => e.triggerTags.contains(trigger) || e.triggerTags.contains('تذكير_عام'))
          .toList();
      if (byTrigger.isNotEmpty) out = byTrigger;
    }

    return out;
  }

  NotificationContent? _pickLeastShown(List<NotificationContent> candidates) {
    if (candidates.isEmpty) return null;
    candidates.sort((a, b) => a.shownCount.compareTo(b.shownCount));
    final shortlist = candidates.take(5).toList();
    return shortlist[_random.nextInt(shortlist.length)];
  }

  Future<NotificationContent?> _pickWithTag({required String category, required String preferredTag}) async {
    final bank = await _notificationRepository.getContentByCategory(category);
    final tagged = bank.where((e) => e.triggerTags.contains(preferredTag)).toList();
    final picked = _pickLeastShown(tagged.isNotEmpty ? tagged : bank);
    if (picked != null) {
      picked
        ..shownCount = picked.shownCount + 1
        ..lastShown = DateTime.now();
      await _notificationRepository.saveContent(picked);
    }
    return picked;
  }

  String _mapCategory(String key) {
    if (_isPrayer(key)) return 'salah';
    switch (key) {
      case 'wird':
        return 'wird';
      case 'azkar_sabah':
      case 'azkar_masa':
        return 'azkar';
      case 'tasbih':
        return 'tasbih';
      case 'hifz':
      case 'tasmi':
        return 'hifz';
      case 'dhikr':
        return 'azkar';
      default:
        return 'azkar';
    }
  }

  String _incompleteTrigger(String key) {
    if (_isPrayer(key)) return 'تكاسل_عن_salah';
    switch (key) {
      case 'wird':
        return 'تكاسل_عن_wird';
      case 'azkar_sabah':
      case 'azkar_masa':
        return 'تكاسل_عن_azkar';
      case 'tasbih':
        return 'تكاسل_عن_tasbih';
      case 'hifz':
      case 'tasmi':
        return 'تكاسل_عن_hifz';
      case 'dhikr':
        return 'تكاسل_عن_azkar';
      default:
        return 'تذكير_عام';
    }
  }

  bool _isPrayer(String key) {
    return key == 'fajr' || key == 'dhuhr' || key == 'asr' || key == 'maghrib' || key == 'isha';
  }
}
