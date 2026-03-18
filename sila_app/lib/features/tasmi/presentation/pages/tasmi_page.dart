
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/features/tasmi/presentation/controllers/tasmi_controller.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/mushaf_tasmi_view.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/tasmi_action_button.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/tasmi_correction_bubble.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/tasmi_page_header.dart';
import 'package:sila_app/features/tasmi/presentation/pages/widgets/tasmi_stats_row.dart';

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
    final state = ref.watch(tasmiControllerProvider);
    final controller = ref.read(tasmiControllerProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: TasmiPageHeader(
          surahName: 'سورة ${quran.getSurahName(surahNumber)}',
          fromAya: fromAya,
          toAya: toAya,
          isListening: state.status == TasmiStatus.listening,
        ),
        body: Column(
          children: [
            TasmiStatsRow(state: state),
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
                            Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    if (state.status != TasmiStatus.idle)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          debugPrint(
                            '📐 Mushaf constraints: w=${constraints.maxWidth} h=${constraints.maxHeight}',
                          );
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
            TasmiActionButton(
              state: state,
              onStart: () => controller.startSession(surahNumber: surahNumber, fromAya: fromAya, toAya: toAya),
              onStop: () => controller.stopSession(),
              onRestart: () => controller.startSession(surahNumber: surahNumber, fromAya: fromAya, toAya: toAya),
              onShowResults: () {
                debugPrint('✅ Show Results button clicked!');
                try {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (sheetContext) => Directionality(
                      textDirection: TextDirection.rtl,
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
                            ListTile(
                              leading: const Icon(Icons.check_circle, color: Colors.green, size: 40),
                              title: const Text('الكلمات الصحيحة', style: TextStyle(fontSize: 18)),
                              trailing: Text(
                                '${state.stats.correctCount}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.error, color: Colors.red, size: 40),
                              title: const Text('الأخطاء الإجمالية', style: TextStyle(fontSize: 18)),
                              trailing: Text(
                                '${state.stats.errorCount}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(sheetContext),
                                child: const Text('حسناً', style: TextStyle(fontSize: 18)),
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
