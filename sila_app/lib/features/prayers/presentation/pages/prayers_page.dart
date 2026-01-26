import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/home/presentation/widgets/next_prayer_card.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';
import 'package:sila_app/features/prayers/presentation/pages/prayer_settings_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/qiblah_page.dart';

class PrayersPage extends ConsumerWidget {
  const PrayersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerState = ref.watch(prayerTimesControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header showing Title and Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Qiblah Button
                  IconButton(
                    icon: const Icon(Icons.explore_outlined, color: Colors.black87),
                    tooltip: 'اتجاه القبلة',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblahPage()));
                    },
                  ),
                  
                  Text(
                    'prayers'.tr(), 
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  
                  // Settings Button
                   IconButton(
                    icon: const Icon(Icons.tune, color: Colors.black87),
                    tooltip: 'الإعدادات',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PrayerSettingsPage()));
                    },
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: prayerState.when(
                data: (times) {
                  final prayers = [
                    {"name": "fajr", "time": times.fajr, "icon": Icons.wb_twilight},
                    {"name": "sunrise", "time": times.sunrise, "icon": Icons.wb_sunny},
                    {"name": "dhuhr", "time": times.dhuhr, "icon": Icons.wb_sunny_outlined},
                    {"name": "asr", "time": times.asr, "icon": Icons.wb_incandescent_outlined},
                    {"name": "maghrib", "time": times.maghrib, "icon": Icons.wb_twilight},
                    {"name": "isha", "time": times.isha, "icon": Icons.nights_stay_outlined},
                    // Add Last Third / Midnight purely for info? Maybe later.
                  ];

                  // Identify Current/Next Prayer for highlighting
                  // We can do this simply by comparing times
                  final now = DateTime.now();
                  int nextIndex = 0;
                  // Simple logic to find next
                  for (int i = 0; i < prayers.length; i++) {
                     final time = prayers[i]['time'] as DateTime;
                     if (time.isAfter(now)) {
                       nextIndex = i;
                       break;
                     } 
                     // If all passed, next is Fajr (index 0) tomorrow. 
                  }
                  if (now.isAfter((prayers.last['time'] as DateTime))) {
                    nextIndex = 0; 
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Next Prayer Card (Reused for consistency)
                        const NextPrayerCard(),
                        
                        const SizedBox(height: 24),
                        
                        // Prayer List
                        ...List.generate(prayers.length, (index) {
                            final prayer = prayers[index];
                            final isNext = index == nextIndex;
                            final time = prayer['time'] as DateTime;
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                color: isNext ? const Color(0xFFE8F5E9) : Colors.grey[50], // Light green highlight
                                borderRadius: BorderRadius.circular(16),
                                border: isNext ? Border.all(color: const Color(0xFF43A047), width: 1) : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    prayer['icon'] as IconData,
                                    color: isNext ? const Color(0xFF2E7D32) : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    (prayer['name'] as String).tr(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                                      color: isNext ? Colors.black87 : Colors.black54,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    DateFormat.jm().format(time),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                                      color: isNext ? Colors.black87 : Colors.black54,
                                    ),
                                  ),
                                  if (isNext) ...[
                                     const SizedBox(width: 8),
                                     const Icon(Icons.notifications_active, color: Color(0xFF43A047), size: 16),
                                  ]
                                ],
                              ),
                            );
                        }),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
                error: (e, st) => Center(child: Text('Error: $e')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
