import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'كيف تحب تجربة التسميع؟',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'يمكنك تغيير هذا لاحقا من الإعدادات',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView(
                    children: [
                      const _SectionTitle('عند الخطأ، ماذا تريد التطبيق يفعل؟'),
                      const SizedBox(height: 12),
                      _ChoiceCard(
                        selected: _onError == OnErrorBehavior.speakAndContinue,
                        icon: Icons.record_voice_over_rounded,
                        title: 'ينطق الكلمة الصحيحة ويكمل',
                        subtitle: 'مناسب للحفظ السريع',
                        onTap: () => setState(() => _onError = OnErrorBehavior.speakAndContinue),
                      ),
                      const SizedBox(height: 8),
                      _ChoiceCard(
                        selected: _onError == OnErrorBehavior.waitForUser,
                        icon: Icons.pause_circle_rounded,
                        title: 'يوقف وينتظر حتى أصحح',
                        subtitle: 'مناسب للتعلم والمراجعة',
                        onTap: () => setState(() => _onError = OnErrorBehavior.waitForUser),
                      ),
                      const SizedBox(height: 8),
                      _ChoiceCard(
                        selected: _onError == OnErrorBehavior.continueOnly,
                        icon: Icons.skip_next_rounded,
                        title: 'يكمل بصمت',
                        subtitle: 'للاختبار الذاتي بدون تدخل',
                        onTap: () => setState(() => _onError = OnErrorBehavior.continueOnly),
                      ),
                      const SizedBox(height: 28),
                      const _SectionTitle('كم مرة تريد تحاول قبل تسجيل الخطأ؟'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _AttemptsChip(
                            label: 'مرة واحدة',
                            selected: _attempts == AttemptsMode.one,
                            onTap: () => setState(() => _attempts = AttemptsMode.one),
                          ),
                          const SizedBox(width: 8),
                          _AttemptsChip(
                            label: 'مرتان',
                            selected: _attempts == AttemptsMode.two,
                            onTap: () => setState(() => _attempts = AttemptsMode.two),
                          ),
                          const SizedBox(width: 8),
                          _AttemptsChip(
                            label: 'ثلاث مرات',
                            selected: _attempts == AttemptsMode.three,
                            onTap: () => setState(() => _attempts = AttemptsMode.three),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const _SectionTitle('هل تريد سماع الكلمة الصحيحة بصوت عند الخطأ؟'),
                      const SizedBox(height: 12),
                      SwitchListTile.adaptive(
                        value: _ttsEnabled,
                        onChanged: (value) => setState(() => _ttsEnabled = value),
                        title: const Text('صوت التصحيح'),
                        subtitle: Text(_ttsEnabled ? 'مفعّل' : 'معطّل'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      const SizedBox(height: 28),
                      const _SectionTitle('كم تريد التطبيق صارما في التقييم؟'),
                      const SizedBox(height: 12),
                      _ChoiceCard(
                        selected: _strictness == StrictnessLevel.easy,
                        icon: Icons.sentiment_satisfied_rounded,
                        title: 'متساهل',
                        subtitle: 'الأخطاء القريبة تعد صحيحة',
                        onTap: () => setState(() => _strictness = StrictnessLevel.easy),
                      ),
                      const SizedBox(height: 8),
                      _ChoiceCard(
                        selected: _strictness == StrictnessLevel.medium,
                        icon: Icons.sentiment_neutral_rounded,
                        title: 'متوسط',
                        subtitle: 'الأخطاء القريبة تحتسب منفصلة',
                        onTap: () => setState(() => _strictness = StrictnessLevel.medium),
                      ),
                      const SizedBox(height: 8),
                      _ChoiceCard(
                        selected: _strictness == StrictnessLevel.strict,
                        icon: Icons.sentiment_very_dissatisfied_rounded,
                        title: 'صارم',
                        subtitle: 'أي انحراف عن النص = خطأ',
                        onTap: () => setState(() => _strictness = StrictnessLevel.strict),
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('ابدأ التسميع', style: TextStyle(fontSize: 18)),
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

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : Colors.transparent,
          border: Border.all(
            color: selected ? color : Colors.grey.shade300,
            width: selected ? 1.5 : 0.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? color : Colors.grey, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: selected ? color : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (selected) Icon(Icons.check_circle_rounded, color: color, size: 20),
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

  const _AttemptsChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            border: Border.all(
              color: selected ? color : Colors.grey.shade300,
              width: selected ? 1.5 : 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}
