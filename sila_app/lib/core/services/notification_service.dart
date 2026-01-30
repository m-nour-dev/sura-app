import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:audioplayers/audioplayers.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _initialized = false;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize with callback for notification tap
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    await _createNotificationChannel();

    _initialized = true;
    print('NotificationService: Initialized successfully');
  }

  /// Create high-priority notification channel for Adhan
  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'adhan_channel', // id
      'أذان الصلاة', // title
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

  /// Request notification permissions (Android 13+)
  Future<bool> requestPermissions() async {
    final androidImplementation =  _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosImplementation = _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    
    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true; // Default to true for other platforms
  }

  /// Schedule notification for specific prayer time
  Future<void> scheduleNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
    String? soundFile,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    final prayerNameArabic = _getPrayerNameArabic(prayerName);

    // Convert to TZDateTime for accurate scheduling
    final scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'adhan_channel',
      'أذان الصلاة',
      channelDescription: 'إشعارات أذان الصلاة',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan_notification'),
      enableVibration: true,
      enableLights: true,
      color: Color(0xFF43A047), // Green color
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adhan_notification.mp3',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

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

    print('Scheduled notification for $prayerName at $prayerTime');
  }

  /// Play Adhan sound
  Future<void> playAdhan(String soundFile) async {
    try {
      await _audioPlayer.stop(); // Stop any currently playing sound
      await _audioPlayer.play(AssetSource('audio/$soundFile'));
      print('Playing Adhan: $soundFile');
    } catch (e) {
      print('Error playing Adhan: $e');
    }
  }

  /// Stop Adhan sound
  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    print('Cancelled notification with ID: $id');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('Cancelled all notifications');
  }

  /// Get all pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    print('Notification tapped: $payload');

    // Play Adhan when notification is tapped
    if (payload != null) {
      playAdhan('adhan_default.mp3'); // Can be customized based on user preference
    }
  }

  /// Get Arabic prayer name
  String _getPrayerNameArabic(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return 'الفجر';
      case 'dhuhr':
        return 'الظهر';
      case 'asr':
        return 'العصر';
      case 'maghrib':
        return 'المغرب';
      case 'isha':
        return 'العشاء';
      default:
        return prayerName;
    }
  }

  /// Get notification ID for prayer
  static int getNotificationId(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return 1;
      case 'dhuhr':
        return 2;
      case 'asr':
        return 3;
      case 'maghrib':
        return 4;
      case 'isha':
        return 5;
      default:
        return 0;
    }
  }
}
