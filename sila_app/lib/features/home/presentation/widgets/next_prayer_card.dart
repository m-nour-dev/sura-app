import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/prayers/presentation/riverpod/prayer_controller.dart';
import 'package:intl/intl.dart';
import 'package:sila_app/features/prayers/presentation/pages/qiblah_page.dart';  // Added Import

import 'package:sila_app/features/prayers/presentation/pages/prayer_settings_page.dart';

class NextPrayerCard extends ConsumerStatefulWidget {
  const NextPrayerCard({super.key});

  @override
  ConsumerState<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends ConsumerState<NextPrayerCard> {
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timesAsync = ref.watch(prayerTimesControllerProvider);

    return timesAsync.when(
      data: (timesEntity) {
        // Calculate Next Prayer Manually
        final now = DateTime.now();
        
        final prayers = [
          (key: 'fajr', time: timesEntity.fajr),
          (key: 'sunrise', time: timesEntity.sunrise),
          (key: 'dhuhr', time: timesEntity.dhuhr),
          (key: 'asr', time: timesEntity.asr),
          (key: 'maghrib', time: timesEntity.maghrib),
          (key: 'isha', time: timesEntity.isha),
        ];

        String nextPrayerKey = 'fajr';
        DateTime? nextPrayerTime;

        for (final p in prayers) {
          if (p.time.isAfter(now)) {
             nextPrayerTime = p.time;
             nextPrayerKey = p.key;
             break;
          }
        }

        // Check if next is Fajr tomorrow
        if (nextPrayerTime == null) {
           nextPrayerTime = timesEntity.fajr.add(const Duration(days: 1));
           nextPrayerKey = 'fajr';
        }
        
        _timeLeft = nextPrayerTime.difference(now);
        
        // Sanity check: If time left is > 24 hours or negative (shouldn't be negative due to checks)
        // This implies we are comparing against a wrong day.
        // For visual safety, we cap it or just show "--"
        if (_timeLeft.inHours > 24) {
           // Fallback/Error state
           _timeLeft = Duration.zero; 
        }

        final nextPrayerName = nextPrayerKey.tr(); // Using .tr() on the key
        final dateNow = DateTime.now();
        final dateFormat = DateFormat('EEEE, d MMMM y', context.locale.toString());
        
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF43A047), Color(0xFF2E7D32)], // Vibrant Green
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Settings - Location - Qibla
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Settings (Left in LTR, Right in RTL) -> In Arabic it will be Right. 
                    // Let's behave naturally.
                    IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white70, size: 20),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PrayerSettingsPage()));
                      },
                    ),

                    // Location (Center ish)
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          timesEntity.locationName ?? 'location_mock'.tr(),
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    
                    // Qibla Shortcut
                    // Qibla Shortcut
                    IconButton(
                      icon: const Icon(Icons.explore, color: Colors.white70, size: 20),
                      onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (_) => QiblahPage())); 
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 10),
                
                // "Time Remaining for X" Text
                Text(
                  '${'remaining_time'.tr()} - $nextPrayerName',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // BIG COUNTDOWN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    _buildTimeUnit(_timeLeft.inHours.toString().padLeft(2, '0')),
                    _buildTimeSeparator(),
                    _buildTimeUnit(_timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0')),
                    _buildTimeSeparator(),
                    _buildTimeUnit(_timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0'), isSeconds: true),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Footer: Date
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white70, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        dateFormat.format(dateNow),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => _buildLoadingCard(),
      error: (e, s) => _buildErrorCard(e.toString()),
    );
  }

  Widget _buildTimeUnit(String value, {bool isSeconds = false}) {
    return Text(
      value,
      style: TextStyle(
        color: Colors.white,
        fontSize: isSeconds ? 36 : 56, 
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  }

  Widget _buildTimeSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'Error: $error',
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _getPrayerName(Prayer? prayer) {
    if (prayer == null) return "---";
    switch (prayer) {
      case Prayer.fajr: return 'fajr'.tr();
      case Prayer.sunrise: return 'sunrise'.tr();
      case Prayer.dhuhr: return 'dhuhr'.tr();
      case Prayer.asr: return 'asr'.tr();
      case Prayer.maghrib: return 'maghrib'.tr();
      case Prayer.isha: return 'isha'.tr();
      case Prayer.none: return 'esha'.tr();
      default: return '';
    }
  }
}
