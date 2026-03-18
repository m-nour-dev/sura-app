import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sila_app/features/home/presentation/widgets/next_prayer_card.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';
import 'package:sila_app/features/prayers/presentation/pages/prayer_settings_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/qiblah_page.dart';

class PrayersPage extends ConsumerWidget {
  const PrayersPage({super.key});

  static const _prayerMeta = [
    {'key': 'fajr',    'icon': '🌄', 'grad': [Color(0xFF1A237E), Color(0xFF283593)]},
    {'key': 'sunrise', 'icon': '🌅', 'grad': [Color(0xFFE65100), Color(0xFFF57C00)]},
    {'key': 'dhuhr',   'icon': '☀️', 'grad': [Color(0xFF006064), Color(0xFF00838F)]},
    {'key': 'asr',     'icon': '🌤️', 'grad': [Color(0xFF1B5E20), Color(0xFF2E7D32)]},
    {'key': 'maghrib', 'icon': '🌇', 'grad': [Color(0xFF4A148C), Color(0xFF6A1B9A)]},
    {'key': 'isha',    'icon': '🌙', 'grad': [Color(0xFF212121), Color(0xFF37474F)]},
  ];

  String _methodName(String code) {
    const map = {
      'turkey': 'رئاسة الشؤون الدينية – تركيا',
      'egyptian': 'الهيئة المصرية العامة للمساحة',
      'umm_al_qura': 'جامعة أم القرى – مكة المكرمة',
      'morocco': 'وزارة الأوقاف المغربية',
      'indonesia': 'وزارة الشؤون الدينية – إندونيسيا',
      'karachi': 'جامعة العلوم الإسلامية – كراتشي',
      'north_america': 'ISNA – أمريكا الشمالية',
      'muslim_world_league': 'رابطة العالم الإسلامي',
      'dubai': 'الإمارات',
      'qatar': 'قطر',
      'kuwait': 'الكويت',
      'singapore': 'سنغافورة',
    };
    return map[code] ?? code;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerState = ref.watch(prayerTimesControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _headerBtn(
                    icon: Icons.explore_rounded,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const QiblahPage())),
                  ),
                  Text(
                    'prayers'.tr(),
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _headerBtn(
                    icon: Icons.tune_rounded,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const PrayerSettingsPage())),
                  ),
                ],
              ),
            ),

            // ── Content ──────────────────────────────────────────────────
            Expanded(
              child: prayerState.when(
                data: (entity) {
                  final now = DateTime.now();

                  final times = [
                    entity.fajr,
                    entity.sunrise,
                    entity.dhuhr,
                    entity.asr,
                    entity.maghrib,
                    entity.isha,
                  ];

                  // find next prayer index
                  int nextIdx = 0;
                  bool found = false;
                  for (int i = 0; i < times.length; i++) {
                    if (times[i].isAfter(now)) {
                      nextIdx = i;
                      found = true;
                      break;
                    }
                  }
                  if (!found) nextIdx = 0;

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      // Next Prayer Card
                      const NextPrayerCard(),

                      const SizedBox(height: 28),

                      // Section label
                      Text(
                        'مواقيت اليوم',
                        style: GoogleFonts.cairo(
                          color: Colors.white60,
                          fontSize: 13,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Prayer list
                      ...List.generate(_prayerMeta.length, (i) {
                        final meta = _prayerMeta[i];
                        final key = meta['key'] as String;
                        final icon = meta['icon'] as String;
                        final grads = meta['grad'] as List<Color>;
                        final time = times[i];
                        final isNext = i == nextIdx;
                        final isPast = time.isBefore(now) && !isNext;

                        return _PrayerTile(
                          key: ValueKey(key),
                          prayerKey: key,
                          emoji: icon,
                          time: time,
                          gradColors: grads,
                          isNext: isNext,
                          isPast: isPast,
                        );
                      }),

                      const SizedBox(height: 16),

                      // Method badge
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calculate_outlined,
                                  color: Colors.white38, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                _methodName(entity.calculationMethod),
                                style: GoogleFonts.cairo(
                                  color: Colors.white54,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  );
                },
                error: (e, _) => Center(
                  child: Text('Error: $e',
                      style: const TextStyle(color: Colors.white)),
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
    );
  }
}

// ── Prayer Tile ──────────────────────────────────────────────────────────────

class _PrayerTile extends StatelessWidget {
  final String prayerKey;
  final String emoji;
  final DateTime time;
  final List<Color> gradColors;
  final bool isNext;
  final bool isPast;

  const _PrayerTile({
    super.key,
    required this.prayerKey,
    required this.emoji,
    required this.time,
    required this.gradColors,
    required this.isNext,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat.jm().format(time);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: isNext
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  gradColors.first.withOpacity(0.9),
                  gradColors.last.withOpacity(0.7),
                ],
              )
            : null,
        color: isNext ? null : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: isNext
            ? Border.all(color: Colors.white.withOpacity(0.2), width: 1)
            : Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: gradColors.first.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ]
            : [],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            // Emoji icon in circle
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNext
                    ? Colors.white.withOpacity(0.15)
                    : Colors.white.withOpacity(0.07),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),

            const SizedBox(width: 14),

            // Prayer name
            Expanded(
              child: Text(
                prayerKey.tr(),
                style: GoogleFonts.cairo(
                  color: isPast
                      ? Colors.white30
                      : (isNext ? Colors.white : Colors.white70),
                  fontSize: 16,
                  fontWeight:
                      isNext ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),

            // Next pill badge
            if (isNext) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'التالية',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],

            // Time
            Text(
              timeStr,
              style: GoogleFonts.robotoMono(
                color: isPast
                    ? Colors.white24
                    : (isNext ? Colors.white : Colors.white60),
                fontSize: 15,
                fontWeight:
                    isNext ? FontWeight.w700 : FontWeight.w400,
              ),
            ),

            if (isNext) ...[
              const SizedBox(width: 6),
              const Icon(Icons.notifications_active_rounded,
                  color: Colors.white70, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
