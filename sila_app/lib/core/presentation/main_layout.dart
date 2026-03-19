import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final hifzDoneAsync = ref.watch(hifzOnboardingDoneProvider);

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
