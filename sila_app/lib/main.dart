import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/core/presentation/main_layout.dart';
import 'package:sila_app/core/services/notification_service.dart';
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/core/services/timezone_service.dart';
import 'package:sila_app/core/services/adhan_scheduler_service.dart';
import 'package:sila_app/features/prayers/data/repositories/prayer_repository_impl.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    final text = details.exceptionAsString();
    if (text.contains('MdbxError (11)')) {
      debugPrint('Ignored transient Isar lock: $text');
      return;
    }
    FlutterError.presentError(details);
  };
  await EasyLocalization.ensureInitialized();

  // Initialize timezone service for prayer time calculations
  final timezoneService = TimezoneService();
  await timezoneService.initialize();

  await Firebase.initializeApp();

  NotificationService().setNavigatorKey(appNavigatorKey);
  final notificationService = NotificationService();
  try {
    await notificationService.initialize();
    
    // FIX 5: Schedule adhan notifications
    try {
      final prayerRepo = PrayerRepositoryImpl();
      final prayerTimes = await prayerRepo.getPrayerTimes();
      final adhanScheduler = AdhanSchedulerService();
      await adhanScheduler.scheduleAllPrayers(prayerTimes);
      debugPrint('✅ Adhan and Smart Reminders scheduled');
    } catch (e) {
      debugPrint('❌ Scheduling failed: $e');
    }

  } catch (error) {
    debugPrint('NotificationService init failed: $error');
  }

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('ar', 'SA'),
          Locale('tr', 'TR'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar', 'SA'),
        startLocale: const Locale('ar', 'SA'),
        child: const SilaApp(),
      ),
    ),
  );
}

class SilaApp extends StatelessWidget {
  const SilaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      title: 'Sıla',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainLayout(),
    );
  }
}
