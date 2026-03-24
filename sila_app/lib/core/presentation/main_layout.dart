import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/core/presentation/widgets/update_dialog.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/core/services/prefs_service.dart';
import 'package:sila_app/core/services/remote_config_service.dart';
import 'package:sila_app/core/services/update_service.dart';
import 'package:sila_app/core/services/notification_service.dart';
import 'package:sila_app/features/azkar/presentation/pages/azkar_page.dart';
import 'package:sila_app/features/hifz/presentation/pages/hifz_home_page.dart';
import 'package:sila_app/features/hifz/presentation/pages/hifz_onboarding_page.dart';
import 'package:sila_app/features/home/presentation/pages/home_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/prayers_page.dart';
import 'package:sila_app/features/quran/presentation/pages/quran_page.dart';

import 'package:sila_app/features/vefa/presentation/pages/vefa_page.dart';
import 'widgets/sila_bottom_bar.dart';
import 'widgets/language_switcher.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAndShowNotificationPrompt();
      _checkForUpdate();
      _logCurrentScreen();
    });
  }

  Future<void> _checkAndShowNotificationPrompt() async {
    final prefs = PrefsService();
    final neverShow = await prefs.getNeverShowNotificationPrompt();
    if (neverShow) return;

    if (await Permission.notification.isGranted) return;

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
       builder: (BuildContext dialogContext) {
         return AlertDialog(
           backgroundColor: const Color(0xFF0A0F1E),
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
           title: Text(
             'notification_permission_title'.tr(),
             style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
             textAlign: TextAlign.center,
           ),
           content: Text(
             'notification_permission_desc'.tr(),
             style: GoogleFonts.cairo(color: Colors.white70),
             textAlign: TextAlign.center,
           ),
           actionsAlignment: MainAxisAlignment.center,
           actionsOverflowAlignment: OverflowBarAlignment.center,
           actionsOverflowDirection: VerticalDirection.down,
           actions: [
             ElevatedButton(
               style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFF43A047),
                 foregroundColor: Colors.white,
                 minimumSize: const Size(double.infinity, 45),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               ),
               onPressed: () async {
                 Navigator.of(dialogContext).pop();
                 final granted =
                     await NotificationService().requestPermissions();
                 if (granted) {
                   if (!mounted) return;
                   _showMiuiSettingsGuide(context);
                 } else {
                   final status = await Permission.notification.status;
                   if (status.isPermanentlyDenied) {
                     if (!mounted) return;
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: Text('notification_permission_desc'.tr(),
                             style: GoogleFonts.cairo()),
                         action: SnackBarAction(
                           label: 'notification_settings_label'.tr(),
                           onPressed: () => openAppSettings(),
                         ),
                       ),
                     );
                   }
                 }
               },
               child: Text('agree_button'.tr(),
                   style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
             ),
             const SizedBox(height: 8),
             OutlinedButton(
               style: OutlinedButton.styleFrom(
                 foregroundColor: Colors.white,
                 side: BorderSide(color: Colors.white.withOpacity(0.2)),
                 minimumSize: const Size(double.infinity, 45),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               ),
               onPressed: () {
                 Navigator.of(dialogContext).pop();
               },
               child: Text('disagree_button'.tr(), style: GoogleFonts.cairo()),
             ),
             const SizedBox(height: 8),
             TextButton(
               style: TextButton.styleFrom(
                 foregroundColor: Colors.white54,
                 minimumSize: const Size(double.infinity, 45),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               ),
               onPressed: () async {
                 await prefs.setNeverShowNotificationPrompt(true);
                 if (!dialogContext.mounted) return;
                 Navigator.of(dialogContext).pop();
               },
               child: Text('never_show_again'.tr(), style: GoogleFonts.cairo(fontSize: 13)),
             ),
           ],
         );
       },
    );
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

    return Scaffold(
      body: IndexedStack(
        index: displayIndex,
        children: pages,
      ),
      bottomNavigationBar: SilaBottomBar(currentIndex: displayIndex),
    );
  }

  Future<void> _showMiuiSettingsGuide(BuildContext context) async {
    if (!Platform.isAndroid) return;

    final prefs = await SharedPreferences.getInstance();
    final alreadyShown = prefs.getBool('miui_guide_shown') ?? false;
    if (alreadyShown) return;

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
       builder: (context) => AlertDialog(
         backgroundColor: const Color(0xFF0A0F1E),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
         title: Text(
           'miui_warning_title'.tr(),
           style: GoogleFonts.cairo(
               color: Colors.white, fontWeight: FontWeight.bold),
           textAlign: TextAlign.center,
         ),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Text(
               'miui_warning_desc'.tr(),
               style: GoogleFonts.cairo(color: Colors.white70),
               textAlign: TextAlign.center,
             ),
             const SizedBox(height: 16),
             _buildGuideStep('1', 'miui_step1'.tr()),
             _buildGuideStep('2', 'miui_step2'.tr()),
             _buildGuideStep('3', 'miui_step3'.tr()),
           ],
         ),
         actions: [
           TextButton(
             onPressed: () async {
               await prefs.setBool('miui_guide_shown', true);
               if (!context.mounted) return;
               Navigator.pop(context);
             },
             child: Text('understood'.tr(),
                 style: GoogleFonts.cairo(color: const Color(0xFF43A047))),
           ),
         ],
       ),
    );
  }

  Widget _buildGuideStep(String num, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFF43A047),
            child: Text(num,
                style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: GoogleFonts.cairo(color: Colors.white60, fontSize: 13))),
        ],
      ),
    );
  }
}
