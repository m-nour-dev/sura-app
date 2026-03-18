import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';
import 'package:sila_app/features/prayers/presentation/pages/prayer_settings_page.dart';
import 'package:sila_app/features/prayers/presentation/pages/qiblah_page.dart';

class NextPrayerCard extends ConsumerStatefulWidget {
  const NextPrayerCard({super.key});

  @override
  ConsumerState<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends ConsumerState<NextPrayerCard>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final timesAsync = ref.watch(prayerTimesControllerProvider);

    return timesAsync.when(
      data: (entity) {
        // ── Find next prayer ──────────────────────────────────────────────
        final now = DateTime.now();
        final prayers = [
          (key: 'fajr', time: entity.fajr),
          (key: 'sunrise', time: entity.sunrise),
          (key: 'dhuhr', time: entity.dhuhr),
          (key: 'asr', time: entity.asr),
          (key: 'maghrib', time: entity.maghrib),
          (key: 'isha', time: entity.isha),
        ];

        String nextKey = 'fajr';
        DateTime? nextTime;
        for (final p in prayers) {
          if (p.time.isAfter(now)) {
            nextTime = p.time;
            nextKey = p.key;
            break;
          }
        }
        nextTime ??= entity.fajr.add(const Duration(days: 1));

        Duration timeLeft = nextTime.difference(now);
        // Safety: clamp to sane range
        if (timeLeft.isNegative) timeLeft = Duration.zero;
        if (timeLeft.inHours > 24) timeLeft = Duration.zero;

        final hours = timeLeft.inHours.toString().padLeft(2, '0');
        final mins = timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0');
        final secs = timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0');

        final nextPrayerName = nextKey.tr();
        final dateStr = DateFormat('EEEE، d MMMM y', 'ar').format(now);

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F172A), // very dark slate
                Color(0xFF1E1B4B), // deep indigo
                Color(0xFF312E81), // indigo
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF312E81).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.03),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.02),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top row: settings | location | qiblah
                    // Top row: location centered
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            entity.locationName,
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // "Time remaining for X"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeTransition(
                          opacity: _pulseAnim,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF818CF8), // light indigo
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${'remaining_time'.tr()} - $nextPrayerName',
                          style: GoogleFonts.cairo(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Big countdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        _timeUnit(hours),
                        _sep(),
                        _timeUnit(mins),
                        _sep(),
                        _timeUnit(secs, small: true),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Date row
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.1), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              color: Colors.white54, size: 13),
                          const SizedBox(width: 8),
                          Text(
                            dateStr,
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _loadingCard(),
      error: (e, _) => _errorCard(e.toString()),
    );
  }

  Widget _timeUnit(String v, {bool small = false}) {
    return Text(
      v,
      style: GoogleFonts.robotoMono(
        color: Colors.white,
        fontSize: small ? 32 : 52,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  }

  Widget _sep() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          ':',
          style: GoogleFonts.robotoMono(
            color: Colors.white.withOpacity(0.4),
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _loadingCard() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  Widget _errorCard(String error) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade900,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(error,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center),
      ),
    );
  }
}
