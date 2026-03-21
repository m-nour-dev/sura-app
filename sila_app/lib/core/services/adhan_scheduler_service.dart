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

enum _IbadahSignalType { prayer, masjid, wird, azkarSabah, azkarMasa, hifz, tasbih, dhikr }

class _SmartMessage {
  final String title;
  final String body;

  const _SmartMessage({required this.title, required this.body});
}

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

      final planned = <_PlannedNotification>[];

      Future<int> scoreSignal(_IbadahSignalType type) async {
        final today = DateTime.now();
        final day = DateTime(today.year, today.month, today.day);
        final record = await ibadahRepo.getRecord(day);
        final gender = await ibadahRepo.getGenderPrefs();
        final isMale = gender?.isMale == true;

        if (record == null) return 0;

        switch (type) {
          case _IbadahSignalType.prayer:
            final prayers = [
              record.fajrStatus,
              record.dhuhrStatus,
              record.asrStatus,
              record.maghribStatus,
              record.ishaStatus,
            ];
            return prayers.where((s) => s == 0).length;
          case _IbadahSignalType.masjid:
            if (!isMale) return 0;
            final prayed = [
              record.fajrStatus,
              record.dhuhrStatus,
              record.asrStatus,
              record.maghribStatus,
              record.ishaStatus,
            ];
            final masjid = [
              record.fajrInMasjid,
              record.dhuhrInMasjid,
              record.asrInMasjid,
              record.maghribInMasjid,
              record.ishaInMasjid,
            ];
            var missed = 0;
            for (var i = 0; i < 5; i++) {
              if ((prayed[i] == 1 || prayed[i] == 2) && masjid[i] == false) missed++;
            }
            return missed;
          case _IbadahSignalType.wird:
            return record.readWird ? 0 : 1;
          case _IbadahSignalType.azkarSabah:
            return record.readAzkarSabah ? 0 : 1;
          case _IbadahSignalType.azkarMasa:
            return record.readAzkarMasa ? 0 : 1;
          case _IbadahSignalType.hifz:
            return (record.didHifz || record.didTasmi) ? 0 : 1;
          case _IbadahSignalType.tasbih:
            return record.didTasbih ? 0 : 1;
          case _IbadahSignalType.dhikr:
            return record.rememberedAllah ? 0 : 1;
        }
      }

      Future<String?> signalPayload(_IbadahSignalType type) async {
        final s = await scoreSignal(type);
        if (s <= 0) return null;
        return jsonEncode({'route': 'ibadah_signal', 'signal': type.name, 'score': s});
      }

      _SmartMessage pickSignalMessage(_IbadahSignalType type, int score) {
        final daySeed = DateTime.now().difference(DateTime(2024, 1, 1)).inDays;
        final bucket = score >= 3 ? 'high' : (score == 2 ? 'mid' : 'low');
        final banks = <String, List<_SmartMessage>>{
          'prayer_low': const [
            _SmartMessage(title: 'لا تؤخر الصلاة 🤍', body: 'صلاة واحدة في وقتها تعيد ترتيب يومك كله.'),
            _SmartMessage(title: 'موعدك مع السكينة 🕊️', body: 'أدِّ الصلاة في وقتها لتطمئن الروح.'),
            _SmartMessage(title: 'خطوة يسيرة عظيمة', body: 'قم للصلاة الآن، فالبركة تبدأ من هنا.'),
            _SmartMessage(title: 'باب الفرج قريب', body: 'أقم صلاتك، واطلب من الله العون والثبات.'),
            _SmartMessage(title: 'تكبيرة واحدة تكفي', body: 'ابدأ الآن بتكبيرة صادقة ولا تؤجل.'),
            _SmartMessage(title: 'الصلاة أولا 🌿', body: 'قدّم الصلاة، وما بعدها يهون بإذن الله.'),
            _SmartMessage(title: 'نداء الرحمة', body: 'إذا سمعت النداء فلبِّه بقلب حاضر.'),
            _SmartMessage(title: 'اليوم أجمل بالصلاة', body: 'صلاتك في وقتها نورٌ ليومك.'),
            _SmartMessage(title: 'لا تجعلها تفوتك', body: 'حافظ على وقت الصلاة لتبقى قريبًا من الله.'),
            _SmartMessage(title: 'قربك في سجودك', body: 'السجود يخفف الهم ويقوّي القلب.'),
          ],
          'prayer_mid': const [
            _SmartMessage(title: 'تبقّى عليك صلاة أو صلاتان', body: 'ألحق ما بقي من يومك بالصلاة في وقتها.'),
            _SmartMessage(title: 'اجمع قلبك على الصلاة', body: 'ما فات يُدرك إذا صدقت النية الآن.'),
            _SmartMessage(title: 'لا تؤخر أكثر', body: 'المبادرة بالصلاة تحفظ يومك من التشتت.'),
            _SmartMessage(title: 'عودة قوية اليوم', body: 'ابدأ بالصلاة التالية فورًا، واثبت حتى آخر اليوم.'),
            _SmartMessage(title: 'قم وتوكل', body: 'أدِّ الصلاة الآن، والله يعينك على الباقي.'),
            _SmartMessage(title: 'جدد عهدك مع الصلاة', body: 'صلاتك معيار ثباتك، فلا تتنازل عنها.'),
            _SmartMessage(title: 'اقطع التأجيل', body: 'كلما بادرت للصلاة زادت طمأنينتك.'),
            _SmartMessage(title: 'صحح المسار الآن', body: 'لا تنتظر وقتًا أفضل، هذا أفضل وقت.'),
            _SmartMessage(title: 'خطوتان وتعود', body: 'وضوء وصلاة، ويهدأ قلبك بإذن الله.'),
            _SmartMessage(title: 'اليوم ما زال فيه خير', body: 'أكمل يومك بالصلاة تنل الأجر والسكينة.'),
          ],
          'prayer_high': const [
            _SmartMessage(title: 'لا تترك الصلاة', body: 'اليوم يحتاج منك وقفة صادقة مع صلاتك.'),
            _SmartMessage(title: 'الصلاة نجاة', body: 'ابدأ الآن ولا تستسلم للتأجيل.'),
            _SmartMessage(title: 'ارجع الآن إلى الله', body: 'أول طريق الرجوع: الصلاة في وقتها.'),
            _SmartMessage(title: 'هذا أهم تنبيه اليوم', body: 'صلاتك أولويتك الأولى، فلا تضيعها.'),
            _SmartMessage(title: 'تدارك ما فاتك', body: 'ابدأ بالصلاة التالية واجعلها بداية ثبات.'),
            _SmartMessage(title: 'ثبّت يومك بالصلاة', body: 'لا يوجد نجاح بلا صلاة محفوظة.'),
            _SmartMessage(title: 'الأمان في الصلاة', body: 'إذا اضطرب يومك فالملجأ الصلاة.'),
            _SmartMessage(title: 'استعن بالله الآن', body: 'قم للصلاة واطلب منه الثبات.'),
            _SmartMessage(title: 'نداء مهم', body: 'لا تجعل الصلوات تمر دون حضور وعزم.'),
            _SmartMessage(title: 'ابدأ من هذه اللحظة', body: 'الرجوع الحقيقي يبدأ بصلاة صادقة.'),
          ],
          'masjid_low': const [
            _SmartMessage(title: 'خطوات للمسجد 🕌', body: 'صلاة الجماعة تزيد الأجر وتحيي القلب.'),
            _SmartMessage(title: 'لا تفوّت الجماعة', body: 'المسجد بركة يومية لا تعوض.'),
            _SmartMessage(title: 'اجعلها جماعة', body: 'باقي اليوم فرصة لصلاةٍ في المسجد.'),
            _SmartMessage(title: 'الأجر أكبر في الجماعة', body: 'جرّب اليوم أن تكون صلاتك القادمة في المسجد.'),
            _SmartMessage(title: 'موعدك مع الجماعة', body: 'المسجد ينتظرك وأجرك مضاعف.'),
          ],
          'masjid_mid': const [
            _SmartMessage(title: 'زد نصيب المسجد اليوم', body: 'صلاتان في المسجد تُحدث فرقًا كبيرًا.'),
            _SmartMessage(title: 'لا تكتفِ بالبيت', body: 'في الجماعة فضل عظيم وبركة أوضح.'),
            _SmartMessage(title: 'ألحق ما بقي', body: 'ما زال يمكن تعويض صلوات الجماعة اليوم.'),
            _SmartMessage(title: 'اجعل العشاء جماعة', body: 'اختم يومك بصلاة في المسجد.'),
            _SmartMessage(title: 'تذكير بالمسجد', body: 'الطريق إلى المسجد يرفع الدرجات.'),
          ],
          'masjid_high': const [
            _SmartMessage(title: 'الجماعة أولى اليوم', body: 'اليوم يحتاج منك حضورًا أقوى للمسجد.'),
            _SmartMessage(title: 'لا تؤجل الجماعة', body: 'اعقد نية ثابتة أن تكون الصلاة القادمة في المسجد.'),
            _SmartMessage(title: 'أعد التوازن', body: 'كثرة الصلاة في البيت تُفوّت فضلا عظيما.'),
            _SmartMessage(title: 'المسجد أولويتك الآن', body: 'ابدأ من الصلاة القادمة واجعلها جماعة.'),
            _SmartMessage(title: 'فرصة كبيرة لا تضيع', body: 'الجماعة رفعة في الدرجات وغفران للخطايا.'),
          ],
          'wird_low': const [
            _SmartMessage(title: 'وردك ينتظرك 📖', body: 'صفحات قليلة اليوم تصنع ثباتًا كبيرًا.'),
            _SmartMessage(title: 'افتح المصحف الآن', body: 'دقائق مع القرآن تكفي لطمأنينة قلبك.'),
            _SmartMessage(title: 'لا تنهِ اليوم بلا ورد', body: 'اجعل لك نصيبًا من كتاب الله.'),
            _SmartMessage(title: 'ورد يسير دائم', body: 'القليل الدائم أحب إلى الله.'),
            _SmartMessage(title: 'نصيحة اليوم', body: 'ابدأ بآية، وسيعينك الله على المزيد.'),
          ],
          'wird_mid': const [
            _SmartMessage(title: 'الورد اليوم مهم', body: 'إذا تأخر وردك فابدأ الآن ولا تؤجل.'),
            _SmartMessage(title: 'القرآن شفاء', body: 'خمس دقائق تلاوة تغير صفاء يومك.'),
            _SmartMessage(title: 'ألحق وردك', body: 'ما زال في اليوم وقت لورد مبارك.'),
            _SmartMessage(title: 'اجعلها عادة ثابتة', body: 'الورد المنتظم يصنع قلبًا حيًا.'),
            _SmartMessage(title: 'البركة في المداومة', body: 'ورد اليوم لا يترك.'),
          ],
          'wird_high': const [
            _SmartMessage(title: 'لا تترك القرآن اليوم', body: 'ابدأ فورًا ولو بقدر يسير.'),
            _SmartMessage(title: 'هذا أهم تذكير لك', body: 'القرآن روح يومك فلا تهجره.'),
            _SmartMessage(title: 'ارجع للمصحف الآن', body: 'صفحة واحدة الآن خير من تأجيل طويل.'),
            _SmartMessage(title: 'أنقذ يومك بالورد', body: 'ورد اليوم باب ثبات وطمأنينة.'),
            _SmartMessage(title: 'استدرك قبل نهاية اليوم', body: 'افتح القرآن الآن وابدأ.'),
          ],
          'azkarSabah_low': const [
            _SmartMessage(title: 'أذكار الصباح 🌅', body: 'ابدأ صباحك بذكر الله لتحفظ يومك.'),
            _SmartMessage(title: 'حصن يومك', body: 'أذكار الصباح أمان وطمأنينة.'),
            _SmartMessage(title: 'لا تنس أذكار الصباح', body: 'دقائق يسيرة وأجر عظيم.'),
            _SmartMessage(title: 'صباحك بالذكر', body: 'اجعل أول يومك ذكرًا لله.'),
            _SmartMessage(title: 'بركة البداية', body: 'ابدأ الآن بأذكار الصباح.'),
          ],
          'azkarMasa_low': const [
            _SmartMessage(title: 'أذكار المساء 🌆', body: 'اختم يومك بذكر الله وطمأنينة القلب.'),
            _SmartMessage(title: 'مساء مبارك', body: 'لا تنس أذكار المساء قبل النوم.'),
            _SmartMessage(title: 'حصّن ليلك', body: 'أذكار المساء حفظ وراحة.'),
            _SmartMessage(title: 'قبل أن ينتهي اليوم', body: 'أكمل أذكار المساء الآن.'),
            _SmartMessage(title: 'ذكر يسير وأثر كبير', body: 'أذكار المساء بركة وخير.'),
          ],
          'hifz_low': const [
            _SmartMessage(title: 'خطوة حفظ اليوم 📚', body: 'آية واحدة بإتقان أفضل من الكثير المنقطع.'),
            _SmartMessage(title: 'وقت الحفظ', body: 'خذ دقائق للحفظ أو التسميع اليوم.'),
            _SmartMessage(title: 'استمر', body: 'النجاح في الحفظ مع الثبات اليومي.'),
            _SmartMessage(title: 'لا تقطع السلسلة', body: 'المداومة سر الإتقان في الحفظ.'),
            _SmartMessage(title: 'ابدأ بآية', body: 'ابدأ الآن وسيبارك الله في وقتك.'),
          ],
          'tasbih_low': const [
            _SmartMessage(title: 'لحظة تسبيح 💎', body: 'سبحان الله وبحمده تملأ الميزان.'),
            _SmartMessage(title: 'ذكر يسير', body: 'دقيقة تسبيح الآن تنعش القلب.'),
            _SmartMessage(title: 'اغتنم هذه اللحظة', body: 'أكثر من التسبيح يطمئن قلبك.'),
            _SmartMessage(title: 'التسبيح نور', body: 'ردد سبحان الله والحمد لله.'),
            _SmartMessage(title: 'لا تفوّت الأجر', body: 'اجعل لسانك رطبًا بالتسبيح.'),
          ],
          'dhikr_low': const [
            _SmartMessage(title: 'اذكر الله ✨', body: 'الذكر حياة القلب وسكينة النفس.'),
            _SmartMessage(title: 'تنبيه لطيف', body: 'قل: سبحان الله، والحمد لله، والله أكبر.'),
            _SmartMessage(title: 'دقيقة ذكر', body: 'استغفار وتسبيح يفتحان أبواب الطمأنينة.'),
            _SmartMessage(title: 'لا تغفل', body: 'اجعل لك نصيبًا دائمًا من الذكر.'),
            _SmartMessage(title: 'بقلب حاضر', body: 'اذكر الله الآن وستشعر بالسكينة.'),
          ],
        };

        final key = '${type.name}_${banks.containsKey('${type.name}_$bucket') ? bucket : 'low'}';
        final list = banks[key] ?? banks['${type.name}_low'] ?? const <_SmartMessage>[];
        if (list.isEmpty) {
          return const _SmartMessage(title: 'تذكير', body: 'لا تتوقف، واصل قربك من الله.');
        }
        final idx = (daySeed + score + type.index) % list.length;
        return list[idx];
      }

      String shortBody(String input) {
        final clean = input.trim();
        if (clean.length <= 95) return clean;
        return '${clean.substring(0, 95)}...';
      }

      Future<void> addFeaturePlan({
        required String featureKey,
        required int id,
        required DateTime when,
        required String defaultTitle,
        required String defaultBody,
        int priority = 1,
        String? payloadOverride,
        _IbadahSignalType? smartSignalType,
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
        final body = shortBody(selected?.shortExplanation.isNotEmpty == true
            ? selected!.shortExplanation
            : selected?.arabicText ?? defaultBody);
        final payload = payloadOverride ??
            (selected == null
            ? featureKey
            : jsonEncode({
                'content_id': selected.contentId,
                'category': selected.category,
              }));

        var finalTitle = title;
        var finalBody = body;
        var finalPayload = payload;
        var finalPriority = priority;

        if (smartSignalType != null) {
          final signalScore = await scoreSignal(smartSignalType);
          if (signalScore > 0) {
            final msg = pickSignalMessage(smartSignalType, signalScore);
            finalTitle = msg.title;
            finalBody = shortBody(msg.body);
            finalPayload = jsonEncode({
              'route': 'ibadah_signal',
              'signal': smartSignalType.name,
              'score': signalScore,
            });
            finalPriority = priority + signalScore;
          }
        }

        final effectiveWhen = normalizeToNext(when);

        planned.add(
          _PlannedNotification(
            id: id,
            when: effectiveWhen,
            title: finalTitle,
            body: finalBody,
            payload: finalPayload,
            priority: finalPriority,
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
        smartSignalType: _IbadahSignalType.wird,
      );

      await addFeaturePlan(
        featureKey: 'azkar',
        id: NotificationIds.azkarSabah,
        when: prayerTimes.fajr.add(const Duration(minutes: 5)),
        defaultTitle: 'أذكار الصباح 🌅',
        defaultBody: 'ابدأ يومك بذكر الله.',
        priority: 4,
        smartSignalType: _IbadahSignalType.azkarSabah,
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
        smartSignalType: _IbadahSignalType.azkarMasa,
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
        smartSignalType: _IbadahSignalType.hifz,
      );

      await addFeaturePlan(
        featureKey: 'tasbih',
        id: NotificationIds.tasbih,
        when: prayerTimes.dhuhr.add(const Duration(minutes: 20)),
        defaultTitle: 'لحظة للذكر والتسبيح 💎',
        defaultBody: 'اجعل لسانك رطبا بذكر الله.',
        priority: 1,
        smartSignalType: _IbadahSignalType.tasbih,
      );

      planned.add(
        _PlannedNotification(
          id: 121,
          when: normalizeToNext(prayerTimes.isha.add(const Duration(minutes: 15))),
          title: 'ذكر الله حياة للقلب ✨',
          body: 'دقيقة ذكر قد تغير يومك كله.',
          payload: await signalPayload(_IbadahSignalType.dhikr) ??
              jsonEncode({'route': 'ibadah_signal', 'signal': 'dhikr', 'score': 1}),
          priority: 2,
        ),
      );

      planned.add(
        _PlannedNotification(
          id: 122,
          when: normalizeToNext(prayerTimes.maghrib.subtract(const Duration(minutes: 25))),
          title: 'مكان صلاة الجماعة بانتظارك 🕌',
          body: 'الخطوات إلى المسجد ترفع الدرجات وتمحو السيئات.',
          payload: await signalPayload(_IbadahSignalType.masjid),
          priority: 4,
        ),
      );

      planned.add(
        _PlannedNotification(
          id: 123,
          when: normalizeToNext(prayerTimes.isha.subtract(const Duration(minutes: 15))),
          title: 'لا تنهِ يومك دون صلاة العشاء 🌙',
          body: 'أدها في وقتها ليهدأ قلبك وتكتمل بركة يومك.',
          payload: await signalPayload(_IbadahSignalType.prayer),
          priority: 5,
        ),
      );

      planned.add(
        _PlannedNotification(
          id: NotificationIds.dailyReport,
          when: normalizeToNext(prayerTimes.maghrib.add(const Duration(minutes: 20))),
          title: 'تقريرك اليومي جاهز 📋',
          body: 'راجع يومك الآن وخذ خطوة صادقة لغد أفضل.',
          payload: jsonEncode({'route': 'daily_report'}),
          priority: 4,
        ),
      );

      planned.add(
        _PlannedNotification(
          id: NotificationIds.goldenFajr,
          when: normalizeToNext(prayerTimes.fajr.add(const Duration(minutes: 5))),
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
            when: normalizeToNext(DateTime(base.year, base.month, base.day, 8)),
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
            when: normalizeToNext(DateTime(base.year, base.month, base.day, 10, 0)),
            title: 'أكثر من الصلاة على النبي ﷺ',
            body: 'اللهم صل وسلم على نبينا محمد.',
            payload: 'friday_salawat_a',
            priority: 3,
          ),
        );
        planned.add(
          _PlannedNotification(
            id: NotificationIds.fridaySalawatB,
            when: normalizeToNext(DateTime(base.year, base.month, base.day, 12, 0)),
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
      final weighted = <_PlannedNotification>[];
      for (final item in todayPlans) {
        if (item.payload == null) {
          weighted.add(item);
          continue;
        }
        try {
          final map = jsonDecode(item.payload!) as Map<String, dynamic>;
          if (map['route'] == 'ibadah_signal') {
            final score = (map['score'] as num?)?.toInt() ?? 0;
            weighted.add(item.copyWith(priority: item.priority + score));
            continue;
          }
        } catch (_) {}
        weighted.add(item);
      }

      weighted.sort((a, b) {
        final byPriority = b.priority.compareTo(a.priority);
        if (byPriority != 0) return byPriority;
        return a.when.compareTo(b.when);
      });

      final selected = <_PlannedNotification>[];
      for (final plan in weighted) {
        if (selected.length >= 3) break;
        if (selected.isEmpty) {
          selected.add(plan);
          continue;
        }
        final tooClose = selected.any((s) => plan.when.difference(s.when).inMinutes.abs() < 120);
        if (!tooClose) {
          selected.add(plan);
        }
      }

      final finalPlans = selected..sort((a, b) => a.when.compareTo(b.when));

      for (final item in finalPlans) {
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
      final nextPrayerTime = prayerTime.isAfter(now)
          ? prayerTime
          : prayerTime.add(const Duration(days: 1));

      await _notificationService.scheduleNotification(
        id: NotificationService.getNotificationId(prayerName),
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
  final int id;
  final DateTime when;
  final String title;
  final String body;
  final String? payload;
  final int priority;

  _PlannedNotification({
    required this.id,
    required this.when,
    required this.title,
    required this.body,
    required this.payload,
    required this.priority,
  });

  _PlannedNotification copyWith({int? priority}) {
    return _PlannedNotification(
      id: id,
      when: when,
      title: title,
      body: body,
      payload: payload,
      priority: priority ?? this.priority,
    );
  }
}
