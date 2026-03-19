import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/features/hifz/presentation/controllers/hifz_onboarding_controller.dart';
import 'package:sila_app/features/hifz/presentation/pages/hifz_home_page.dart';

const Color _errorColor = Color(0xFFF87171);
const LinearGradient _onboardingGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF064E3B), Color(0xFF0A6B52), Color(0xFF1A3A5C)],
  stops: [0.0, 0.4, 1.0],
);
const LinearGradient _ctaGradient = LinearGradient(
  colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
);

class HifzOnboardingPage extends ConsumerStatefulWidget {
  final VoidCallback? onCompleted;

  const HifzOnboardingPage({super.key, this.onCompleted});

  @override
  ConsumerState<HifzOnboardingPage> createState() => _HifzOnboardingPageState();
}

class _HifzOnboardingPageState extends ConsumerState<HifzOnboardingPage> {
  late final PageController _pageController;
  int _previousPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<HifzOnboardingState>(hifzOnboardingControllerProvider, (previous, next) {
      if (next.onboardingDone && previous?.onboardingDone != true) {
        if (widget.onCompleted != null) {
          widget.onCompleted!.call();
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HifzHomePage()),
          );
        }
      }

      if (previous != null && previous.currentPage != next.currentPage) {
        _previousPage = previous.currentPage;
      }
    });

    final state = ref.watch(hifzOnboardingControllerProvider);
    final controller = ref.read(hifzOnboardingControllerProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              if (state.currentPage > 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: _TopProgressBar(previousPage: _previousPage, currentPage: state.currentPage),
                ),
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
                  child: _InfoBanner(
                    color: _errorColor.withValues(alpha: 0.12),
                    border: _errorColor.withValues(alpha: 0.3),
                    textColor: _errorColor,
                    message: state.errorMessage!,
                  ),
                ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: controller.setCurrentPage,
                  children: [
                    _WelcomeScreen(onStart: () => _goToPage(1)),
                    _AgeScreen(
                      selected: state.ageGroup,
                      onSelect: (index) async {
                        controller.setAgeGroup(index);
                        await Future<void>.delayed(const Duration(milliseconds: 300));
                        if (!mounted) return;
                        controller.nextPage();
                        await _goToPage(2);
                      },
                    ),
                    _TimeGoalScreen(
                      selectedMinutes: state.dailyMinutes,
                      selectedGoal: state.goal,
                      onMinutesSelect: controller.setDailyMinutes,
                      onGoalSelect: controller.setGoal,
                      onNext: () async {
                        controller.nextPage();
                        await _goToPage(3);
                      },
                    ),
                    _LearningStyleScreen(
                      selected: state.learningStyle,
                      onSelect: (index) async {
                        controller.setLearningStyle(index);
                        await Future<void>.delayed(const Duration(milliseconds: 300));
                        if (!mounted) return;
                        controller.nextPage();
                        await _goToPage(4);
                      },
                    ),
                    _SmartPlanScreen(
                      state: state,
                      onToggle: controller.setAutoAdapt,
                      onComplete: controller.completeOnboarding,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToPage(int page) async {
    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}

class _TopProgressBar extends StatelessWidget {
  final int previousPage;
  final int currentPage;

  const _TopProgressBar({required this.previousPage, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final start = ((previousPage) / 4).clamp(0.0, 1.0);
    final end = ((currentPage) / 4).clamp(0.0, 1.0);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: start, end: end),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (_, value, __) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Stack(
            children: [
              Container(height: 3, color: const Color(0xFFE2E8F0)),
              FractionallySizedBox(
                widthFactor: value,
                child: Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF064E3B), Color(0xFFD97706)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WelcomeScreen extends StatelessWidget {
  final VoidCallback onStart;

  const _WelcomeScreen({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: _onboardingGradient),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.2),
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome, color: Colors.white, size: 30),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'رحلتك مع القرآن\nتبدأ هنا',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سنبني معك خطة تناسبك\nتماماً بإذن الله',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 20),
            const _WelcomeDots(),
            const SizedBox(height: 24),
            _ScaleTapButton(label: 'ابدأ ←', onTap: onStart),
          ],
        ),
      ),
    );
  }
}

class _WelcomeDots extends StatelessWidget {
  const _WelcomeDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final active = index == 0;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppTheme.accentColor : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(50),
          ),
        );
      }),
    );
  }
}

class _AgeScreen extends StatelessWidget {
  final int? selected;
  final ValueChanged<int> onSelect;

  const _AgeScreen({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    const items = [
      ('١٨–', 'أقل من ١٨'),
      ('٢٥–١٨', '١٨ إلى ٢٥ سنة'),
      ('٣٥–٢٦', '٢٦ إلى ٣٥ سنة'),
      ('٣٥+', 'أكثر من ٣٥'),
    ];

    return _QuestionLayout(
      title: 'كم عمرك؟',
      hint: 'سيساعدنا في تخصيص طريقة الحفظ',
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.35,
              ),
              itemBuilder: (_, index) {
                final item = items[index];
                final isSelected = selected == index;
                return _SelectionCard(
                  selected: isSelected,
                  onTap: () => onSelect(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.$1,
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.$2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const _InfoBanner(
            color: Color(0xFFF0FDF4),
            border: Color(0xFFBBF7D0),
            textColor: AppTheme.primaryColor,
            message: '💡 سينتقل تلقائياً بعد اختيارك',
          ),
        ],
      ),
    );
  }
}

class _TimeGoalScreen extends StatelessWidget {
  final int? selectedMinutes;
  final int? selectedGoal;
  final ValueChanged<int> onMinutesSelect;
  final ValueChanged<int> onGoalSelect;
  final VoidCallback onNext;

  const _TimeGoalScreen({
    required this.selectedMinutes,
    required this.selectedGoal,
    required this.onMinutesSelect,
    required this.onGoalSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    const minuteOptions = [10, 20, 30, 60];
    const minuteLabels = ['١٠ دق', '٢٠ دق', '٣٠ دق', 'أكثر'];
    const goals = [
      ('📖', 'سور قصيرة', 'للمبتدئين والمشغولين'),
      ('📚', 'جزء كامل', 'هدف واضح ومحدد'),
      ('🔄', 'مراجعة', 'ما حفظته سابقاً'),
      ('⭐', 'القرآن كاملاً', 'الهمة العالية'),
    ];

    return _QuestionLayout(
      title: 'كم وقتك يومياً للحفظ؟',
      hint: 'اختر الوقت الأنسب ليومك',
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(minuteOptions.length, (index) {
              final selected = selectedMinutes == minuteOptions[index];
              return GestureDetector(
                onTap: () => onMinutesSelect(minuteOptions[index]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: selected ? AppTheme.primaryColor : const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    minuteLabels[index],
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : const Color(0xFF475569),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'ما هدفك؟',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              itemCount: goals.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.12,
              ),
              itemBuilder: (_, index) {
                final goal = goals[index];
                final isSelected = selectedGoal == index;
                return _SelectionCard(
                  selected: isSelected,
                  onTap: () => onGoalSelect(index),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(goal.$1, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 6),
                      Text(
                        goal.$2,
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        goal.$3,
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedMinutes != null && selectedGoal != null ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'التالي',
                style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningStyleScreen extends StatelessWidget {
  final int? selected;
  final ValueChanged<int> onSelect;

  const _LearningStyleScreen({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    const styles = [
      ('👁', 'أقرأ وأكرر', 'أسلوب بصري'),
      ('👂', 'أسمع وأردد', 'أسلوب سمعي'),
      ('🔄', 'أمزج الطريقتين', 'أسلوب مختلط'),
      ('❓', 'لا أعرف بعد', 'سنساعدك في الاختيار'),
    ];

    return _QuestionLayout(
      title: 'كيف تحفظ عادةً؟',
      hint: 'اختيارك يساعد في تخصيص طريقة الظل التفاعلي',
      child: GridView.builder(
        itemCount: styles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (_, index) {
          final style = styles[index];
          final isSelected = selected == index;
          return _SelectionCard(
            selected: isSelected,
            onTap: () => onSelect(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(style.$1, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text(
                  style.$2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  style.$3,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SmartPlanScreen extends StatelessWidget {
  final HifzOnboardingState state;
  final ValueChanged<bool> onToggle;
  final Future<void> Function() onComplete;

  const _SmartPlanScreen({
    required this.state,
    required this.onToggle,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final plan = state.previewPlan;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'خطتك الذكية ✨',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF064E3B), Color(0xFF0A6B52), Color(0xFF1A3A5C)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بناءً على إجاباتك:',
                  style: GoogleFonts.cairo(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '● ${_toArabicIndic(plan?.newAyahsTarget ?? 3)} آيات جديدة يومياً',
                  style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '● مراجعة ${_toArabicIndic(plan?.reviewAyahsTarget ?? 8)} آيات',
                  style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  '● ${plan?.estimatedCompletion ?? 'ستنهي الجزء في ٤ أشهر'} ⭐',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFCD34D),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التكيف التلقائي',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'سيعدّل التطبيق خطتك كل أسبوع بناءً على أدائك',
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(value: state.autoAdapt, onChanged: onToggle),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: state.isSaving ? null : () => onComplete(),
            child: Ink(
              decoration: BoxDecoration(
                gradient: _ctaGradient,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: state.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'ابدأ رحلتي ✨',
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionLayout extends StatelessWidget {
  final String title;
  final String hint;
  final Widget child;

  const _QuestionLayout({required this.title, required this.hint, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hint,
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  const _SelectionCard({required this.selected, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppTheme.primaryColor : const Color(0xFFE2E8F0),
            width: selected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? AppTheme.primaryColor.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: selected ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final Color color;
  final Color border;
  final Color textColor;
  final String message;

  const _InfoBanner({
    required this.color,
    required this.border,
    required this.textColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.cairo(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _ScaleTapButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _ScaleTapButton({required this.label, required this.onTap});

  @override
  State<_ScaleTapButton> createState() => _ScaleTapButtonState();
}

class _ScaleTapButtonState extends State<_ScaleTapButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.95 : 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.accentColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
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
