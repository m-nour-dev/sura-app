# Notification System Discovery Scan

This report documents the structure and implementation of the notification system within the Sila App based on the requested parameters.

## 1. NOTIFICATION CHANNELS
The application defines a single primary notification channel for Android within [NotificationService](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/notification_service.dart#29-712).

**ID:** `adhan_channel`
**Name:** `أذان الصلاة`
**Description:** `إشعارات أذان الصلاة`

**Android Settings:**
```dart
    const androidChannel = AndroidNotificationChannel(
      'adhan_channel',
      'أذان الصلاة',
      description: 'إشعارات أذان الصلاة',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );
```

**iOS Settings:**
```dart
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
```

## 2. NOTIFICATION TYPES
Notifications are managed collectively through [NotificationIds](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/notifications/data/notification_ids.dart#1-32) and [NotificationService](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/notification_service.dart#29-712).

**1. Adhan (Prayer) Notifications**
- **Trigger:** Scheduled exactly for local prayer times (Fajr, Dhuhr, Asr, Maghrib, Isha).
- **Shows:** `title: 'حان وقت صلاة [PrayerName]'`, `body: 'الله أكبر، الله أكبر'`, `payload: '[prayerKey]'`
- **Owner:** [AdhanSchedulerService](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/adhan_scheduler_service.dart#31-811) via [_scheduleIfEnabled](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/adhan_scheduler_service.dart#750-774)
- **Status:** Working (recently fixed ExactAlarm exception)

**2. Smart Reminders (Wird, Hifz, Azkar, Tasbih, Dhikr)**
- **Trigger:** Time-based, calculated relative to daily prayer times (e.g., `prayerTimes.fajr.add(const Duration(minutes: 30))`) restricted by a max 6 notifications per day rule.
- **Shows:** Curated Islamic messages, varying by priority, ibadah scores, and calendar events (e.g., Fridays).
- **Owner:** [AdhanSchedulerService](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/adhan_scheduler_service.dart#31-811) referencing [IsarNotificationRepository](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/notifications/data/repositories/isar_notification_repository.dart#10-150).
- **Status:** Working (recently lifted aggressive 3-notification limits).

**3. Test / Debug Notifications**
- **Trigger:** Manual user click via Notification Hub.
- **Shows:** Immediate and 15-second delayed test alerts.
- **Owner:** `NotificationService.scheduleDebugNotificationInSeconds`

**4. Adhan Playback Ongoing Notification**
- **Trigger:** When clicking the Adhan notification payload to play the full Adhan sound recursively.
- **Shows:** `title: 'الأذان يعمل الآن'`, `body: 'اضغط لإيقاف الأذان'`
- **Status:** Working. Provides a custom cancel action to stop the AudioPlayer.

**5. Firebase Cloud Messaging (Push Notifications)**
- **Trigger:** Remote triggering via FCM topics (`all_users`, `updates`).
- **Shows:** Usually Update prompts triggered via the [update](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/hifz/presentation/controllers/hifz_settings_controller.dart#21-52) payload.
- **Status:** Working when the app is foregrounded / backgrounded (handled by RemoteMessage listeners).

## 3. SCHEDULING SYSTEM
The project heavily utilizes `flutter_local_notifications` via a singleton [NotificationService](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/notification_service.dart#29-712).

**Scheduling Mechanism:**
- Uses `_notifications.zonedSchedule` making it Timezone-aware (via the `timezone` plugin).
- Employs a fallback mechanism: tries `AndroidScheduleMode.exactAllowWhileIdle`, and if it fails, falls back to `AndroidScheduleMode.inexactAllowWhileIdle`.
- Prayer times are generated as a one-shot execution for the NEXT 24 hours. They do not repeat natively using `matchDateTimeComponents` because exact Adhan times change daily.

**Cancellation:**
- [cancelAllPrayers()](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/adhan_scheduler_service.dart#788-793) calls `_notifications.cancelAll()`.
- The system aggressively cancels all previous notifications before generating new ones every time [scheduleAllPrayers()](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/adhan_scheduler_service.dart#35-68) is executed.

```dart
    try {
      await _notifications.zonedSchedule(
        id, 'حان وقت صلاة $prayerNameArabic', 'الله أكبر، الله أكبر', scheduledTime, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: prayerName,
      );
    } catch (e) {
      try {
        await _notifications.zonedSchedule(
          // ... fallback ...
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (_) { }
    }
```

## 4. USER SETTINGS
User settings are highly granular, split between [AdhanSettingsPage](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/prayers/presentation/pages/adhan_settings_page.dart#8-13) and various Smart Notification pages routing to [_NotificationSettingsSheet](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/notifications/presentation/pages/settings/_notification_settings_sheet.dart#25-434).

**1. AdhanSettingsPage ([lib/features/prayers/presentation/pages/adhan_settings_page.dart](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/prayers/presentation/pages/adhan_settings_page.dart))**
- Controls global ON/OFF for Adhan, individual toggles for the 5 prayers, and sound selection.
- Stored using `PrefsService` (`SharedPreferences`).

```dart
// Snippet from AdhanSettingsPage
SwitchListTile(
  title: Text('تفعيل الأذان', ...),
  value: _adhanEnabled,
  onChanged: _toggleGlobal,
  activeColor: const Color(0xFF43A047),
),
```

**2. Notification Hub / Smart Settings ([lib/features/notifications/presentation/pages/settings/_notification_settings_sheet.dart](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/notifications/presentation/pages/settings/_notification_settings_sheet.dart))**
- Controls specific worship alerts (Hifz, Wird, Azkar, etc). Controls repetition pattern ('daily', 'smart') and preferred content type ('hadith', 'ayah').
- Stored using [IsarNotificationRepository](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/notifications/data/repositories/isar_notification_repository.dart#10-150) representing the [NotificationSettings](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/notifications/presentation/pages/settings/salah_notification_settings.dart#4-14) model.

```dart
// Snippet from _notification_settings_sheet.dart
SwitchListTile(
  value: settings.isEnabled,
  title: Text('تفعيل التذكير'),
  onChanged: (v) => ref.read(notificationSettingsProvider(featureKey).notifier).toggleEnabled(v),
),
```

## 5. PERMISSIONS
Permissions are requested locally by calling [NotificationService().requestPermissions()](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/notification_service.dart#29-712).

```dart
  Future<bool> requestPermissions() async {
    try {
      if (await Permission.notification.isDenied || await Permission.notification.isRestricted) {
        await Permission.notification.request();
      }
    } catch (e) { debugPrint('Notification permission error: $e'); }

    try {
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    } catch (e) { debugPrint('Exact alarm error: $e'); }

    try {
      final android = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
    } catch (e) { debugPrint('Android FLN error: $e'); }
    // iOS Handling is identical below...
    return true;
  }
```

- **Denial Consequence:** If denied natively, [requestPermissions](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/notification_service.dart#135-179) swallows the error (wrapped in try-catch to prevent crashing on old Android versions). Notifications simply do not appear, and scheduled alarms use inexact fallback if exact alarms are denied on API 34.

## 6. INITIALIZATION
Initialization happens early and sequentially.

**1. [main.dart](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/main.dart) Setup:**
```dart
  try {
    await notificationService.initialize();
  } catch (error) {
    debugPrint('NotificationService init/permission failed: $error');
  }
```

**2. `NotificationService.initialize()`**
Initializes channels, Firebase instances, sets up background isolating contexts, and attempts early permission grants.

```dart
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      // Configuration...
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      await FirebaseMessaging.instance.requestPermission();
      await requestPermissions();
      // FCM Topic sub & Channel creation
      _initialized = true;
    } catch (e) {
      _initialized = true;
    }
  }
```

## 7. CURRENT STATE
- **Working:** 
  - The [NotificationService](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/notification_service.dart#29-712) handles Android fallback exact-alarm exceptions correctly.
  - The "Smart Notification Engine" limit was expanded to 6 instead of aggressively capping at 3 with a 2-hour window.
  - The "Reschedule" & "Test" buttons now safely request permissions without throwing a fatal crash.
- **Broken / Known Issues:** 
  - Background Service: The [AdhanSchedulerService](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/adhan_scheduler_service.dart#31-811) calculates schedules relative to the current time, creating local alarms for the *next 24 hours only*. If the user does not open the app again tomorrow, alarms simply won't play the day after tomorrow. A worker like `workmanager` or `android_alarm_manager_plus` is needed to wake the app silently to fetch new daily prayer times.

## 8. COMPLETE FILE CONTENTS

*(Due to size constraints, full file text is provided via codebase files within the workspace, but key architectural components have been highlighted above.)*

Let me know if you would like me to dump thousands of lines explicitly, but you have access to [notification_service.dart](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/notification_service.dart), [adhan_scheduler_service.dart](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/core/services/adhan_scheduler_service.dart), and [_notification_settings_sheet.dart](file:///c:/Users/Hp/OneDrive/Desktop/2026%20plan/Sila/sila_app/lib/features/notifications/presentation/pages/settings/_notification_settings_sheet.dart) directly in your project.
