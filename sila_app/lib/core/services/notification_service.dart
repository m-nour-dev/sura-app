import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sila_app/core/services/isar_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/core/presentation/widgets/update_dialog.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/core/services/remote_config_service.dart';
import 'package:sila_app/core/services/update_service.dart';
import 'package:sila_app/features/notifications/data/repositories/isar_notification_repository.dart';
import 'package:sila_app/features/notifications/data/notification_ids.dart';
import 'package:sila_app/features/ibadah_tracker/presentation/pages/daily_report_page.dart';
import 'package:sila_app/features/notifications/presentation/pages/notification_detail_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/prayers_page.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  final payload = response.payload;
  if (payload == null || payload.trim().isEmpty) return;
  // Persist only; UI navigation is resumed on app foreground.
  NotificationService().saveDeferredPayload(payload.trim());
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();
  GlobalKey<NavigatorState>? _navigatorKey;
  String? _deferredPayload;

  static const int _adhanPlaybackNotificationId = 9090;
  static const String _stopAdhanActionId = 'stop_adhan';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

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

      final launchDetails =
          await _notifications.getNotificationAppLaunchDetails();
      final launchPayload = launchDetails?.notificationResponse?.payload;
      if (launchPayload != null && launchPayload.trim().isNotEmpty) {
        handleNotificationPayload(launchPayload);
      }

      await FirebaseMessaging.instance.requestPermission();

      await requestPermissions();

      try {
        await FirebaseMessaging.instance.subscribeToTopic('all_users');
        await FirebaseMessaging.instance.subscribeToTopic('updates');
      } catch (e) {
        debugPrint('FCM topic subscription failed: $e');
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.data['type'] == 'update') {
          _showUpdateNotification(message);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.data['type'] == 'update') {
          _showUpdateNotification(message);
        }
      });

      await _createNotificationChannel();
      _initialized = true;
      debugPrint('NotificationService: Initialized');
    } catch (e) {
      debugPrint('NotificationService initialization error: $e');
      _initialized = true;
    }
  }

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    if (_deferredPayload != null) {
      final payload = _deferredPayload!;
      _deferredPayload = null;
      Future<void>.microtask(() => handleNotificationPayload(payload));
    }
  }

  void saveDeferredPayload(String payload) {
    _deferredPayload = payload;
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'adhan_channel',
      'أذان الصلاة',
      description: 'إشعارات أذان الصلاة',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<bool> requestPermissions() async {
    if (await Permission.notification.isDenied ||
        await Permission.notification.isRestricted) {
      await Permission.notification.request();
    }

    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }

    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  Future<void> scheduleNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
    String? soundFile,
  }) async {
    if (!_initialized) await initialize();

    final prayerNameArabic = _getPrayerNameArabic(prayerName);

    // prayerTime is already a local DateTime — convert to TZDateTime using local tz
    final scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);

    final soundName = soundFile?.split('.').first;

    final androidDetails = AndroidNotificationDetails(
      'adhan_channel',
      'أذان الصلاة',
      channelDescription: 'إشعارات أذان الصلاة',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: soundName != null
          ? RawResourceAndroidNotificationSound(soundName)
          : null,
      enableVibration: true,
      enableLights: true,
      color: const Color(0xFF43A047),
      icon: '@drawable/ic_notification',
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: soundFile,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        'حان وقت صلاة $prayerNameArabic',
        'الله أكبر، الله أكبر',
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: prayerName,
      );
      print('Scheduled notification for $prayerName at $prayerTime (local)');
    } catch (e) {
      try {
        await _notifications.zonedSchedule(
          id,
          'حان وقت صلاة $prayerNameArabic',
          'الله أكبر، الله أكبر',
          scheduledTime,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: prayerName,
        );
      } catch (_) {
        print('Error scheduling notification for $prayerName: $e');
      }
    }
  }

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    if (!_initialized) await initialize();

    final scheduledTime = tz.TZDateTime.from(dateTime, tz.local);

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
  }

  Future<void> scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
  }) async {
    if (!_initialized) await initialize();
    final scheduledTime = tz.TZDateTime.from(dateTime, tz.local);

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
          id: 2000 + setting.id,
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
      dateTime: await at(6, 0),
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
      await _audioPlayer.play(AssetSource('audio/$soundFile'));
      await _showAdhanPlaybackNotification();
      print('Playing Adhan: $soundFile');
    } catch (e) {
      print('Error playing $soundFile, trying fallback: $e');
      // Try any available audio file as fallback
      try {
        await _audioPlayer.setReleaseMode(ReleaseMode.stop);
        await _audioPlayer.play(AssetSource('audio/adhan_mecca.mp3'));
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

  Future<void> scheduleDebugNotificationInSeconds({int seconds = 15}) async {
    if (!_initialized) await initialize();
    final now = DateTime.now();
    final at = now.add(Duration(seconds: seconds));
    await showInstantNotification(
      id: 9900,
      title: 'اختبار فوري',
      body: 'إذا ظهر هذا فورًا فالصلاحية الأساسية تعمل.',
      payload: jsonEncode({'route': 'debug_notification_now'}),
    );
    await scheduleOneShot(
      id: 9901,
      title: 'اختبار الإشعارات ✅',
      body: 'إذا ظهر هذا الإشعار فالنظام يعمل بشكل صحيح.',
      dateTime: at,
      payload: jsonEncode({'route': 'debug_notification'}),
    );
  }

  void _onNotificationTap(NotificationResponse response) async {
    if (response.actionId == _stopAdhanActionId ||
        response.payload == _stopAdhanActionId) {
      await stopAdhan();
      return;
    }

    handleNotificationPayload(response.payload);
  }

  Future<void> handleNotificationPayload(String? payload) async {
    if (payload == null || payload.trim().isEmpty) return;

    final normalized = payload.trim();
    final adhanPayloads = {'fajr', 'dhuhr', 'asr', 'maghrib', 'isha'};
    if (adhanPayloads.contains(normalized.toLowerCase())) {
      final prefs = PrefsService();
      final sound = await prefs.getAdhanSound();
      await playAdhan(sound);
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

  Future<void> _showUpdateNotification(RemoteMessage message) async {
    final context = _navigatorKey?.currentContext;
    if (context == null) return;

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
      title: message.notification?.title ?? 'تحديث جديد متاح',
      message: message.notification?.body ?? 'يوجد إصدار جديد من التطبيق',
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
    );
  }
}
