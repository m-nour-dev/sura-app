
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
                      const MushafTasmiView(),
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
                // TODO: Implement results view
              },
            ),
          ],
        ),
      ),
    );
  }
}
