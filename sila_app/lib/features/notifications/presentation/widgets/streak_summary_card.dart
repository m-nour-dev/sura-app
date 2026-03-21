import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/features/notifications/presentation/controllers/notification_providers.dart';

class StreakSummaryCard extends ConsumerWidget {
  const StreakSummaryCard({super.key});

  static const _keys = ['azkar', 'wird', 'hifz', 'tasmi', 'tasbih'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(streakSummaryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? const Color(0xFF111827) : Colors.white;
    final border = isDark ? const Color(0xFF243041) : const Color(0xFFE2E8F0);
    final titleColor =
        isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final data = summaryAsync.valueOrNull ?? <String, int>{};
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'متابعة يومية',
            style: GoogleFonts.getFont(
              'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'استمرارية العادات التعبدية لهذا الأسبوع',
            style: GoogleFonts.getFont('Cairo',
                fontSize: 11, color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _keys
                .map(
                  (k) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0B1220)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Text(
                      '${_name(k)} • ${data[k] ?? 0} يوم',
                      style: GoogleFonts.getFont(
                        'Cairo',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }

  static String _name(String key) {
    switch (key) {
      case 'azkar':
        return 'الأذكار';
      case 'wird':
        return 'الورد';
      case 'hifz':
        return 'الحفظ';
      case 'tasmi':
        return 'التسميع';
      case 'tasbih':
        return 'التسبيح';
      default:
        return key;
    }
  }
}
