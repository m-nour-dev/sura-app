import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_preferences.dart';
import 'package:sila_app/features/tasmi/presentation/riverpod/tasmi_preferences_provider.dart';

class TasmiOnboardingPage extends ConsumerStatefulWidget {
  final VoidCallback onDone;

  const TasmiOnboardingPage({super.key, required this.onDone});

  @override
  ConsumerState<TasmiOnboardingPage> createState() => _TasmiOnboardingPageState();
}

class _TasmiOnboardingPageState extends ConsumerState<TasmiOnboardingPage> {
  OnErrorBehavior _onError = OnErrorBehavior.speakAndContinue;
  AttemptsMode _attempts = AttemptsMode.two;
  bool _ttsEnabled = true;
  StrictnessLevel _strictness = StrictnessLevel.medium;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'كيف تحب تجربة التسميع؟',
                  style: GoogleFonts.cairo(
                    fontSize: 26, 
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'يمكنك تغيير هذا لاحقا من الإعدادات',
                  style: GoogleFonts.cairo(
                    fontSize: 15, 
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    children: [
                      _SectionTitle('عند الخطأ، ماذا تريد التطبيق يفعل؟', isDark),
                      const SizedBox(height: 12),
                      _ChoiceCard(
                        selected: _onError == OnErrorBehavior.speakAndContinue,
                        icon: Icons.record_voice_over_rounded,
                        title: 'ينطق الكلمة الصحيحة ويكمل',
                        subtitle: 'مناسب للحفظ السريع',
                        onTap: () => setState(() => _onError = OnErrorBehavior.speakAndContinue),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _ChoiceCard(
                        selected: _onError == OnErrorBehavior.waitForUser,
                        icon: Icons.pause_circle_rounded,
                        title: 'يوقف وينتظر حتى أصحح',
                        subtitle: 'مناسب للتعلم والمراجعة',
                        onTap: () => setState(() => _onError = OnErrorBehavior.waitForUser),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _ChoiceCard(
                        selected: _onError == OnErrorBehavior.continueOnly,
                        icon: Icons.skip_next_rounded,
                        title: 'يكمل بصمت',
                        subtitle: 'للاختبار الذاتي بدون تدخل',
                        onTap: () => setState(() => _onError = OnErrorBehavior.continueOnly),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 32),
                      _SectionTitle('كم مرة تريد تحاول قبل تسجيل الخطأ؟', isDark),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _AttemptsChip(
                            label: 'مرة واحدة',
                            selected: _attempts == AttemptsMode.one,
                            onTap: () => setState(() => _attempts = AttemptsMode.one),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 8),
                          _AttemptsChip(
                            label: 'مرتان',
                            selected: _attempts == AttemptsMode.two,
                            onTap: () => setState(() => _attempts = AttemptsMode.two),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 8),
                          _AttemptsChip(
                            label: 'ثلاث مرات',
                            selected: _attempts == AttemptsMode.three,
                            onTap: () => setState(() => _attempts = AttemptsMode.three),
                            isDark: isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _SectionTitle('هل تريد سماع الكلمة الصحيحة بصوت عند الخطأ؟', isDark),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkSurfaceColor : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                        ),
                        child: SwitchListTile.adaptive(
                          value: _ttsEnabled,
                          activeColor: AppTheme.accentColor,
                          onChanged: (value) => setState(() => _ttsEnabled = value),
                          title: Text(
                            'صوت التصحيح',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppTheme.primaryColor,
                            ),
                          ),
                          subtitle: Text(
                            _ttsEnabled ? 'مفعّل' : 'معطّل',
                            style: GoogleFonts.cairo(
                              color: isDark ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _SectionTitle('كم تريد التطبيق صارما في التقييم؟', isDark),
                      const SizedBox(height: 12),
                      _ChoiceCard(
                        selected: _strictness == StrictnessLevel.easy,
                        icon: Icons.sentiment_satisfied_rounded,
                        title: 'متساهل',
                        subtitle: 'الأخطاء القريبة تعد صحيحة',
                        onTap: () => setState(() => _strictness = StrictnessLevel.easy),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _ChoiceCard(
                        selected: _strictness == StrictnessLevel.medium,
                        icon: Icons.sentiment_neutral_rounded,
                        title: 'متوسط',
                        subtitle: 'الأخطاء القريبة تحتسب منفصلة',
                        onTap: () => setState(() => _strictness = StrictnessLevel.medium),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                      _ChoiceCard(
                        selected: _strictness == StrictnessLevel.strict,
                        icon: Icons.sentiment_very_dissatisfied_rounded,
                        title: 'صارم',
                        subtitle: 'أي انحراف عن النص = خطأ',
                        onTap: () => setState(() => _strictness = StrictnessLevel.strict),
                        isDark: isDark,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: AppTheme.primaryColor.withValues(alpha: 0.4),
                    ),
                    child: Text(
                      'ابدأ التسميع', 
                      style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final prefs = TasmiPreferences(
      onErrorBehavior: _onError,
      attemptsMode: _attempts,
      ttsEnabled: _ttsEnabled,
      strictness: _strictness,
      isOnboardingDone: true,
    );
    await ref.read(tasmiPreferencesNotifierProvider.notifier).update(prefs);
    widget.onDone();
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final bool isDark;

  const _SectionTitle(this.text, this.isDark);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        fontSize: 17, 
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : AppTheme.primaryColor,
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDark;

  const _ChoiceCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppTheme.accentColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected 
              ? activeColor.withValues(alpha: 0.1) 
              : (isDark ? AppTheme.darkSurfaceColor : Colors.white),
          border: Border.all(
            color: selected ? activeColor : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
            width: selected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? activeColor : (isDark ? Colors.white54 : Colors.grey), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: selected ? activeColor : (isDark ? Colors.white : AppTheme.primaryColor),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 13, 
                      color: isDark ? Colors.white70 : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle_rounded, color: activeColor, size: 24),
          ],
        ),
      ),
    );
  }
}

class _AttemptsChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const _AttemptsChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppTheme.accentColor;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? activeColor : (isDark ? AppTheme.darkSurfaceColor : Colors.white),
            border: Border.all(
              color: selected ? activeColor : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              width: selected ? 2.0 : 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.w600,
              color: selected ? Colors.white : (isDark ? Colors.white : AppTheme.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
