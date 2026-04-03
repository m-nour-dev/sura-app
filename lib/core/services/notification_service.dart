import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/core/presentation/widgets/update_dialog.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/core/services/isar_service.dart';
import 'package:sila_app/core/services/remote_config_service.dart';
import 'package:sila_app/core/services/update_service.dart';
import 'package:sila_app/features/ibadah_tracker/presentation/pages/daily_report_page.dart';
import 'package:sila_app/features/notifications/data/notification_ids.dart';
import 'package:sila_app/features/notifications/data/repositories/isar_notification_repository.dart';
import 'package:sila_app/features/notifications/presentation/pages/notification_detail_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/prayers_page.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  final payload = response.payload;
  if (payload == null || payload.trim().isEmpty) return;
  // Persist only; UI navigation is resumed on app foreground.
  NotificationService().saveDeferredPayload(payload.trim());
}

class NotificationService {
  factory NotificationService() => _instance;
  NotificationService._internal();
  // Notification channel keys
  static const _channels = {
    'adhan': 'adhan_channel',
    'reminder': 'reminder_channel',
    'report': 'report_channel',
    'update': 'update_channel',
  };
  static final NotificationService _instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  GlobalKey<NavigatorState>? _navigatorKey;
  String? _deferredPayload;

  static const int _adhanPlaybackNotificationId = 9090;
  static const String _stopAdhanActionId = 'stop_adhan';

  // Download notification constants
  static const int downloadNotificationId = 9000;
  static const String _installApkActionId = 'install_apk';
  static const String _retryDownloadActionId = 'retry_download';
  String? _lastDownloadApkPath;
  String? _lastDownloadUrl;

  bool _initialized = false;
  bool _initializing = false;

  // Channel & schedule migration versions
  // ارفع الرقم كل ما تغيّر الـ channels أو الـ scheduling logic
  static const int _channelVersion = 5;
  static const int _scheduleVersion = 5;

  Future<void> initialize() async {
    if (_initialized || _initializing) return;
    _initializing = true;

    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      await _createNotificationChannel();

      // ✅ ADD: Migration للمستخدمين القدامى
      await _migrateChannelsIfNeeded();
      await _rescheduleAfterMigration();
      // ─────────────────────────────────────

      final launchDetails =
          await _notifications.getNotificationAppLaunchDetails();
      final launchPayload = launchDetails?.notificationResponse?.payload;
      if (launchPayload != null && launchPayload.trim().isNotEmpty) {
        handleNotificationPayload(launchPayload);
      }

      try {
        await FirebaseMessaging.instance.requestPermission();
        await FirebaseMessaging.instance.subscribeToTopic('all_users');
        await FirebaseMessaging.instance.subscribeToTopic('updates');

        FirebaseMessaging.onMessage.listen((message) {
          if (message.data['type'] == 'update') {
            _showUpdateNotification(message);
          }
        });

        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          if (message.data['type'] == 'update') {
            _showUpdateNotification(message);
          }
        });
      } catch (e) {
        debugPrint('Firebase Messaging setup failed: $e');
      }

      _initialized = true;
      debugPrint('NotificationService: Initialized');
    } catch (e) {
      debugPrint('NotificationService initialization error: $e');
      _initialized = true;
    } finally {
      _initializing = false;
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  Future<void> setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;
    final prefs = await SharedPreferences.getInstance();
    final payload = prefs.getString('pending_notification_payload') ?? _deferredPayload;
    
    if (payload != null) {
      _deferredPayload = null;
      await prefs.remove('pending_notification_payload');
      Future<void>.microtask(() => handleNotificationPayload(payload));
    }
  }

  void saveDeferredPayload(String payload) async {
    _deferredPayload = payload;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pending_notification_payload', payload);
    } catch (_) {}
  }

  Future<void> _createNotificationChannel() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Adhan channel (for prayer times only)
    await android?.createNotificationChannel(const AndroidNotificationChannel(
      'adhan_channel',
      'أذان الصلاة',
      description: 'إشعارات أذان الصلاة',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      sound: RawResourceAndroidNotificationSound('adhan_egypt'),
    ));

    // Reminders channel (for wird, azkar, tasbih, etc.)
    await android?.createNotificationChannel(const AndroidNotificationChannel(
      'reminder_channel',
      'التذكيرات اليومية',
      description: 'تذكيرات العبادات اليومية',
      importance: Importance.defaultImportance,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('reminder_tone'),
    ));

    // Report channel (for daily report)
    await android?.createNotificationChannel(const AndroidNotificationChannel(
      'report_channel',
      'التقرير اليومي',
      description: 'إشعارات التقرير اليومي',
      importance: Importance.low,
      playSound: false,
    ));

    // Update channel (for app updates)
    await android?.createNotificationChannel(const AndroidNotificationChannel(
      'update_channel',
      'تحديثات التطبيق',
      description: 'إشعارات تحديث التطبيق',
      importance: Importance.low,
      playSound: false,
    ));
  }

  /// يحذف الـ channels القديمة ويعيد إنشاءها لو في migration مطلوبة
  Future<void> _migrateChannelsIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedVersion = prefs.getInt('channel_version') ?? 1;

      if (savedVersion >= _channelVersion) return; // مفيش migration مطلوبة

      // ✅ احفظ الـ version أول حاجة
      await prefs.setInt('channel_version', _channelVersion);

      debugPrint('🔄 Migrating notification channels from v$savedVersion to v$_channelVersion');

      final android = _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (android != null) {
        final existingChannels = await android.getNotificationChannels();
        debugPrint('🔍 Found ${existingChannels?.length ?? 0} existing channels to review');

        // احذف الـ channels القديمة عشان تتعمل من جديد بالإعدادات الصح
        await android.deleteNotificationChannel('adhan_channel');
        await android.deleteNotificationChannel('reminder_channel');
        await android.deleteNotificationChannel('report_channel');
        await android.deleteNotificationChannel('update_channel');
        debugPrint('🗑️ Old channels requested to be deleted');

        // أعد إنشاءها بالإعدادات الصحيحة
        await _createNotificationChannel();
        debugPrint('✅ New channels created');
      }

      debugPrint('✅ Channel migration complete: v$_channelVersion');
    } catch (e) {
      debugPrint('Channel migration error (non-fatal): $e');
      // لا توقف التطبيق لو فشلت الـ migration
    }
  }

  /// يعيد جدولة الإشعارات بعد الـ migration
  Future<void> _rescheduleAfterMigration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedVersion = prefs.getInt('schedule_version') ?? 1;

      if (savedVersion >= _scheduleVersion) return; // مفيش reschedule مطلوب

      // ✅ احفظ الـ version أول حاجة قبل أي عملية لمنع Infinite Loop
      await prefs.setInt('schedule_version', _scheduleVersion);

      debugPrint('🔄 Rescheduling notifications after migration...');

      // إلغاء كل الإشعارات القديمة المجدولة على الـ channels الغلط
      await cancelAllNotifications();
      debugPrint('🗑️ Old scheduled notifications cancelled');

      // rescheduleAllOnBoot هيعيد جدولة الـ reminders الثابتة
      // إشعارات الصلاة هتتجدول تلقائياً أول ما المستخدم يفتح الـ prayers page
      await rescheduleAllOnBoot();

      debugPrint('✅ Reschedule complete');
    } catch (e) {
      debugPrint('Reschedule after migration error (non-fatal): $e');
    }
  }

  Future<bool> requestPermissions() async {
    debugPrint('🔔 Requesting notification permissions...');

    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Step 1: POST_NOTIFICATIONS (Android 13+)
    try {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        if (!result.isGranted) {
          debugPrint('❌ Notification permission denied');
        }
      }

      // Plugin-level request (Android 13+) for better OEM compatibility.
      await android?.requestNotificationsPermission();
    } catch (e) {
      debugPrint('❌ POST_NOTIFICATIONS error: $e');
    }

    // Step 2: SCHEDULE_EXACT_ALARM (Android 12+)
    try {
      final exactStatus = await Permission.scheduleExactAlarm.status;
      if (!exactStatus.isGranted) {
        final result = await Permission.scheduleExactAlarm.request();
        if (!result.isGranted) {
          await openAppSettings();
        }
      }

      // Plugin-level exact alarm request (Android 12+) for better compatibility.
      await android?.requestExactAlarmsPermission();
    } catch (e) {
      debugPrint('❌ SCHEDULE_EXACT_ALARM error: $e');
    }

    // ✅ ADD — Step 3: Battery Optimization Exemption
    try {
      final batteryStatus =
          await Permission.ignoreBatteryOptimizations.status;
      if (!batteryStatus.isGranted) {
        await Permission.ignoreBatteryOptimizations.request();
        debugPrint('🔋 Battery optimization exemption requested');
      }
    } catch (e) {
      debugPrint('❌ Battery optimization error: $e');
    }
    // ─────────────────────────────────────────────────────

    debugPrint('✅ Permission requests complete');
    return await Permission.notification.isGranted;
  }

  Future<bool> scheduleNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
    required String soundFile,
  }) async {
    if (!_initialized) {
      debugPrint('❌ NotificationService not initialized');
      return false;
    }

    final scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);

    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      debugPrint('⚠️ Skipping past notification: $prayerName');
      return false;
    }

    debugPrint('📅 Scheduling: $prayerName at $scheduledTime');

    final soundName = soundFile.split('.').first;

    final androidDetails = AndroidNotificationDetails(
      _channels['adhan']!,
      'أذان الصلاة',
      channelDescription: 'إشعارات أذان الصلاة',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      sound: RawResourceAndroidNotificationSound(soundName),
      enableVibration: true,
      fullScreenIntent: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: soundFile,
      ),
    );

    // Try exact alarm first
    try {
      final localizedPrayerName = _localizedPrayerName(prayerName);
      await _notifications.zonedSchedule(
        id,
        '🕌 حان وقت $localizedPrayerName',
        'حان وقت الصلاة — $localizedPrayerName',
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: prayerName,
      );
      debugPrint('✅ Exact alarm scheduled: $prayerName');
      return true;
    } catch (e) {
      debugPrint('⚠️ Exact alarm failed: $e — trying inexact');
    }

    // Fallback: inexact alarm
    try {
      final localizedPrayerName = _localizedPrayerName(prayerName);
      await _notifications.zonedSchedule(
        id,
        '🕌 حان وقت $localizedPrayerName',
        'حان وقت الصلاة — $localizedPrayerName',
        scheduledTime,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: prayerName,
      );
      debugPrint('✅ Inexact alarm scheduled: $prayerName');
      return true;
    } catch (e) {
      debugPrint('❌ Both alarm modes failed: $e');
      return false;
    }
  }

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    if (!_initialized) await initialize();

    // Timezone safety check: ensure local timezone object is accessible.
    late final tz.Location location;
    try {
      location = tz.local;
    } catch (e) {
      debugPrint('Timezone not ready in scheduleDaily: $e');
      location = tz.local;
    }

    final scheduledTime = tz.TZDateTime.from(dateTime, location);

    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'التذكيرات اليومية',
      channelDescription: 'تذكيرات العبادات اليومية',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      icon: '@drawable/ic_notification',
      sound: RawResourceAndroidNotificationSound('reminder_tone'),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'reminder_tone.aiff',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      try {
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduledTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e2) {
        debugPrint('Error scheduling daily reminder: $e / fallback: $e2');
      }
    }
  }

  Future<void> scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
    String channelKey = 'reminder',
  }) async {
    if (!_initialized) await initialize();
    final scheduledTime = tz.TZDateTime.from(dateTime, tz.local);

    final channelId = _channels[channelKey] ?? _channels['reminder']!;
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelKey == 'adhan'
          ? 'أذان الصلاة'
          : channelKey == 'reminder'
              ? 'التذكيرات اليومية'
              : channelKey == 'report'
                  ? 'التقرير اليومي'
                  : channelKey == 'update'
                      ? 'تحديثات التطبيق'
                      : 'إشعارات',
      channelDescription: channelKey == 'adhan'
          ? 'إشعارات أذان الصلاة'
          : channelKey == 'reminder'
              ? 'تذكيرات العبادات اليومية'
              : channelKey == 'report'
                  ? 'إشعارات التقرير اليومي'
                  : channelKey == 'update'
                      ? 'إشعارات تحديث التطبيق'
                      : 'إشعارات',
      importance: channelKey == 'adhan'
          ? Importance.max
          : channelKey == 'reminder'
              ? Importance.defaultImportance
              : channelKey == 'report'
                  ? Importance.low
                  : channelKey == 'update'
                      ? Importance.low
                      : Importance.defaultImportance,
      priority: channelKey == 'adhan'
          ? Priority.high
          : channelKey == 'reminder'
              ? Priority.defaultPriority
              : channelKey == 'report'
                  ? Priority.low
                  : channelKey == 'update'
                      ? Priority.low
                      : Priority.defaultPriority,
      playSound: channelKey == 'adhan' ? true : channelKey == 'reminder',
      enableVibration: channelKey == 'adhan' || channelKey == 'reminder',
      enableLights: channelKey == 'adhan' || channelKey == 'reminder',
      icon: '@drawable/ic_notification',
      sound: channelKey == 'adhan'
          ? const RawResourceAndroidNotificationSound('adhan_egypt')
          : channelKey == 'reminder'
              ? const RawResourceAndroidNotificationSound('reminder_tone')
              : null,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      try {
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduledTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        );
      } catch (fallbackError) {
        debugPrint(
            'Error scheduling one-shot notification: $e / fallback: $fallbackError');
      }
    }
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'adhan_channel',
      'أذان الصلاة',
      channelDescription: 'إشعارات أذان الصلاة',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      icon: '@drawable/ic_notification',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, notificationDetails,
        payload: payload);
  }

  // ─── Download Notification Methods ─────────────────────────────────

  /// Localized download texts map
  static const _dlTexts = {
    'ar': {
      'downloading': 'جاري تحميل التحديث...',
      'body_pct': 'تم تحميل {}%',
      'complete': '✅ التحديث جاهز',
      'install': 'اضغط للتثبيت',
      'error': '❌ فشل التحميل',
      'error_net': 'تحقق من الاتصال بالإنترنت',
      'error_storage': 'مساحة التخزين غير كافية',
      'error_url': 'رابط التحديث غير متاح',
      'waiting': '⏳ بانتظار الاتصال',
      'retrying': 'جاري إعادة المحاولة...',
      'retry': 'إعادة المحاولة',
    },
    'en': {
      'downloading': 'Downloading update...',
      'body_pct': '{}% downloaded',
      'complete': '✅ Update ready',
      'install': 'Tap to install',
      'error': '❌ Download failed',
      'error_net': 'Check your internet connection',
      'error_storage': 'Not enough storage space',
      'error_url': 'Update link unavailable',
      'waiting': '⏳ Waiting for connection',
      'retrying': 'Retrying...',
      'retry': 'Retry',
    },
    'tr': {
      'downloading': 'Güncelleme indiriliyor...',
      'body_pct': '%{} indirildi',
      'complete': '✅ Güncelleme hazır',
      'install': 'Yüklemek için dokunun',
      'error': '❌ İndirme başarısız',
      'error_net': 'İnternet bağlantınızı kontrol edin',
      'error_storage': 'Yetersiz depolama alanı',
      'error_url': 'Güncelleme bağlantısı kullanılamıyor',
      'waiting': '⏳ Bağlantı bekleniyor',
      'retrying': 'Yeniden deneniyor...',
      'retry': 'Yeniden dene',
    },
    'fr': {
      'downloading': 'Téléchargement en cours...',
      'body_pct': '{}% téléchargé',
      'complete': '✅ Mise à jour prête',
      'install': 'Appuyez pour installer',
      'error': '❌ Échec du téléchargement',
      'error_net': 'Vérifiez votre connexion internet',
      'error_storage': 'Espace de stockage insuffisant',
      'error_url': 'Lien de mise à jour indisponible',
      'waiting': '⏳ En attente de connexion',
      'retrying': 'Nouvelle tentative...',
      'retry': 'Réessayer',
    },
  };

  String _dl(String key, String locale) {
    return _dlTexts[locale]?[key] ?? _dlTexts['ar']![key]!;
  }

  Future<void> showDownloadProgress({
    required int id,
    required String locale,
    required int percent,
  }) async {
    if (!_initialized) await initialize();
    final title = _dl('downloading', locale);
    final body = _dl('body_pct', locale).replaceFirst('{}', '$percent');
    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'التحديثات',
      channelDescription: 'إشعارات تحميل التحديثات',
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      showProgress: true,
      maxProgress: 100,
      progress: percent,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      icon: '@drawable/ic_notification',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );
    final details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notifications.show(id, title, body, details,
        payload: 'download_progress');
  }

  Future<void> showDownloadComplete({
    required int id,
    required String locale,
    required String apkPath,
  }) async {
    if (!_initialized) await initialize();
    _lastDownloadApkPath = apkPath;
    final title = _dl('complete', locale);
    final body = _dl('install', locale);
    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'التحديثات',
      channelDescription: 'إشعارات تحميل التحديثات',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@drawable/ic_notification',
      actions: [
        AndroidNotificationAction(
          _installApkActionId,
          _dl('install', locale),
          cancelNotification: true,
          showsUserInterface: true,
        ),
      ],
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    final details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notifications.show(id, title, body, details,
        payload: 'install_apk:$apkPath');
  }

  Future<void> showDownloadError({
    required int id,
    required String locale,
    required String errorType,
    String? downloadUrl,
    bool withRetry = false,
  }) async {
    if (!_initialized) await initialize();
    _lastDownloadUrl = downloadUrl;
    final title = _dl('error', locale);
    String body;
    switch (errorType) {
      case 'storage':
        body = _dl('error_storage', locale);
        break;
      case 'url':
        body = _dl('error_url', locale);
        break;
      default:
        body = _dl('error_net', locale);
    }
    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'التحديثات',
      channelDescription: 'إشعارات تحميل التحديثات',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: true,
      icon: '@drawable/ic_notification',
      actions: withRetry
          ? [
              AndroidNotificationAction(
                _retryDownloadActionId,
                _dl('retry', locale),
                showsUserInterface: true,
              ),
            ]
          : null,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );
    final details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notifications.show(id, title, body, details,
        payload: withRetry ? 'retry_download' : 'download_error');
  }

  Future<void> showDownloadWaiting({
    required int id,
    required String locale,
  }) async {
    if (!_initialized) await initialize();
    final title = _dl('waiting', locale);
    final body = _dl('retrying', locale);
    const androidDetails = AndroidNotificationDetails(
      'download_channel',
      'التحديثات',
      channelDescription: 'إشعارات تحميل التحديثات',
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      ongoing: true,
      autoCancel: false,
      showProgress: true,
      indeterminate: true,
      icon: '@drawable/ic_notification',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notifications.show(id, title, body, details,
        payload: 'download_waiting');
  }

  String? get lastDownloadApkPath => _lastDownloadApkPath;
  String? get lastDownloadUrl => _lastDownloadUrl;

  Future<void> rescheduleAllOnBoot() async {
    if (!_initialized) await initialize();
    try {
      final isar = await IsarService().db;
      final repo = IsarNotificationRepository(isar);
      final allSettings = await repo.getAllSettings();
      for (final setting in allSettings) {
        if (!setting.isEnabled || setting.timingType != 'fixed') continue;
        final now = DateTime.now();
        var scheduled = DateTime(
          now.year,
          now.month,
          now.day,
          setting.fixedHour,
          setting.fixedMinute,
        );
        if (!scheduled.isAfter(now)) {
          scheduled = scheduled.add(const Duration(days: 1));
        }
        await scheduleDaily(
          id: NotificationIds.userCustomDailyOffset + setting.id,
          title: 'تذكير ${setting.featureKey}',
          body: 'لا تنس وردك اليومي',
          dateTime: scheduled,
        );
      }

      final pending = await getPendingNotifications();
      final hasSmartIds = pending.any((n) => n.id >= 100 && n.id <= 199);
      if (!hasSmartIds) {
        await _ensureFallbackSmartNotifications();
      }
    } catch (e) {
      debugPrint('rescheduleAllOnBoot failed: $e');
    }
  }

  Future<void> _ensureFallbackSmartNotifications() async {
    final now = DateTime.now();

    Future<DateTime> at(int hour, int minute) async {
      var dt = DateTime(now.year, now.month, now.day, hour, minute);
      if (!dt.isAfter(now)) dt = dt.add(const Duration(days: 1));
      return dt;
    }

    await scheduleOneShot(
      id: NotificationIds.wird,
      title: 'وقت وردك القرآني 📖',
      body: 'خصص دقائق لوردك اليومي.',
      dateTime: await at(7, 0),
      payload: 'wird_reminder',
    );
    await scheduleOneShot(
      id: NotificationIds.azkarSabah,
      title: 'أذكار الصباح 🌅',
      body: 'ابدأ يومك بذكر الله.',
      dateTime: await at(5, 0),
      payload: 'azkar_sabah',
    );
    await scheduleOneShot(
      id: NotificationIds.tasbih,
      title: 'لحظة للذكر والتسبيح ✦',
      body: 'اجعل لسانك رطبًا بذكر الله.',
      dateTime: await at(13, 30),
      payload: 'tasbih_reminder',
    );

    await scheduleOneShot(
      id: NotificationIds.dailyReport,
      title: 'تقريرك اليومي جاهز 📋',
      body: 'بعد المغرب: افتح متابعتي وراجع يومك بصدق وطمأنينة.',
      dateTime: await at(18, 30),
      payload: jsonEncode({'route': 'daily_report'}),
    );
  }

  /// Play Adhan sound directly in-app
  Future<void> playAdhan(String soundFile) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      if (soundFile.startsWith('http://') || soundFile.startsWith('https://')) {
        await _audioPlayer.play(UrlSource(soundFile));
      } else {
        await _audioPlayer.play(AssetSource('audio/$soundFile'));
      }
      await _showAdhanPlaybackNotification();
      print('Playing Adhan: $soundFile');
    } catch (e) {
      print('Error playing $soundFile, trying fallback: $e');
      // Try any available audio file as fallback
      try {
        await _audioPlayer.stop();
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);
        await _audioPlayer.play(AssetSource('audio/adhan_egypt.mp3'));
        await _showAdhanPlaybackNotification();
      } catch (e2) {
        print('Fallback audio also failed: $e2');
      }
    }
  }

  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
    await cancelNotification(_adhanPlaybackNotificationId);
  }

  Future<void> _showAdhanPlaybackNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'adhan_channel',
      'أذان الصلاة',
      channelDescription: 'إشعارات أذان الصلاة',
      importance: Importance.max,
      priority: Priority.high,
      playSound: false,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      icon: '@drawable/ic_notification',
      actions: [
        AndroidNotificationAction(
          _stopAdhanActionId,
          'إيقاف الأذان',
          cancelNotification: true,
          showsUserInterface: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notifications.show(
      _adhanPlaybackNotificationId,
      'الأذان يعمل الآن',
      'اضغط لإيقاف الأذان',
      details,
      payload: _stopAdhanActionId,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  Future<void> logNotificationHealth() async {
    try {
      final notif = await Permission.notification.status;
      final exact = await Permission.scheduleExactAlarm.status;
      final battery = await Permission.ignoreBatteryOptimizations.status;
      final pending = await getPendingNotifications();

      debugPrint('🩺 Notification health check');
      debugPrint('  - POST_NOTIFICATIONS: $notif');
      debugPrint('  - SCHEDULE_EXACT_ALARM: $exact');
      debugPrint('  - IGNORE_BATTERY_OPT: $battery');
      debugPrint('  - Pending notifications: ${pending.length}');
    } catch (e) {
      debugPrint('Notification health check failed: $e');
    }
  }

  Future<void> scheduleDebugNotificationInSeconds({int seconds = 15}) async {
    if (!_initialized) await initialize();

    await logNotificationHealth();

    final permissionGranted = await requestPermissions();
    if (!permissionGranted) {
      debugPrint('❌ Debug notification aborted: notification permission denied');
      return;
    }

    await cancelNotification(NotificationIds.testNotificationFixedId - 1);
    await cancelNotification(NotificationIds.testNotificationFixedId);

    final now = DateTime.now();
    final at = now.add(Duration(seconds: seconds));

    await showInstantNotification(
      id: NotificationIds.testNotificationFixedId - 1, // 9900
      title: 'اختبار فوري',
      body: 'إذا ظهر هذا فورًا فالصلاحية الأساسية تعمل.',
      payload: jsonEncode({'route': 'debug_notification_now'}),
    );
    await scheduleOneShot(
      id: NotificationIds.testNotificationFixedId, // 9901
      title: 'اختبار الإشعارات ✅',
      body: 'إذا ظهر هذا الإشعار فالنظام يعمل بشكل صحيح.',
      dateTime: at,
      payload: jsonEncode({'route': 'debug_notification'}),
    );

    final pending = await getPendingNotifications();
    debugPrint('🧪 Debug test scheduled. Pending notifications count: ${pending.length}');
  }

  Future<void> showTestNotification() async {
    try {
      await _notifications.show(
        NotificationIds.testNotificationFixedId + 998, // 10899 (dummy testing)
        'سِلى — اختبار الإشعارات 🕌',
        'إذا وصلك هذا الإشعار فالنظام يعمل بشكل صحيح',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'adhan_channel',
            'أذان الصلاة',
            channelDescription: 'إشعارات أذان الصلاة',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: 'test',
      );
      debugPrint('✅ Test notification sent');
    } catch (e) {
      debugPrint('❌ Test notification failed: $e');
    }
  }

  Future<bool> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String payload = '',
  }) async {
    if (!_initialized) return false;

    debugPrint('📅 Scheduling daily: $title at $hour:$minute');

    // FIXED: Bug 2 — Build TZDateTime at the correct hour/minute, then use zonedSchedule with matchDateTimeComponents
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now) || scheduled.isAtSameMomentAs(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'adhan_channel',
      'أذان الصلاة',
      channelDescription: 'إشعارات أذان الصلاة',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents
            .time, // FIXED: Bug 2 — Repeats daily at exact hour:minute
        payload: payload,
      );
      debugPrint('✅ Daily reminder scheduled: $title at $hour:$minute');
      return true;
    } catch (e) {
      debugPrint('⚠️ Exact daily reminder failed, trying inexact: $e');
      try {
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduled,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time, // FIXED: Bug 2
          payload: payload,
        );
        debugPrint(
            '✅ Inexact daily reminder scheduled: $title at $hour:$minute');
        return true;
      } catch (e2) {
        debugPrint('❌ Daily reminder failed: $e / fallback: $e2');
        return false;
      }
    }
  }

  void _onNotificationTap(NotificationResponse response) async {
    // Track interaction before navigation
    await _recordTap(response.payload);

    if (response.actionId == _stopAdhanActionId ||
        response.payload == _stopAdhanActionId) {
      await stopAdhan();
      return;
    }

    // Handle install APK action
    if (response.actionId == _installApkActionId ||
        (response.payload != null &&
            response.payload!.startsWith('install_apk:'))) {
      final path = response.actionId == _installApkActionId
          ? _lastDownloadApkPath
          : response.payload!.replaceFirst('install_apk:', '');
      if (path != null) {
        await OpenFile.open(path);
      }
      return;
    }

    // Handle retry download action — store URL for next launch check
    if (response.actionId == _retryDownloadActionId ||
        response.payload == 'retry_download') {
      // The retry callback will be invoked if set by UpdateService
      if (_onRetryDownload != null && _lastDownloadUrl != null) {
        _onRetryDownload!(_lastDownloadUrl!);
      }
      return;
    }

    handleNotificationPayload(response.payload);
  }

  Future<void> _recordTap(String? payload) async {
    if (payload == null) return;
    try {
      final isar = await IsarService().db;
      final repo = IsarNotificationRepository(isar);
      final featureKey = _extractFeatureKey(payload);
      if (featureKey == null) return;
      final settings = await repo.getSettings(featureKey);

      settings.tapCount += 1;
      settings.consecutiveIgnored = 0;
      settings.lastTappedAt = DateTime.now();

      // حساب متوسط وقت الاستجابة
      if (settings.lastShownAt != null) {
        final delay = DateTime.now().difference(settings.lastShownAt!).inMinutes;
        if (settings.avgResponseMinutes == -1) {
          settings.avgResponseMinutes = delay;
        } else {
          settings.avgResponseMinutes =
              ((settings.avgResponseMinutes * 0.7) + (delay * 0.3)).round();
        }
      }

      await repo.saveSettings(settings);
    } catch (e) {
      debugPrint('recordTap failed: $e');
    }
  }

  String? _extractFeatureKey(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        return decoded['feature_key'] as String? ??
            decoded['category'] as String?;
      }
    } catch (_) {}
    // payloads النصية المباشرة
    const knownKeys = {
      'wird_reminder': 'wird',
      'azkar_sabah': 'azkar',
      'tasbih_reminder': 'tasbih',
    };
    return knownKeys[payload];
  }

  /// Callback invoked when user taps "Retry" on a failed download notification.
  /// Set by UpdateService.downloadInBackground().
  void Function(String url)? _onRetryDownload;
  void setRetryCallback(void Function(String url) callback) {
    _onRetryDownload = callback;
  }

  Future<void> handleNotificationPayload(String? payload) async {
    if (payload == null || payload.trim().isEmpty) return;

    final normalized = payload.trim();

    // FIXED: Bug 3 — Removed playAdhan() for prayer payloads.
    // The OS already plays the adhan sound natively via RawResourceAndroidNotificationSound on the channel.
    // On tap, we only navigate to the prayers page so the user can see prayer info.
    final adhanPayloads = {'fajr', 'dhuhr', 'asr', 'maghrib', 'isha'};
    if (adhanPayloads.contains(normalized.toLowerCase())) {
      final nav = _navigatorKey?.currentState;
      if (nav == null) {
        _deferredPayload = normalized;
        return;
      }
      nav.push(MaterialPageRoute(builder: (_) => const PrayersPage()));
      return;
    }

    final nav = _navigatorKey?.currentState;
    if (nav == null) {
      _deferredPayload = normalized;
      return;
    }

    try {
      final decoded = jsonDecode(normalized);
      if (decoded is Map<String, dynamic> &&
          decoded.containsKey('content_id') &&
          decoded.containsKey('category')) {
        // FIXED: Bug 4 — Increment shownCount when the user actually taps the notification
        try {
          final isar = await IsarService().db;
          final repo = IsarNotificationRepository(isar);
          final content = await repo
              .getContentByContentId(decoded['content_id'].toString());
          if (content != null) {
            content.shownCount = content.shownCount + 1;
            content.lastShown = DateTime.now();
            await repo.saveContent(content);
          }
        } catch (e) {
          debugPrint('Failed to update shownCount: $e');
        }

        nav.push(
          MaterialPageRoute(
            builder: (_) => NotificationDetailPage(
              contentId: decoded['content_id'].toString(),
              category: decoded['category'].toString(),
            ),
          ),
        );
        return;
      }

      if (decoded is Map<String, dynamic> &&
          decoded['route'] == 'daily_report') {
        nav.push(MaterialPageRoute(builder: (_) => const DailyReportPage()));
        return;
      }

      if (decoded is Map<String, dynamic> &&
          decoded['route'] == 'ibadah_signal') {
        nav.push(MaterialPageRoute(
            builder: (_) => const PrayersPage(initialTabIndex: 1)));
        return;
      }
    } catch (_) {
      // ignore malformed payloads
    }
  }

  /// Get prayer name in current app locale for notifications
  String _localizedPrayerName(String key) {
    final navigatorContext = _navigatorKey?.currentContext;
    final locale = navigatorContext != null
        ? EasyLocalization.of(navigatorContext)?.locale.languageCode ?? 'ar'
        : 'ar';
    final map = _prayerNames[locale] ?? _prayerNames['ar']!;
    return map[key.toLowerCase()] ?? key;
  }

  static const _prayerNames = {
    'ar': {
      'fajr': 'الفجر',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء'
    },
    'en': {
      'fajr': 'Fajr',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha'
    },
    'tr': {
      'fajr': 'İmsak',
      'dhuhr': 'Öğle',
      'asr': 'İkindi',
      'maghrib': 'Akşam',
      'isha': 'Yatsı'
    },
    'fr': {
      'fajr': 'Fajr',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha'
    },
  };

  String _getPrayerNameArabic(String name) {
    const map = {
      'fajr': 'الفجر',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
    };
    return map[name.toLowerCase()] ?? name;
  }

  static int getNotificationId(String prayerName) {
    const map = {'fajr': 1, 'dhuhr': 2, 'asr': 3, 'maghrib': 4, 'isha': 5};
    return map[prayerName.toLowerCase()] ?? 0;
  }

  static bool _isUpdateDialogOpen = false;

  Future<void> _showUpdateNotification(RemoteMessage message) async {
    final context = _navigatorKey?.currentContext;
    if (context == null) return;

    if (_isUpdateDialogOpen) return;
    _isUpdateDialogOpen = true;

    final analytics = AnalyticsService();
    final updateService = UpdateService(analytics: analytics);
    final remoteConfig = RemoteConfigService();
    await remoteConfig.initialize();

    final version =
        int.tryParse(message.data['version']?.toString() ?? '') ?? 0;
    final apkUrl = (message.data['apk_url']?.toString() ?? '').isNotEmpty
        ? message.data['apk_url']!.toString()
        : remoteConfig.apkUrl;

    final result = UpdateCheckResult(
      hasUpdate: true,
      isForced: remoteConfig.forceUpdate,
      latestVersion: version,
      apkUrl: apkUrl,
      releaseNotes: message.data['release_notes']?.toString() ?? '',
    );

    await analytics.logUpdateDialogShown(newVersion: version);

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => UpdateDialog(
        updateResult: result,
        updateService: updateService,
        analyticsService: analytics,
      ),
    ).then((_) => _isUpdateDialogOpen = false);
  }
}
