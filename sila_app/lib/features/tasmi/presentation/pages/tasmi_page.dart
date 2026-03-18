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

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
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
                  label: const Text('إعدادات التسميع'),
                ),
              ),
            ),
            if (state.status == TasmiStatus.listening)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TasmiListeningIndicator(isListening: state.isMicListening),
                ),
              ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (state.status == TasmiStatus.idle || state.status == TasmiStatus.error)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mic, size: 60, color: Theme.of(context).dividerColor),
                          const SizedBox(height: 16),
                          const Text('اضغط ابدأ للبدء بالتسميع', style: TextStyle(fontSize: 16)),
                          if (state.status == TasmiStatus.error && state.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                state.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
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
                  child: child,
                );
              },
              child: state.correctionWord != null
                  ? TasmiCorrectionBubble(word: state.correctionWord)
                  : const SizedBox.shrink(),
            ),
            if (state.status == TasmiStatus.waitingForUser)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: controller.resumeAfterUserPrompt,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('متابعة'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                try {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (sheetContext) => Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'نتائج التسميع',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: state.stats.accuracyPercent / 100,
                                    strokeWidth: 10,
                                    backgroundColor: Colors.grey[200],
                                    color: state.stats.accuracyPercent >= 80
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${state.stats.accuracyPercent.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'دقة',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _StatChip(
                                  label: 'صحيح',
                                  value: state.stats.correctCount,
                                  color: Colors.green,
                                ),
                                _StatChip(
                                  label: 'قريب',
                                  value: state.stats.closeErrorCount,
                                  color: Colors.amber,
                                ),
                                _StatChip(
                                  label: 'خطأ',
                                  value: state.stats.wrongCount,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (state.stats.totalErrors > 0) ...[
                              const Divider(),
                              const Text(
                                'الكلمات التي تحتاج مراجعة',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...state.stats.errorList.take(10).map(
                                (e) => ListTile(
                                  dense: true,
                                  leading: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  title: Text(
                                    e.correctWord,
                                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
                                    textDirection: ui.TextDirection.rtl,
                                  ),
                                  subtitle: Text(
                                    'آية ${e.verseNumber}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              if (state.stats.errorList.length > 10)
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'عرض كل الأخطاء (${state.stats.errorList.length})',
                                  ),
                                ),
                            ],
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
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
                                icon: const Icon(Icons.favorite, color: Colors.red, size: 18),
                                label: const Text('إهداء الثواب', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(sheetContext),
                                child: const Text('حسنا', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } catch (e) {
                  debugPrint('❌ Error showing bottom sheet: $e');
                }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
