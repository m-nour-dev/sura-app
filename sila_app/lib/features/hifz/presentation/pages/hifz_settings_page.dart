import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/core/theme/app_theme.dart';
import 'package:sila_app/features/hifz/data/models/hifz_settings.dart';
import 'package:sila_app/features/hifz/presentation/controllers/hifz_settings_controller.dart';

class HifzSettingsPage extends ConsumerWidget {
  const HifzSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSettings = ref.watch(hifzSettingsControllerProvider);
    final controller = ref.read(hifzSettingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إعدادات الحفظ',
          style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
        ),
      ),
      body: asyncSettings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'تعذر تحميل إعدادات الحفظ',
            style: GoogleFonts.cairo(fontSize: 14),
          ),
        ),
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionTitle('دقة التحقق'),
              SegmentedButton<HifzVerificationMode>(
                segments: const [
                  ButtonSegment(value: HifzVerificationMode.easy, label: Text('سهل')),
                  ButtonSegment(value: HifzVerificationMode.normal, label: Text('متوازن')),
                  ButtonSegment(value: HifzVerificationMode.strict, label: Text('صارم')),
                ],
                selected: {settings.readVerificationMode()},
                onSelectionChanged: (selection) async {
                  await controller.updateSettings(verificationMode: selection.first);
                },
              ),
              const SizedBox(height: 18),
              _SectionTitle('الاستماع والتلقين'),
              _StepperTile(
                title: 'تكرار الاستماع',
                subtitle: 'عدد مرات تشغيل الآية في المراحل السمعية',
                value: settings.listenRepeats,
                min: 1,
                max: 3,
                onChanged: (v) => controller.updateSettings(listenRepeats: v),
              ),
              _StepperTile(
                title: 'محاولات قبل التلميح',
                subtitle: 'عدد المحاولات قبل اعتبار الكلمة خطأ',
                value: settings.attemptsBeforeHint,
                min: 1,
                max: 4,
                onChanged: (v) => controller.updateSettings(attemptsBeforeHint: v),
              ),
              _StepperTile(
                title: 'مدة الالتقاط',
                subtitle: 'كلما زادت، يزيد وقت استماع الميكروفون',
                value: settings.hintDelaySeconds,
                min: 1,
                max: 8,
                suffix: 'ث',
                onChanged: (v) => controller.updateSettings(hintDelaySeconds: v),
              ),
              const SizedBox(height: 18),
              _SectionTitle('سلوك الجلسة'),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.primaryColor,
                title: Text('تجاهل التشكيل عند التحقق', style: GoogleFonts.cairo()),
                subtitle: Text(
                  'يسهّل المطابقة إذا نطق المستخدم بدون حركات دقيقة',
                  style: GoogleFonts.cairo(fontSize: 12),
                ),
                value: settings.hideVisibleDiacritics,
                onChanged: (v) => controller.updateSettings(hideVisibleDiacritics: v),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.primaryColor,
                title: Text('تشغيل الآية عند وجود خطأ', style: GoogleFonts.cairo()),
                subtitle: Text(
                  'عند الخطأ يعيد تشغيل الآية لتثبيت الحفظ',
                  style: GoogleFonts.cairo(fontSize: 12),
                ),
                value: settings.playCorrectOnError,
                onChanged: (v) => controller.updateSettings(playCorrectOnError: v),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.primaryColor,
                title: Text('وضع المبتدئ', style: GoogleFonts.cairo()),
                value: settings.beginnerMode,
                onChanged: (v) => controller.updateSettings(beginnerMode: v),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.primaryColor,
                title: Text('صرامة ذكية', style: GoogleFonts.cairo()),
                value: settings.smartStrictness,
                onChanged: (v) => controller.updateSettings(smartStrictness: v),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontSize: 13,
          color: const Color(0xFF0F172A),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StepperTile extends StatelessWidget {
  const _StepperTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.suffix = '',
  });

  final String title;
  final String subtitle;
  final int value;
  final int min;
  final int max;
  final String suffix;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: GoogleFonts.cairo(fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '$value$suffix',
              style: GoogleFonts.cairo(fontWeight: FontWeight.w700),
            ),
            IconButton(
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
