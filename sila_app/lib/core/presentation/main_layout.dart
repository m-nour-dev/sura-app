import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/azkar/presentation/pages/azkar_page.dart';
import 'package:sila_app/features/home/presentation/pages/home_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/prayers_page.dart';
import 'package:sila_app/features/quran/presentation/pages/quran_page.dart';

import 'package:sila_app/features/vefa/presentation/pages/vefa_page.dart';

// State provider for Bottom Navigation Index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final pages = [
      const HomePage(),
      const QuranPage(),
      const AzkarPage(),
      const PrayersPage(),
      const VefaPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book_rounded),
            label: 'quran'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.volunteer_activism_outlined),
            selectedIcon: const Icon(Icons.volunteer_activism_rounded),
            label: 'azkar'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.access_time_outlined),
            selectedIcon: const Icon(Icons.access_time_filled_rounded),
            label: 'prayers'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.diversity_1_outlined),
            selectedIcon: const Icon(Icons.diversity_1_rounded),
            label: 'vefa_system'.tr(),
          ),
        ],
      ),
    );
  }
}
