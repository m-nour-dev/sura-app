import 'dart:async';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/core/presentation/main_layout.dart';
import 'package:sila_app/core/presentation/splash_page.dart';
import 'package:sila_app/core/services/adhan_scheduler_service.dart';
import 'package:sila_app/core/services/notification_service.dart';
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/features/onboarding/presentation/pages/language_selection_page.dart';
import 'package:sila_app/features/prayers/data/repositories/prayer_repository_impl.dart';
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 1. Timezone — أول حاجة دايمًا
  tz.initializeTimeZones();

  // ✅ 2. Firebase
  await Firebase.initializeApp();
  

  // ✅ 4. NotificationService — لازم قبل runApp عشان الـ background handler
  await NotificationService().initialize();

  // ✅ Check if language was already selected
  final prefs = await SharedPreferences.getInstance();
  final isLanguageSelected = prefs.getBool('is_language_selected') ?? false;

  // ✅ 5. runApp
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('ar', 'SA'),
          Locale('tr', 'TR'),
          Locale('en', 'US'),
          Locale('fr', 'FR'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('ar', 'SA'),
        startLocale: const Locale('ar', 'SA'),
        child: SilaApp(isLanguageSelected: isLanguageSelected),
      ),
    ),
  );
}

Future<void> _initBackgroundServices() async {
  try {
    final prayerRepo = PrayerRepositoryImpl();
    final prayerTimes = await prayerRepo.getPrayerTimes();
    final adhanScheduler = AdhanSchedulerService();
    await adhanScheduler.scheduleAllPrayers(prayerTimes);

    debugPrint('✅ Background services initialized');
  } catch (e) {
    debugPrint('❌ Background init failed: $e');
  }
}

class SilaApp extends StatefulWidget {
  const SilaApp({super.key, required this.isLanguageSelected});
  final bool isLanguageSelected;

  @override
  State<SilaApp> createState() => _SilaAppState();
}

class _SilaAppState extends State<SilaApp> with WidgetsBindingObserver {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await NotificationService().setNavigatorKey(appNavigatorKey);
      } catch (e) {
        debugPrint('Failed to set notification navigator key: $e');
      }

      try {
        await _initBackgroundServices();
      } catch (e) {
        debugPrint('Background service bootstrap failed: $e');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      unawaited(NotificationService().dispose());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
      builder: (context, child) {
        return Directionality(
          textDirection: context.locale.languageCode == 'ar'
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          child: child!,
        );
      },
      home: _showSplash
          ? SplashPage(
              onComplete: () => setState(() => _showSplash = false),
            )
          : widget.isLanguageSelected
              ? const MainLayout()
              : const LanguageSelectionPage(),
    );
  }
}
