import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/core/presentation/widgets/reciter_picker_sheet.dart';
import 'package:sila_app/core/providers/reciter_provider.dart';
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/features/hifz/presentation/controllers/interactive_shadow_controller.dart';
import 'package:sila_app/features/tasmi/domain/tajweed_normalizer.dart';

const Color _successColor = Color(0xFF10B981);
const Color _hasanatGold = Color(0xFFFCD34D);
const Color _errorColor = Color(0xFFF87171);

class InteractiveShadowPage extends ConsumerStatefulWidget {
  final int surahNumber;
  final int fromVerse;
  final int toVerse;

  const InteractiveShadowPage({
    super.key,
    this.surahNumber = 1,
    this.fromVerse = 1,
    this.toVerse = 5,
  });

  @override
  ConsumerState<InteractiveShadowPage> createState() => _InteractiveShadowPageState();
}

class _InteractiveShadowPageState extends ConsumerState<InteractiveShadowPage>
    with TickerProviderStateMixin {
  final TextEditingController _reflectionController = TextEditingController();
  final Map<int, TextEditingController> _inlineControllers = {};
  final Map<int, FocusNode> _inlineFocusNodes = {};
  late final AnimationController _flashController;
  late final AnimationController _waveController;
  bool _isNextBusy = false;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _waveController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _waveController.repeat(reverse: true);

    Future<void>.microtask(() {
      ref.read(interactiveShadowControllerProvider.notifier).startSession(
            surahNumber: widget.surahNumber,
            fromVerse: widget.fromVerse,
            toVerse: widget.toVerse,
          );
    });
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    for (final c in _inlineControllers.values) {
      c.dispose();
    }
    for (final f in _inlineFocusNodes.values) {
      f.dispose();
    }
    _flashController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _syncInlineInputs(List<ShadowWordEntry> words) {
    final validIndexes = <int>{};
    for (int i = 0; i < words.length; i++) {
      final w = words[i];
      if (!w.isHidden || w.isAyahMarker) {
        continue;
      }
      validIndexes.add(i);
      _inlineControllers.putIfAbsent(i, () => TextEditingController());
      _inlineFocusNodes.putIfAbsent(i, () => FocusNode());
    }

    final stale = _inlineControllers.keys.where((k) => !validIndexes.contains(k)).toList();
    for (final key in stale) {
      _inlineControllers.remove(key)?.dispose();
      _inlineFocusNodes.remove(key)?.dispose();
    }
  }

  int? _findNextHiddenIndex(List<ShadowWordEntry> words, int fromIndex) {
    for (int i = fromIndex + 1; i < words.length; i++) {
      final w = words[i];
      if (w.isHidden && !w.isAyahMarker && !w.revealedCorrectly) {
        return i;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(interactiveShadowControllerProvider);
    final controller = ref.read(interactiveShadowControllerProvider.notifier);
    final reciter = ref.watch(reciterControllerProvider).valueOrNull;
    _syncInlineInputs(state.words);

    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppTheme.darkBackgroundColor,
        colorScheme: const ColorScheme.dark(
          primary: AppTheme.primaryColor,
          secondary: AppTheme.accentColor,
          surface: AppTheme.darkSurfaceColor,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppTheme.darkBackgroundColor,
          body: SafeArea(
            child: Stack(
              children: [
                state.finished
                    ? _SessionResultsView(
                        state: state,
                        onHome: () => Navigator.popUntil(context, (r) => r.isFirst),
                        onDedicate: () => controller.openThawaabDedication(context),
                      )
                    : Column(
                        children: [
                      _TopHeader(
                        surahName: quran.getSurahNameArabic(state.surahNumber),
                        stage: state.currentStage,
                        reciterLabel: reciter?.nameArabic.split(' ').last ?? 'الحصري',
                        onReciterTap: () => showReciterPickerSheet(context),
                        onMomentTap: () {
                          final verseIndex = state.fromVerse + state.currentVerseIndex;
                          _showMomentCapture(
                            context,
                            quran.getVerse(
                              state.surahNumber,
                              verseIndex,
                              verseEndSymbol: false,
                            ),
                            quran.getSurahNameArabic(state.surahNumber),
                          );
                        },
                      ),
                      _StageBanner(stage: state.currentStage),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.05),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                                child: child,
                              ),
                            );
                          },
                          child: _StageContent(
                            key: ValueKey(state.currentStage * 100 + state.currentVerseIndex),
                            state: state,
                            flashController: _flashController,
                          ),
                        ),
                      ),
                      if (state.currentStage <= 2)
                        _AudioBar(
                          isPlaying: state.isPlaying,
                          waveController: _waveController,
                          onToggle: controller.toggleAudio,
                          reciterLabel: reciter?.nameArabic.split(' ').last ?? 'الحصري',
                        ),
                      const SizedBox(height: 8),
                      _MicBar(
                        isListening: state.isMicListening,
                        onToggle: controller.toggleMic,
                      ),
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: 8),
                        _InlineStatusMessage(message: state.errorMessage!),
                      ],
                      if (state.currentStage >= 3) ...[
                        const SizedBox(height: 8),
                        const _WritingModeBar(),
                      ],
                      const SizedBox(height: 10),
                      _StatsRow(
                        correct: state.correctWords,
                        wrong: state.wrongWords,
                        hasanat: state.sessionHashanat,
                      ),
                      const SizedBox(height: 10),
                      _InstructionCard(stage: state.currentStage),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _isNextBusy
                            ? null
                            : () async {
                                setState(() => _isNextBusy = true);
                                try {
                                  await controller.nextStage();
                                } finally {
                                  if (mounted) {
                                    setState(() => _isNextBusy = false);
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isNextBusy
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'التالي',
                                style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                      ),
                      const SizedBox(height: 8),
                      if (state.currentStage >= 3)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'يمكنك إكمال المخفي بالكتابة أو اختبار نفسك بالمايك',
                            style: GoogleFonts.cairo(fontSize: 11, color: Colors.white54),
                          ),
                        ),
                      const SizedBox(height: 8),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMomentCapture(
    BuildContext context,
    String verseText,
    String surahName,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MomentCaptureSheet(
        surahName: surahName,
        verseText: verseText,
        onSave: (feeling, note) async {
          await ref
              .read(interactiveShadowControllerProvider.notifier)
              .saveMoment(reflection: note, feeling: feeling);
          if (ctx.mounted) {
            Navigator.pop(ctx);
          }
        },
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final String surahName;
  final int stage;
  final String reciterLabel;
  final VoidCallback onReciterTap;
  final VoidCallback onMomentTap;

  const _TopHeader({
    required this.surahName,
    required this.stage,
    required this.reciterLabel,
    required this.onReciterTap,
    required this.onMomentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.darkBackgroundColor,
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white60),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: List.generate(5, (index) {
              final current = index + 1;
              final color = current < stage
                  ? AppTheme.accentColor
                  : current == stage
                      ? AppTheme.primaryColor
                      : Colors.white.withValues(alpha: 0.15);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: 24,
                height: 4,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
              );
            }),
          ),
          Text(
            surahName,
            style: GoogleFonts.cairo(fontSize: 11, color: Colors.white.withValues(alpha: 0.5)),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onReciterTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mic_rounded, color: Colors.white70, size: 13),
                  const SizedBox(width: 3),
                  Text(
                    reciterLabel,
                    style: GoogleFonts.cairo(fontSize: 10, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onMomentTap,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: const Center(
                child: Text('💎', style: TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StageBanner extends StatelessWidget {
  final int stage;

  const _StageBanner({required this.stage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          _stageName(stage),
          style: GoogleFonts.cairo(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppTheme.accentColor,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  String _stageName(int stage) {
    return switch (stage) {
      1 => 'المرحلة ١ — الاستماع',
      2 => 'المرحلة ٢ — التظليل',
      3 => 'المرحلة ٣ — ٣٠٪ مخفي',
      4 => 'المرحلة ٤ — ٦٠٪ مخفي',
      5 => 'المرحلة ٥ — كامل من الذاكرة',
      _ => 'المرحلة',
    };
  }
}

class _StageContent extends StatelessWidget {
  final InteractiveShadowState state;
  final AnimationController flashController;

  const _StageContent({super.key, required this.state, required this.flashController});

  @override
  Widget build(BuildContext context) {
    final pageState = context.findAncestorStateOfType<_InteractiveShadowPageState>();
    final controller = pageState == null
        ? null
        : pageState.ref.read(interactiveShadowControllerProvider.notifier);

    final color = ColorTween(
      begin: Colors.transparent,
      end: _errorColor.withValues(alpha: 0.2),
    ).animate(flashController);

    return AnimatedBuilder(
      animation: flashController,
      builder: (_, __) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: color.value,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                spacing: 6,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: state.words.asMap().entries.map((entry) {
                  final index = entry.key;
                  final word = entry.value;

                  if (!word.isHidden || word.isAyahMarker || pageState == null || controller == null) {
                    return _WordChip(entry: word);
                  }

                  final textController = pageState._inlineControllers[index]!;
                  final focusNode = pageState._inlineFocusNodes[index]!;
                  final validation = controller.inlineWordValidation(index);

                  return _InlineWordInput(
                    index: index,
                    hiddenWord: word.word,
                    controller: textController,
                    focusNode: focusNode,
                    isCorrect: word.revealedCorrectly
                        ? true
                        : validation,
                    onChanged: (value) async {
                      await controller.onWordTyped(index, value);
                      final updated = pageState.ref.read(interactiveShadowControllerProvider);
                      final nextIndex = pageState._findNextHiddenIndex(updated.words, index);
                      if (nextIndex != null &&
                          controller.inlineWordValidation(index) == true &&
                          pageState._inlineFocusNodes[nextIndex] != null) {
                        pageState._inlineFocusNodes[nextIndex]!.requestFocus();
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          );
      },
    );
  }
}

class _WordChip extends StatelessWidget {
  final ShadowWordEntry entry;

  const _WordChip({required this.entry});

  @override
  Widget build(BuildContext context) {
    if (entry.isAyahMarker) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Text(
          entry.word,
          style: GoogleFonts.amiri(fontSize: 14, color: AppTheme.accentColor),
        ),
      );
    }

    if (!entry.isHidden) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          entry.word,
          style: GoogleFonts.amiri(fontSize: 20, color: const Color(0xFFE2E8F0), height: 1.5),
        ),
      );
    }

    if (entry.revealedCorrectly) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.6), width: 0.5),
        ),
        child: Text(
          entry.word,
          style: GoogleFonts.amiri(fontSize: 20, color: const Color(0xFF6EE7B7), height: 1.5),
        ),
      );
    }

    final dashCount = (entry.word.length / 2).ceil().clamp(2, 6);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.25), width: 1.5)),
      ),
      child: Text(
        '—' * dashCount,
        style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.2), letterSpacing: 3),
      ),
    );
  }
}

class _AudioBar extends StatelessWidget {
  final bool isPlaying;
  final AnimationController waveController;
  final Future<void> Function() onToggle;
  final String reciterLabel;

  const _AudioBar({
    required this.isPlaying,
    required this.waveController,
    required this.onToggle,
    required this.reciterLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onToggle(),
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: _AudioWaveform(isPlaying: isPlaying, controller: waveController)),
          const SizedBox(width: 10),
          Text(reciterLabel, style: GoogleFonts.cairo(fontSize: 9, color: Colors.white38)),
        ],
      ),
    );
  }
}

class _InlineWordInput extends StatelessWidget {
  const _InlineWordInput({
    required this.index,
    required this.hiddenWord,
    required this.controller,
    required this.focusNode,
    required this.isCorrect,
    required this.onChanged,
  });

  final int index;
  final String hiddenWord;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool? isCorrect;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final wordLength = TajweedNormalizer.stripDiacritics(hiddenWord).length;
    final boxWidth = (wordLength * 18.0).clamp(60.0, 180.0);

    Color borderColor;
    Color bgColor;

    if (isCorrect == null) {
      borderColor = Colors.white24;
      bgColor = Colors.white.withValues(alpha: 0.08);
    } else if (isCorrect == true) {
      borderColor = const Color(0xFF22C55E);
      bgColor = const Color(0xFF22C55E).withValues(alpha: 0.15);
    } else {
      borderColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFEF4444).withValues(alpha: 0.15);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: boxWidth,
      height: 42,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: isCorrect == true
          ? Center(
              child: Text(
                hiddenWord,
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  color: const Color(0xFF22C55E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : TextField(
              controller: controller,
              focusNode: focusNode,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(fontSize: 18, color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                hintText: '...',
                hintStyle: TextStyle(color: Colors.white30, fontSize: 16),
              ),
              onChanged: onChanged,
              textInputAction: TextInputAction.next,
            ),
    );
  }
}

class _AudioWaveform extends StatelessWidget {
  final bool isPlaying;
  final AnimationController controller;

  const _AudioWaveform({required this.isPlaying, required this.controller});

  @override
  Widget build(BuildContext context) {
    const heights = [4, 8, 14, 10, 18, 12, 20, 16, 22, 14, 10, 18, 12, 8, 6];
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Row(
          children: List.generate(heights.length, (i) {
            final base = heights[i].toDouble();
            final amp = isPlaying ? (0.4 + (0.6 * ((controller.value + (i * 0.06)) % 1.0))) : 0.4;
            final h = base * amp;
            final active = i >= 3 && i <= 10;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.2),
              child: Container(
                width: 2.8,
                height: h,
                decoration: BoxDecoration(
                  color: active ? AppTheme.accentColor : Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _WritingModeBar extends StatelessWidget {
  const _WritingModeBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1.5),
            ),
            child: const Icon(Icons.edit_note_rounded, color: Colors.white70, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'الوضع الكتابي مفعل',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6EE7B7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'أكمل الكلمات المخفية داخل الآية',
                  style: GoogleFonts.cairo(fontSize: 10, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineStatusMessage extends StatelessWidget {
  const _InlineStatusMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final isError = message.contains('تعذر') ||
        message.contains('لم يتم') ||
        message.contains('غير صحيحة') ||
        message.contains('حاول');

    final bgColor = isError
        ? const Color(0xFF7F1D1D).withValues(alpha: 0.28)
        : const Color(0xFF0E4D35).withValues(alpha: 0.30);
    final borderColor = isError
        ? const Color(0xFFEF4444).withValues(alpha: 0.45)
        : const Color(0xFF6EE7B7).withValues(alpha: 0.45);
    final textColor = isError ? const Color(0xFFFECACA) : const Color(0xFFBBF7D0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 0.6),
        ),
        child: Text(
          message,
          style: GoogleFonts.cairo(fontSize: 10.5, color: textColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _MicBar extends StatelessWidget {
  final bool isListening;
  final Future<void> Function() onToggle;

  const _MicBar({required this.isListening, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220).withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10), width: 0.6),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onToggle(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isListening ? _successColor.withValues(alpha: 0.16) : Colors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
                border: Border.all(color: isListening ? _successColor : Colors.white24, width: 1.3),
              ),
              child: Icon(isListening ? Icons.graphic_eq_rounded : Icons.mic_none_rounded, color: isListening ? _successColor : Colors.white54, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isListening ? 'المايك يعمل الآن' : 'اختبر تلاوتك بالمايك',
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isListening ? const Color(0xFF6EE7B7) : Colors.white70,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isListening ? 'تحدث بوضوح...' : 'اضغط للبدء بالمقارنة الصوتية',
                  style: GoogleFonts.cairo(fontSize: 9.5, color: Colors.white38),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: isListening ? null : 0,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(
                      isListening ? const Color(0xFF6EE7B7) : Colors.white24,
                    ),
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int correct;
  final int wrong;
  final int hasanat;

  const _StatsRow({required this.correct, required this.wrong, required this.hasanat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatChip(value: _toArabicIndic(correct), label: 'صح', valueColor: _successColor),
          const SizedBox(width: 8),
          _StatChip(value: _toArabicIndic(wrong), label: 'خطأ', valueColor: _errorColor),
          const SizedBox(width: 8),
          _StatChip(value: _toArabicIndic(hasanat), label: 'حسنة', valueColor: _hasanatGold),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatChip({required this.value, required this.label, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: valueColor)),
            Text(label, style: GoogleFonts.cairo(fontSize: 10, color: Colors.white38)),
          ],
        ),
      ),
    );
  }
}

class _InstructionCard extends StatelessWidget {
  final int stage;

  const _InstructionCard({required this.stage});

  @override
  Widget build(BuildContext context) {
    final pair = _instruction(stage);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.15),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.4), width: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(pair.$1, style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF6EE7B7))),
          const SizedBox(height: 3),
          Text(pair.$2, style: GoogleFonts.cairo(fontSize: 10, color: Colors.white38)),
        ],
      ),
    );
  }

  (String, String) _instruction(int stage) {
    return switch (stage) {
      1 => ('استمع جيداً', 'اضغط "التالي" للانتقال للمرحلة التالية'),
      2 => ('ردد مع الشيخ', 'حاول المزامنة مع الصوت'),
      3 => ('أكمل الكلمات المخفية', 'الكلمات الخضراء أجبت عنها صح'),
      4 => ('تحدٍّ أكبر — استمر', '٦٠٪ من الآية مخفي الآن'),
      5 => ('تلاوة كاملة من الذاكرة', 'أنت قادر على ذلك بإذن الله'),
      _ => ('مرحلة', ''),
    };
  }
}

class _SessionResultsView extends StatefulWidget {
  final InteractiveShadowState state;
  final VoidCallback onHome;
  final VoidCallback onDedicate;

  const _SessionResultsView({required this.state, required this.onHome, required this.onDedicate});

  @override
  State<_SessionResultsView> createState() => _SessionResultsViewState();
}

class _SessionResultsViewState extends State<_SessionResultsView> {
  final List<bool> _visible = List<bool>.filled(5, false);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      Future<void>.delayed(Duration(milliseconds: i * 150), () {
        if (!mounted) return;
        setState(() => _visible[i] = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalWords = widget.state.correctWords + widget.state.wrongWords;
    final accuracy = totalWords == 0 ? 0 : ((widget.state.correctWords / totalWords) * 100).round();
    final minutes = (widget.state.stageResults.values
                .fold<int>(0, (sum, e) => sum + e.totalWords) /
            12)
        .ceil();
    final ayahCount = widget.state.toVerse - widget.state.fromVerse + 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _visible[0] ? 1 : 0,
            child: TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: widget.state.sessionHashanat),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeOut,
              builder: (_, value, __) {
                return Column(
                  children: [
                    Text(
                      _toArabicIndic(value),
                      style: GoogleFonts.cairo(fontSize: 52, fontWeight: FontWeight.w800, color: _hasanatGold),
                    ),
                    Text('حسنة اكتسبتها بإذن الله', style: GoogleFonts.cairo(fontSize: 13, color: Colors.white60)),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _visible[1] ? 1 : 0,
            child: Row(
              children: [
                _ResultStat(value: '${_toArabicIndic(accuracy)}٪', label: 'دقة', color: _successColor),
                const SizedBox(width: 10),
                _ResultStat(value: _toArabicIndic(ayahCount), label: 'آيات', color: Colors.white),
                const SizedBox(width: 10),
                _ResultStat(value: '${_toArabicIndic(minutes)} د', label: 'وقت', color: AppTheme.accentColor),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _visible[2] ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('أداء كل مرحلة', style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white70)),
                  const SizedBox(height: 10),
                  ...List.generate(5, (idx) {
                    final stage = idx + 1;
                    final r = widget.state.stageResults[stage];
                    final total = (r?.totalWords ?? 0);
                    final acc = total == 0 ? 1.0 : ((r!.correctWords) / total).clamp(0.0, 1.0);
                    final labels = ['الاستماع', 'الترديد', '٣٠٪ مخفي', '٦٠٪ مخفي', 'كامل'];
                    return _StageRow(stage: stage, label: labels[idx], accuracy: acc);
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _visible[3] ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.5), width: 0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(_motivational().$1, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text(
                    _motivational().$2,
                    style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF6EE7B7)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _motivational().$3,
                    style: GoogleFonts.cairo(fontSize: 11, color: Colors.white.withValues(alpha: 0.5)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (widget.state.sessionMoments.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'لحظاتك مع القرآن اليوم 💎',
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.state.sessionMoments.map((moment) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '• آية ${_toArabicIndic(moment.verseNumber)}: ${moment.feeling}${moment.reflection.isNotEmpty ? ' - ${moment.reflection}' : ''}',
                        style: GoogleFonts.cairo(fontSize: 11, color: Colors.white70),
                      ),
                    );
                  }),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  const Text('💎', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'هل لمستك آية اليوم؟',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'اضغط 💎 في أي وقت خلال الجلسة القادمة',
                          style: GoogleFonts.cairo(fontSize: 11, color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _visible[4] ? 1 : 0,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onHome,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    child: Text('الرئيسية', style: GoogleFonts.cairo(fontSize: 13, color: Colors.white60)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onDedicate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      elevation: 0,
                    ),
                    child: Text(
                      'إهداء الثواب 🤲',
                      style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (String, String, String) _motivational() {
    final ayahCount = _toArabicIndic(widget.state.toVerse - widget.state.fromVerse + 1);
    final minutes = _toArabicIndic((widget.state.stageResults.values.fold<int>(0, (sum, e) => sum + e.totalWords) / 12).ceil());
    return switch (1) {
      0 => ('✦', 'أداء مميز', 'حفظت $ayahCount آيات في جلسة واحدة'),
      1 => ('🌟', 'أداء ممتاز', 'أنت في أفضل ١٥٪ من الحفاظ اليوم'),
      2 => ('✨', 'أحسنت', '$minutes دقيقة أوصلتك لهدفك اليوم'),
      3 => ('🤲', 'بارك الله فيك', 'كل حرف حفظته نور في الدنيا والآخرة'),
      _ => ('🤲', 'بارك الله فيك', 'كل حرف حفظته نور في الدنيا والآخرة'),
    };
  }
}

class _MomentCaptureSheet extends StatefulWidget {
  final String surahName;
  final String verseText;
  final Future<void> Function(String feeling, String note) onSave;

  const _MomentCaptureSheet({
    required this.surahName,
    required this.verseText,
    required this.onSave,
  });

  @override
  State<_MomentCaptureSheet> createState() => _MomentCaptureSheetState();
}

class _MomentCaptureSheetState extends State<_MomentCaptureSheet> {
  String _selectedFeeling = 'أثّر فيّ';
  String _note = '';

  @override
  Widget build(BuildContext context) {
    Widget feelingChip(String emoji, String label) {
      final selected = _selectedFeeling == label;
      return ChoiceChip(
        label: Text('$emoji $label', style: GoogleFonts.cairo(fontSize: 11)),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => setState(() => _selectedFeeling = label),
        selectedColor: AppTheme.accentColor.withValues(alpha: 0.2),
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.white70,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkSurfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 0.5)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.surahName,
            style: GoogleFonts.cairo(fontSize: 10, color: Colors.white30),
          ),
          const SizedBox(height: 6),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              widget.verseText,
              style: GoogleFonts.amiri(fontSize: 14, color: Colors.white60, height: 2.0),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(color: Colors.white12, height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'هل لامست هذه الآية قلبك؟',
              style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              feelingChip('🥺', 'أثّر فيّ'),
              feelingChip('😢', 'بكيت'),
              feelingChip('😌', 'اطمأننت'),
              feelingChip('🤔', 'تأملت'),
              feelingChip('🙏', 'شكرت الله'),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            style: GoogleFonts.cairo(fontSize: 13, color: Colors.white70),
            textDirection: TextDirection.rtl,
            maxLines: 2,
            onChanged: (v) => _note = v,
            decoration: InputDecoration(
              hintText: 'اكتب كلمتين عن شعورك...',
              hintStyle: GoogleFonts.cairo(fontSize: 12, color: Colors.white30),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.07),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white12, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white12, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppTheme.accentColor, width: 1),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('تخطي', style: GoogleFonts.cairo(fontSize: 12, color: Colors.white60)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async => widget.onSave(_selectedFeeling, _note.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: Text(
                    'احفظ اللحظة 💎',
                    style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _ResultStat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: GoogleFonts.cairo(fontSize: 10, color: Colors.white38)),
          ],
        ),
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  final int stage;
  final String label;
  final double accuracy;

  const _StageRow({required this.stage, required this.label, required this.accuracy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: accuracy,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.12),
                valueColor: const AlwaysStoppedAnimation(_successColor),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.cairo(fontSize: 10, color: Colors.white70)),
          const SizedBox(width: 8),
          Text('$stage', style: GoogleFonts.cairo(fontSize: 10, color: Colors.white54)),
        ],
      ),
    );
  }
}

String _toArabicIndic(int value) {
  final western = value.toString();
  const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  final buffer = StringBuffer();
  for (final unit in western.codeUnits) {
    final digit = unit - 48;
    if (digit >= 0 && digit <= 9) {
      buffer.write(digits[digit]);
    }
  }
  return buffer.toString();
}
