import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/features/tasmi/presentation/controllers/tasmi_controller.dart';
import 'package:sila_app/features/tasmi/presentation/pages/tasmi_onboarding_page.dart';
import 'package:sila_app/features/tasmi/presentation/riverpod/tasmi_preferences_provider.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/mushaf_tasmi_view.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/tasmi_action_button.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/tasmi_correction_bubble.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/tasmi_listening_indicator.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/tasmi_page_header.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/tasmi_stats_row.dart';
import 'package:sila_app/features/vefa/presentation/pages/vefa_page.dart';

class TasmiPage extends ConsumerWidget {
  final int surahNumber;
  final int fromAya;
  final int toAya;

  const TasmiPage({
    super.key,
    required this.surahNumber,
    required this.fromAya,
    required this.toAya,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(tasmiPreferencesNotifierProvider);
    if (!prefs.isOnboardingDone) {
      return TasmiOnboardingPage(
        onDone: () {
          ref.read(tasmiControllerProvider.notifier).startSession(
                surahNumber: surahNumber,
                fromAya: fromAya,
                toAya: toAya,
              );
        },
      );
    }

    final state = ref.watch(tasmiControllerProvider);
    final controller = ref.read(tasmiControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF064E3B);
    final accentColor = const Color(0xFFD97706);
    final bgColor = isDark ? const Color(0xFF0F172A) : Colors.grey[50];
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: TasmiPageHeader(
          surahName: 'سورة ${quran.getSurahNameArabic(surahNumber)}',
          fromAya: fromAya,
          toAya: toAya,
          isListening: state.status == TasmiStatus.listening,
        ),
        body: Column(
          children: [
            TasmiStatsRow(state: state),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state.status == TasmiStatus.listening)
                    TasmiListeningIndicator(isListening: state.isMicListening)
                  else
                    const SizedBox.shrink(),
                  
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TasmiOnboardingPage(
                            onDone: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.tune_rounded, size: 18),
                    label: const Text('إعدادات التسميع', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (state.status == TasmiStatus.idle || state.status == TasmiStatus.error)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(isDark ? 0.2 : 0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.mic_none_rounded, size: 64, color: primaryColor),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'اضغط ابدأ للبدء بالتسميع', 
                            style: TextStyle(
                              fontSize: 18, 
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            )
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'اقرأ بوضوح وصوت مسموع لنتائج أفضل', 
                            style: TextStyle(
                              fontSize: 14, 
                              fontFamily: 'Cairo',
                              color: isDark ? Colors.white60 : Colors.black54,
                            )
                          ),
                          if (state.status == TasmiStatus.error && state.errorMessage != null)
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.error_outline_rounded, color: Colors.red[700], size: 20),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      state.errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.red[700], fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    if (state.status == TasmiStatus.listening ||
                        state.status == TasmiStatus.waitingForUser ||
                        state.status == TasmiStatus.finished)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return const MushafTasmiView();
                        },
                      ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: state.correctionWord != null
                  ? TasmiCorrectionBubble(word: state.correctionWord)
                  : const SizedBox.shrink(),
            ),
            if (state.status == TasmiStatus.waitingForUser)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: controller.resumeAfterUserPrompt,
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: const Text('متابعة التسميع', style: TextStyle(fontSize: 18, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: primaryColor.withOpacity(0.4),
                    ),
                  ),
                ),
              )
            else
              TasmiActionButton(
                state: state,
                onStart: () => controller.startSession(surahNumber: surahNumber, fromAya: fromAya, toAya: toAya),
                onStop: controller.stopSession,
                onRestart: () => controller.startSession(surahNumber: surahNumber, fromAya: fromAya, toAya: toAya),
                onShowResults: () {
                  _showResultsBottomSheet(context, state, primaryColor, accentColor, isDark);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showResultsBottomSheet(BuildContext context, TasmiState state, Color primaryColor, Color accentColor, bool isDark) {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Text(
                  'نتائج التسميع',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: isDark ? Colors.white : primaryColor,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 140,
                  height: 140,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: state.stats.accuracyPercent / 100,
                        strokeWidth: 12,
                        backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                        color: state.stats.accuracyPercent >= 80
                            ? Colors.green
                            : state.stats.accuracyPercent >= 50 ? accentColor : Colors.red,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${state.stats.accuracyPercent.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              color: isDark ? Colors.white : primaryColor,
                            ),
                          ),
                          Text(
                            'دقة الحفظ',
                            style: TextStyle(
                              fontSize: 14, 
                              fontFamily: 'Cairo',
                              color: isDark ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatChip(
                        label: 'صحيح',
                        value: state.stats.correctCount,
                        color: Colors.green,
                        icon: Icons.check_circle_rounded,
                        isDark: isDark,
                      ),
                      Container(width: 1, height: 40, color: isDark ? Colors.white10 : Colors.grey[300]),
                      _StatChip(
                        label: 'قريب',
                        value: state.stats.closeErrorCount,
                        color: accentColor,
                        icon: Icons.warning_rounded,
                        isDark: isDark,
                      ),
                      Container(width: 1, height: 40, color: isDark ? Colors.white10 : Colors.grey[300]),
                      _StatChip(
                        label: 'خطأ',
                        value: state.stats.wrongCount,
                        color: Colors.red,
                        icon: Icons.cancel_rounded,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (state.stats.totalErrors > 0) ...[
                  Row(
                    children: [
                      Icon(Icons.history_edu_rounded, color: accentColor),
                      const SizedBox(width: 8),
                      Text(
                        'الكلمات التي تحتاج مراجعة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          color: isDark ? Colors.white : primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.stats.errorList.take(10).length,
                      separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey[200]),
                      itemBuilder: (context, index) {
                        final e = state.stats.errorList[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                              size: 16,
                            ),
                          ),
                          title: Text(
                            e.correctWord,
                            style: TextStyle(
                              fontFamily: 'Amiri', 
                              fontSize: 22,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            textDirection: ui.TextDirection.rtl,
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'آية ${e.verseNumber}',
                              style: TextStyle(
                                fontSize: 12, 
                                fontFamily: 'Cairo',
                                color: isDark ? Colors.white70 : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (state.stats.errorList.length > 10)
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'عرض كل الأخطاء (${state.stats.errorList.length})',
                        style: TextStyle(fontFamily: 'Cairo', color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: accentColor.withOpacity(0.5), width: 2),
                      backgroundColor: accentColor.withOpacity(0.05),
                    ),
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VefaPage(isSelectionMode: true),
                        ),
                      );
                    },
                    icon: Icon(Icons.favorite_rounded, color: accentColor, size: 24),
                    label: Text(
                      'إهداء الثواب', 
                      style: TextStyle(
                        fontSize: 18, 
                        fontFamily: 'Cairo', 
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.pop(sheetContext),
                    child: const Text('حسنا', style: TextStyle(fontSize: 18, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: MediaQuery.of(sheetContext).padding.bottom),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ Error showing bottom sheet: $e');
    }
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  final bool isDark;

  const _StatChip({
    required this.label, 
    required this.value, 
    required this.color,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold, 
            color: color,
            fontFamily: 'Cairo',
          ),
        ),
        Text(
          label, 
          style: TextStyle(
            fontSize: 14, 
            color: isDark ? Colors.white70 : Colors.grey[700],
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}