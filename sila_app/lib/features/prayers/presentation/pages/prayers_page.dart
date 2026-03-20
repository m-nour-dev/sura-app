import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';
import 'package:sila_app/features/prayers/presentation/pages/prayer_settings_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/qiblah_page.dart';
import 'package:sila_app/core/presentation/widgets/sila_app_bar.dart';

class PrayersPage extends ConsumerStatefulWidget {
  const PrayersPage({super.key});

  @override
  ConsumerState<PrayersPage> createState() => _PrayersPageState();
}

class _PrayersPageState extends ConsumerState<PrayersPage> {
  Timer? _timer;
  bool _screenLogged = false;

  static const _prayerMeta = [
    {'key': 'fajr',    'icon': Icons.wb_twilight_rounded, 'name': 'الفجر'},
    {'key': 'sunrise', 'icon': Icons.wb_sunny_rounded,    'name': 'الشروق'},
    {'key': 'dhuhr',   'icon': Icons.sunny,               'name': 'الظهر'},
    {'key': 'asr',     'icon': Icons.wb_cloudy_rounded,   'name': 'العصر'},
    {'key': 'maghrib', 'icon': Icons.nights_stay_rounded, 'name': 'المغرب'},
    {'key': 'isha',    'icon': Icons.brightness_3_rounded,'name': 'العشاء'},
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_screenLogged) return;
      _screenLogged = true;
      ref.read(analyticsServiceProvider).logScreenPrayers();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final prayerState = ref.watch(prayerTimesControllerProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFFDFBF7);
    final surface = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? Colors.white12 : const Color(0xFFE2E8F0);
    final txtP = isDark ? Colors.white : const Color(0xFF0F172A);
    final txtS = isDark ? Colors.white60 : const Color(0xFF64748B);
    const primaryColor = Color(0xFF064E3B);
    const accentColor = Color(0xFFD97706);

    return Scaffold(
      backgroundColor: bg,
      body: prayerState.when(
        data: (entity) {
          final now = DateTime.now();

          final prayersList = [
            (key: 'fajr', time: entity.fajr),
            (key: 'sunrise', time: entity.sunrise),
            (key: 'dhuhr', time: entity.dhuhr),
            (key: 'asr', time: entity.asr),
            (key: 'maghrib', time: entity.maghrib),
            (key: 'isha', time: entity.isha),
          ];

          int nextIdx = 0;
          DateTime? nextTime;
          for (int i = 0; i < prayersList.length; i++) {
            if (prayersList[i].time.isAfter(now)) {
              nextTime = prayersList[i].time;
              nextIdx = i;
              break;
            }
          }
          nextTime ??= entity.fajr.add(const Duration(days: 1));

          Duration timeLeft = nextTime.difference(now);
          if (timeLeft.isNegative) timeLeft = Duration.zero;
          if (timeLeft.inHours > 24) timeLeft = Duration.zero;

          final hours = timeLeft.inHours.toString().padLeft(2, '0');
          final mins = timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0');
          final secs = timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');
          final remainingTime = '$hours:$mins:$secs';
          
          final nextPrayerName = _prayerMeta[nextIdx]['name'] as String;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                backgroundColor: primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF064E3B), Color(0xFF0a6b52), Color(0xFF1a3a5c)],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'مواقيت الصلاة',
                                      style: GoogleFonts.getFont(
                                        'Cairo',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      entity.locationName,
                                      style: GoogleFonts.getFont(
                                        'Cairo',
                                        fontSize: 13,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                                // Settings icon
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const PrayerSettingsPage()),
                                  ),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.settings_rounded,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Next Prayer Highlight
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    color: Color(0xFFFCD34D),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$nextPrayerName بعد $remainingTime',
                                    style: GoogleFonts.getFont(
                                      'Cairo',
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    ...List.generate(_prayerMeta.length, (i) {
                      final meta = _prayerMeta[i];
                      final name = meta['name'] as String;
                      final iconData = meta['icon'] as IconData;
                      final time = prayersList[i].time;
                      final isNext = i == nextIdx;
                      
                      final formattedTime = DateFormat('hh:mm a').format(time);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isNext ? primaryColor.withOpacity(0.08) : surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isNext ? primaryColor.withOpacity(0.3) : border,
                            width: isNext ? 1.5 : 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isNext ? primaryColor : primaryColor.withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    iconData,
                                    color: isNext ? Colors.white : primaryColor,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  name,
                                  style: GoogleFonts.getFont(
                                    'Cairo',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isNext ? primaryColor : txtP,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  formattedTime,
                                  style: GoogleFonts.getFont(
                                    'Cairo',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isNext ? primaryColor : txtP,
                                  ),
                                ),
                                if (isNext) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'التالية',
                                      style: GoogleFonts.getFont(
                                        'Cairo',
                                        fontSize: 9,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    // Qiblah Button
                    GestureDetector(
                      onTap: () {
                        ref.read(analyticsServiceProvider).logQiblahOpen();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QiblahPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: border, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.explore_rounded, color: primaryColor, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'اتجاه القبلة',
                                    style: GoogleFonts.getFont(
                                      'Cairo',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: txtP,
                                    ),
                                  ),
                                  Text(
                                    'حدد اتجاه القبلة من موقعك الحالي',
                                    style: GoogleFonts.getFont(
                                      'Cairo',
                                      fontSize: 12,
                                      color: txtS,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: txtS, size: 14),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          );
        },
        error: (e, _) => Center(
          child: Text('Error: $e', style: TextStyle(color: txtP)),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: primaryColor)),
      ),
    );
  }
}
