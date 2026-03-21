import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/features/home/presentation/widgets/daily_content_card.dart';
import 'package:sila_app/features/home/presentation/widgets/home_header.dart';
import 'package:sila_app/features/home/presentation/widgets/next_prayer_card.dart';
import 'package:sila_app/features/home/presentation/widgets/last_read_card.dart';
import 'package:sila_app/features/hifz/presentation/pages/hifz_home_page.dart';
import 'package:sila_app/features/hifz/presentation/pages/hifz_onboarding_page.dart';
import 'package:sila_app/features/notifications/presentation/pages/notification_hub_page.dart';
import 'package:sila_app/features/notifications/presentation/widgets/streak_summary_card.dart';
import 'package:sila_app/features/wird/presentation/widgets/wird_card.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const _onboardingDoneKey = 'hifz_onboarding_done';

  Future<void> _openHifz(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool(_onboardingDoneKey) ?? false;

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => done ? const HifzHomePage() : const HifzOnboardingPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFFDFBF7);

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar — Header ──
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF064E3B),
            flexibleSpace: FlexibleSpaceBar(
              background: HomeHeader(
                onNotificationTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationHubPage()),
                  );
                },
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Next Prayer Card ──
                const NextPrayerCard(),

                const SizedBox(height: 12),

                // ── Last Read Card ──
                const LastReadCard(),

                const SizedBox(height: 12),

                // ── Wird Card ──
                const WirdCard(),

                const SizedBox(height: 12),

                // ── Hifz Shortcut Card ──
                GestureDetector(
                  onTap: () => _openHifz(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF064E3B), Color(0xFFD97706)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD97706).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.auto_stories, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'حفظ',
                                style: GoogleFonts.getFont(
                                  'Amiri',
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'ابدأ أو أكمل رحلتك مع القرآن',
                                style: GoogleFonts.getFont(
                                  'Cairo',
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Daily Content Card ──
                const DailyContentCard(),

                const SizedBox(height: 12),

                // ── Streak Summary ──
                const StreakSummaryCard(),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
