import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/features/notifications/presentation/controllers/notification_settings_controller.dart';

class NotificationSettingsSheet extends ConsumerWidget {
  final String featureKey;

  const NotificationSettingsSheet({
    super.key,
    required this.featureKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationSettingsProvider(featureKey));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FB);
    final card = isDark ? const Color(0xFF1E293B) : Colors.white;
    final border = isDark ? const Color(0xFF334155) : const Color(0xFFDCE3EE);
    final title = isDark ? const Color(0xFFF1F5F9) : const Color(0xFF102A43);
    final subtitle = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF486581);

    return state.when(
      data: (settings) {
        return Container(
          color: bg,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6FFFA),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.notifications_active_rounded,
                                  size: 18, color: Color(0xFF0F766E)),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'إعدادات التذكير',
                                  style: GoogleFonts.getFont(
                                    'Cairo',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: title,
                                  ),
                                ),
                                Text(
                                  'خصص الوقت والنمط بحسب عبادتك',
                                  style: GoogleFonts.getFont(
                                    'Cairo',
                                    fontSize: 11,
                                    color: subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: settings.isEnabled,
                          activeThumbColor: const Color(0xFF064E3B),
                          title: Text(
                            'تفعيل التذكير',
                            style: GoogleFonts.getFont('Cairo', color: title, fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            settings.isEnabled ? 'الإشعارات فعالة الآن' : 'الإشعارات متوقفة',
                            style: GoogleFonts.getFont('Cairo', color: subtitle, fontSize: 11),
                          ),
                          onChanged: (v) => ref
                              .read(notificationSettingsProvider(featureKey).notifier)
                              .toggleEnabled(v),
                        ),
                      ],
                    ),
                  ),
                  if (settings.isEnabled) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('التكرار',
                              style: GoogleFonts.getFont(
                                'Cairo',
                                color: title,
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue: settings.frequency,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7FAFC),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: border),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'daily',
                                child: Text('يومي', style: GoogleFonts.getFont('Cairo')),
                              ),
                              DropdownMenuItem(
                                value: 'weekly',
                                child: Text('أسبوعي', style: GoogleFonts.getFont('Cairo')),
                              ),
                              DropdownMenuItem(
                                value: 'smart',
                                child: Text('ذكي', style: GoogleFonts.getFont('Cairo')),
                              ),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                ref
                                    .read(notificationSettingsProvider(featureKey).notifier)
                                    .setFrequency(v);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          Text('نوع المحتوى المفضل',
                              style: GoogleFonts.getFont(
                                'Cairo',
                                color: title,
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _TypeChip(featureKey: featureKey, type: 'hadith', label: 'حديث'),
                              _TypeChip(featureKey: featureKey, type: 'ayah', label: 'آية'),
                              _TypeChip(featureKey: featureKey, type: 'dhikr', label: 'ذكر'),
                              _TypeChip(featureKey: featureKey, type: 'hikma', label: 'حكمة'),
                            ],
                          ),
                          if (featureKey == 'azkar') ...[
                            const SizedBox(height: 12),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              value: settings.endTimeReminderEnabled,
                              activeThumbColor: const Color(0xFF064E3B),
                              title: Text(
                                'تذكير قبل نهاية الوقت',
                                style: GoogleFonts.getFont('Cairo', color: title, fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                'تنبيه إضافي قبل ساعة من انتهاء الوقت',
                                style: GoogleFonts.getFont('Cairo', color: subtitle, fontSize: 11),
                              ),
                              onChanged: (v) => ref
                                  .read(notificationSettingsProvider(featureKey).notifier)
                                  .toggleEndTimeReminder(v),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('تعذر تحميل الإعدادات')),
    );
  }
}

class _TypeChip extends ConsumerWidget {
  final String featureKey;
  final String type;
  final String label;

  const _TypeChip({
    required this.featureKey,
    required this.type,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationSettingsProvider(featureKey));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final chipSelected = isDark ? const Color(0xFF134E4A) : const Color(0xFFCCFBF1);
    final chipBorder = isDark ? const Color(0xFF334155) : const Color(0xFFDCE3EE);
    final textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final selected = state.value?.preferredTypes.contains(type) ?? false;
    return ChoiceChip(
      label: Text(label, style: GoogleFonts.getFont('Cairo', color: textColor, fontWeight: FontWeight.w700)),
      selected: selected,
      backgroundColor: chipBg,
      selectedColor: chipSelected,
      side: BorderSide(color: chipBorder),
      onSelected: (_) => ref
          .read(notificationSettingsProvider(featureKey).notifier)
          .togglePreferredType(type),
    );
  }
}
