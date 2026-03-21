import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/features/hifz/presentation/controllers/interactive_shadow_controller.dart';

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
  final TextEditingController _manualReciteController = TextEditingController();
  late final AnimationController _flashController;
  late final AnimationController _waveController;

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
    _manualReciteController.dispose();
    _flashController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(interactiveShadowControllerProvider);
    final controller = ref.read(interactiveShadowControllerProvider.notifier);

    if (state.showMomentPrompt) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: _MomentSheet(
              verseText: quran.getVerse(
                state.surahNumber,
                state.fromVerse + state.currentVerseIndex,
                verseEndSymbol: false,
              ),
              surahName: quran.getSurahNameArabic(state.surahNumber),
              textController: _reflectionController,
              onTextChanged: controller.setReflectionText,
              onSkip: () async {
                await controller.skipMoment();
                if (ctx.mounted) Navigator.pop(ctx);
              },
              onSave: () async {
                await controller.saveMoment();
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
          ),
        );
      });
    }

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
            child: state.finished
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
                        )
                      else
                        _MicBar(
                          isListening: state.isMicListening,
                          onToggle: controller.toggleMic,
                        ),
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
                        onPressed: controller.nextStage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'التالي',
                          style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (state.currentStage >= 3)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _manualReciteController,
                                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.white70),
                                  textDirection: TextDirection.rtl,
                                  decoration: InputDecoration(
                                    hintText: 'للاختبار اليدوي: اكتب التلاوة هنا',
                                    hintStyle: GoogleFonts.cairo(fontSize: 11, color: Colors.white30),
                                    filled: true,
                                    fillColor: Colors.white.withValues(alpha: 0.06),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  final text = _manualReciteController.text;
                                  _manualReciteController.clear();
                                  await controller.onUserRecited(text);
                                  await _flashController.forward(from: 0);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  'تحقق',
                                  style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  final String surahName;
  final int stage;

  const _TopHeader({required this.surahName, required this.stage});

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
              children: state.words.map((w) => _WordChip(entry: w)).toList(),
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

  const _AudioBar({required this.isPlaying, required this.waveController, required this.onToggle});

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
          Text('الحصري', style: GoogleFonts.cairo(fontSize: 9, color: Colors.white38)),
        ],
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

class _MicBar extends StatelessWidget {
  final bool isListening;
  final Future<void> Function() onToggle;

  const _MicBar({required this.isListening, required this.onToggle});

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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isListening ? _successColor.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
                border: Border.all(color: isListening ? _successColor : Colors.white24, width: 1.5),
              ),
              child: Icon(isListening ? Icons.mic : Icons.mic_off, color: isListening ? _successColor : Colors.white38, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isListening)
                  Row(
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: _successColor, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text('يستمع...', style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.w600, color: _successColor)),
                    ],
                  )
                else
                  Text('اضغط للبدء', style: GoogleFonts.cairo(fontSize: 10, color: Colors.white38)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: isListening ? 0.65 : 0,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation(_successColor),
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
      1 => ('استمع جيداً', 'ستنتقل تلقائياً عند انتهاء التلاوة'),
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

class _MomentSheet extends StatelessWidget {
  final String surahName;
  final String verseText;
  final TextEditingController textController;
  final ValueChanged<String> onTextChanged;
  final Future<void> Function() onSkip;
  final Future<void> Function() onSave;

  const _MomentSheet({
    required this.surahName,
    required this.verseText,
    required this.textController,
    required this.onTextChanged,
    required this.onSkip,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
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
            surahName,
            style: GoogleFonts.cairo(fontSize: 10, color: Colors.white30),
          ),
          const SizedBox(height: 6),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              verseText,
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
          TextField(
            controller: textController,
            style: GoogleFonts.cairo(fontSize: 13, color: Colors.white70),
            textDirection: TextDirection.rtl,
            maxLines: 2,
            onChanged: onTextChanged,
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
                  onPressed: () async => onSkip(),
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
                  onPressed: () async => onSave(),
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
