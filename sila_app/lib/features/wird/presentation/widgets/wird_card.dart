import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/quran.dart' as quran;
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/features/wird/presentation/pages/wird_reader_page.dart';
import 'package:sila_app/features/tasmi/presentation/pages/tasmi_surah_selection_page.dart';
import 'package:sila_app/features/wird/presentation/pages/wird_history_page.dart';
import 'package:sila_app/features/wird/presentation/riverpod/wird_controller.dart';
import 'package:sila_app/features/vefa/presentation/pages/vefa_page.dart';
import 'package:easy_localization/easy_localization.dart';

class WirdCard extends ConsumerWidget {
  const WirdCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wirdStateAsync = ref.watch(wirdControllerProvider);

    return wirdStateAsync.when(
      data: (state) {
        return Transform.translate(
          // Single overlap point: card floats 28px over the header
          offset: const Offset(0, -28),
          child: Column(
            children: [
              _buildMainWirdCard(context, ref, state),
              const SizedBox(height: 16),
              _buildActionButtons(context, ref, state),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
    );
  }

  // ─── Main Wird Card ───
  Widget _buildMainWirdCard(BuildContext context, WidgetRef ref, WirdState state) {
    final safeStartPage = state.currentPage.clamp(1, 604);
    final safeTargetPage = state.targetPage.clamp(1, 604);

    final pageData = quran.getPageData(safeStartPage);
    final surahNum = pageData.isNotEmpty ? pageData[0]['surah'] : 1;
    final startAyah = pageData.isNotEmpty ? pageData[0]['start'] : 1;
    final firstVerse = quran.getVerse(surahNum, startAyah);
    final juz = quran.getJuzNumber(surahNum, startAyah);

    final targetPageData = quran.getPageData(safeTargetPage);
    final targetSurahNum = targetPageData.isNotEmpty ? targetPageData[0]['surah'] : 1;
    final targetStartAyah = targetPageData.isNotEmpty ? targetPageData[0]['start'] : 1;

    return Container(
      width: double.infinity,
      // Research: generous internal padding (28px) for Arabic content
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header row: Juz label + "من قوله تعالى" ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'الجزء $juz',
                  style: GoogleFonts.outfit(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                'من قوله تعالى',
                style: GoogleFonts.amiri(
                  color: AppTheme.primaryColor.withOpacity(0.6),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ],
          ),

          // Research: 32-40px breathing room before Quranic text
          const SizedBox(height: 36),

          // ── Quranic Verse ──
          // Research: Amiri font, 26px min, line-height 1.8 for diacritics
          Text(
            firstVerse,
            textAlign: TextAlign.center,
            style: GoogleFonts.amiri(
              fontSize: 26,
              height: 1.8,
              color: AppTheme.primaryColor,
            ),
          ),

          const SizedBox(height: 36),

          // ── Divider ──
          Divider(
            color: Colors.grey.withOpacity(0.15),
            height: 1,
          ),

          const SizedBox(height: 20),

          // ── From: surah / page ──
          _buildInfoRow(
            'سورة ${quran.getSurahNameArabic(surahNum)} - آية $startAyah',
            'صفحة $safeStartPage',
            AppTheme.primaryColor.withOpacity(0.7),
          ),
          const SizedBox(height: 10),
          // ── To: surah / page ──
          _buildInfoRow(
            'إلى سورة ${quran.getSurahNameArabic(targetSurahNum)} - آية $targetStartAyah',
            'صفحة $safeTargetPage',
            AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  // ── Reusable info row ──
  Widget _buildInfoRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              height: 1.5,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ─── Action Buttons ───
  Widget _buildActionButtons(BuildContext context, WidgetRef ref, WirdState state) {
    final pageData = quran.getPageData(state.currentPage.clamp(1, 604));
    final surahNum = pageData.isNotEmpty ? pageData[0]['surah'] : 1;
    final startAyah = pageData.isNotEmpty ? pageData[0]['start'] : 1;

    final targetPageData = quran.getPageData(state.targetPage.clamp(1, 604));
    final targetSurahNum = targetPageData.isNotEmpty ? targetPageData[0]['surah'] : 1;
    // Note: This is a simplification. A proper implementation would need to get the exact end ayah.
    final endAyah = quran.getVerseCount(targetSurahNum);


    return Row(
      children: [
        // "I finished reading" (Gold)
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFECA638),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => _showCompletionDialog(context, ref, state),
              child: Text(
                'أتممت القراءة',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // "Tasmi3" (New Button)
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TasmiSurahSelectionPage(),
                  ),
                );
              },
              child: Text(
                'تسميع',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // "Continue reading" (Green)
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WirdReaderPage(
                      startPage: state.currentPage,
                      endPage: state.targetPage,
                    ),
                  ),
                );

                if (result == true) {
                   // User clicked finish in reader
                   if (context.mounted) {
                      _showCompletionDialog(context, ref, state);
                   }
                }
              },
              child: Text(
                'تابع القراءة',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Completion Dialog ───
  void _showCompletionDialog(BuildContext context, WidgetRef ref, WirdState state) {
    final isKhatmaComplete = state.targetPage >= 604;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isKhatmaComplete ? 'ختم القرآن الكريم 🎉' : 'إتمام الورد',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          isKhatmaComplete
              ? 'مبارك! لقد أتممت قراءة القرآن الكريم كاملاً.\nتقبل الله منك وجعل بكل حرف نوراً في قلبك وحياتك.\n\nهل تود البدء بختمة جديدة؟'
              : 'هل انتهيت من قراءة الورد المحدد لهذا اليوم؟\nسيتم تحديث تقدمك في الختمة.',
          style: GoogleFonts.outfit(fontSize: 15, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.outfit()),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (isKhatmaComplete) {
                ref.read(wirdControllerProvider.notifier).completeWird(state.currentPage, 604).then((_) {
                  ref.read(wirdControllerProvider.notifier).startNewKhatma();
                });
              } else {
                ref.read(wirdControllerProvider.notifier).completeWird(state.currentPage, state.targetPage);
              }
              Navigator.pop(context); // Close completion dialog
              
              if (context.mounted) {
                _showDedicateRewardDialog(context);
              }
            },
            child: Text(
              isKhatmaComplete ? 'بدء ختمة جديدة' : 'تم بحمد الله',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showDedicateRewardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'wird_completed_title'.tr(),
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'wird_completed_body'.tr(),
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(fontSize: 15),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('لاحقاً', style: GoogleFonts.outfit(color: Colors.grey)),
          ),
          const SizedBox(width: 8),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VefaPage(isSelectionMode: true),
                ),
              );
            },
            child: Text(
              'نعم، بالتأكيد',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
