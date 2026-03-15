import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:hijri/hijri_calendar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final hijriDate = HijriCalendar.now();

    return Container(
      width: double.infinity,
      // Research: generous padding (40% rule). Top 60 for status bar,
      // bottom 60 to allow WirdCard overlap.
      padding: const EdgeInsets.fromLTRB(28, 60, 28, 60),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top bar: Logo + Hijri date ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo cluster (icon + name)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E5641),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFECA638),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'صلة',
                    style: GoogleFonts.amiri(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFECA638),
                    ),
                  ),
                ],
              ),
              // Hijri date pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hijriDate.toFormat('dd MMMM yyyy'),
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          // Research: 40-48px vertical breathing room between sections
          const SizedBox(height: 40),

          // ── Greeting ──
          // Research: Arabic text needs 1.4-1.6 line-height, min 16px
          Text(
            'السلام عليكم ورحمة الله',
            style: GoogleFonts.amiri(
              fontSize: 18,
              height: 1.6,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أهلاً بك في وِردك اليومي',
            style: GoogleFonts.outfit(
              fontSize: 24,
              height: 1.4,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
