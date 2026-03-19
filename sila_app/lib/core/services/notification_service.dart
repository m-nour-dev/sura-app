import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:audioplayers/audioplayers.dart';
import 'package:sila_app/core/services/prefs_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
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
    );
    await _createNotificationChannel();
    _initialized = true;
    print('NotificationService: Initialized');
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
    final android = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _notifications
        .resolvePlatformSpecificImplementation<
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
      sound: soundName != null ? RawResourceAndroidNotificationSound(soundName) : null,
      enableVibration: true,
      enableLights: true,
      color: const Color(0xFF43A047),
      icon: '@mipmap/ic_launcher',
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
      print('Error scheduling notification for $prayerName: $e');
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

  /// Play Adhan sound directly in-app
  Future<void> playAdhan(String soundFile) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/$soundFile'));
      print('Playing Adhan: $soundFile');
    } catch (e) {
      print('Error playing $soundFile, trying fallback: $e');
      // Try any available audio file as fallback
      try {
        await _audioPlayer.play(AssetSource('audio/adhan_mecca.mp3'));
      } catch (e2) {
        print('Fallback audio also failed: $e2');
      }
    }
  }

  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
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

  void _onNotificationTap(NotificationResponse response) async {
    final prefs = PrefsService();
    final sound = await prefs.getAdhanSound();
    playAdhan(sound);
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
}
