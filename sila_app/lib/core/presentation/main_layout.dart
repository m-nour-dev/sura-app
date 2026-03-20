import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/core/presentation/widgets/update_dialog.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/core/services/remote_config_service.dart';
import 'package:sila_app/core/services/update_service.dart';
import 'package:sila_app/features/azkar/presentation/pages/azkar_page.dart';
import 'package:sila_app/features/hifz/presentation/pages/hifz_home_page.dart';
import 'package:sila_app/features/hifz/presentation/pages/hifz_onboarding_page.dart';
import 'package:sila_app/features/home/presentation/pages/home_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/prayers_page.dart';
import 'package:sila_app/features/quran/presentation/pages/quran_page.dart';

import 'package:sila_app/features/vefa/presentation/pages/vefa_page.dart';
import 'widgets/sila_bottom_bar.dart';

// State provider for Bottom Navigation Index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
final hifzOnboardingDoneProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hifz_onboarding_done') ?? false;
});

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int? _lastLoggedIndex;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
      _logCurrentScreen();
    });
  }

  Future<void> _checkForUpdate() async {
    final remoteConfig = ref.read(remoteConfigServiceProvider);
    final analytics = ref.read(analyticsServiceProvider);

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = int.tryParse(packageInfo.buildNumber) ?? 1;

    await analytics.setUserProperties(appVersion: packageInfo.version);

    final result = await remoteConfig.checkForUpdate(currentVersion);
    if (!result.hasUpdate || !mounted) return;

    await analytics.logUpdateDialogShown(newVersion: result.latestVersion);

    showDialog<void>(
      context: context,
      barrierDismissible: !result.isForced,
      builder: (_) => UpdateDialog(
        updateResult: result,
        updateService: ref.read(updateServiceProvider),
        analyticsService: analytics,
      ),
    );
  }

  Future<void> _logCurrentScreen() async {
    final currentIndex = ref.read(bottomNavIndexProvider);
    if (_lastLoggedIndex == currentIndex) return;
    _lastLoggedIndex = currentIndex;

    final analytics = ref.read(analyticsServiceProvider);
    switch (currentIndex) {
      case 0:
        await analytics.logScreenHome();
        break;
      case 1:
        await analytics.logScreenQuran();
        break;
      case 2:
        await analytics.logScreenHifz();
        break;
      case 3:
        await analytics.logScreenPrayers();
        break;
      case 4:
        await analytics.logScreenAzkar();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final hifzDoneAsync = ref.watch(hifzOnboardingDoneProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logCurrentScreen();
    });

    final hifzPage = hifzDoneAsync.when(
      data: (done) {
        if (done) {
          return const HifzHomePage();
        }
        return HifzOnboardingPage(
          onCompleted: () => ref.invalidate(hifzOnboardingDoneProvider),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => HifzOnboardingPage(
        onCompleted: () => ref.invalidate(hifzOnboardingDoneProvider),
      ),
    );

    // Prompt mapping:
    // 0: الرئيسية (Home)
    // 1: القرآن (Quran)
    // 2: الحفظ (Hifz)
    // 3: الصلاة (Prayers)
    // 4: الأذكار (Azkar)
    final pages = [
      const HomePage(),
      const QuranPage(),
      hifzPage,
      const PrayersPage(),
      const AzkarPage(),
      const VefaPage(), // For any navigation mapping without bottom bar representation, just safe append
    ];

    // Safety check in case the index is somehow out of bounds.
    final displayIndex = currentIndex < pages.length ? currentIndex : 0;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: displayIndex,
          children: pages,
        ),
        bottomNavigationBar: SilaBottomBar(currentIndex: displayIndex),
      ),
    );
  }
}
