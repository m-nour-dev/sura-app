import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sila_app/core/services/notification_service.dart';
import 'package:sila_app/core/services/adhan_scheduler_service.dart';
import 'package:sila_app/features/prayers/data/repositories/prayer_repository_impl.dart';
import 'package:sila_app/features/notifications/data/notification_ids.dart';
import 'package:sila_app/features/notifications/presentation/controllers/notification_providers.dart';
import 'package:sila_app/features/notifications/presentation/controllers/notification_settings_controller.dart';

class NotificationSettingsSheet extends ConsumerStatefulWidget {
  final String featureKey;

  const NotificationSettingsSheet({
    super.key,
    required this.featureKey,
  });

  @override
  ConsumerState<NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState
    extends ConsumerState<NotificationSettingsSheet> {
  late Future<List<PendingNotificationRequest>> _pendingNotificationsFuture;

  @override
  void initState() {
    super.initState();
    _pendingNotificationsFuture =
        NotificationService().getPendingNotifications();
  }

  Set<int> _featureNotificationIds(String key) {
    switch (key) {
      case 'salah':
        return {
          NotificationIds.fajr,
          NotificationIds.dhuhr,
          NotificationIds.asr,
          NotificationIds.maghrib,
          NotificationIds.isha,
        };
      case 'azkar':
        return {
          NotificationIds.azkarSabah,
          NotificationIds.azkarSabahUrgent,
          NotificationIds.azkarMasa,
          NotificationIds.azkarMasaUrgent,
        };
      case 'wird':
        return {NotificationIds.wird};
      case 'hifz':
        return {NotificationIds.hifz, NotificationIds.tasmi};
      case 'tasbih':
        return {NotificationIds.tasbih};
      default:
        return <int>{};
    }
  }

  void _refreshPendingNotifications() {
    setState(() {
      _pendingNotificationsFuture =
          NotificationService().getPendingNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final featureKey = widget.featureKey;
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
                              child: const Icon(
                                  Icons.notifications_active_rounded,
                                  size: 18,
                                  color: Color(0xFF0F766E)),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                   'notification_reminder_settings'.tr(),
                                   style: GoogleFonts.getFont(
                                     'Cairo',
                                     fontSize: 16,
                                     fontWeight: FontWeight.w800,
                                     color: title,
                                   ),
                                 ),
                                 Text(
                                   'customize_reminders'.tr(),
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
                            'enable_reminder'.tr(),
                            style: GoogleFonts.getFont('Cairo',
                                color: title, fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            settings.isEnabled
                                ? 'notifications_active_now'.tr()
                                : 'notifications_disabled_now'.tr(),
                            style: GoogleFonts.getFont('Cairo',
                                color: subtitle, fontSize: 11),
                          ),
                          onChanged: (v) => ref
                              .read(notificationSettingsProvider(featureKey)
                                  .notifier)
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
                          Text('repeat_frequency'.tr(),
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
                              fillColor: isDark
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFF7FAFC),
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
                                child: Text('daily'.tr(),
                                    style: GoogleFonts.getFont('Cairo')),
                              ),
                              DropdownMenuItem(
                                value: 'weekly',
                                child: Text('weekly'.tr(),
                                    style: GoogleFonts.getFont('Cairo')),
                              ),
                              DropdownMenuItem(
                                value: 'smart',
                                child: Text('smart'.tr(),
                                    style: GoogleFonts.getFont('Cairo')),
                              ),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                ref
                                    .read(
                                        notificationSettingsProvider(featureKey)
                                            .notifier)
                                    .setFrequency(v);
                              }
                            },
                          ),
                          const SizedBox(height: 14),
                          Text('preferred_content_type'.tr(),
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
                              _TypeChip(
                                  featureKey: featureKey,
                                  type: 'hadith',
                                  label: 'hadith'.tr()),
                              _TypeChip(
                                  featureKey: featureKey,
                                  type: 'ayah',
                                  label: 'verse'.tr()),
                              _TypeChip(
                                  featureKey: featureKey,
                                  type: 'dhikr',
                                  label: 'dhikr'.tr()),
                              _TypeChip(
                                  featureKey: featureKey,
                                  type: 'hikma',
                                  label: 'wisdom'.tr()),
                            ],
                          ),
                          if (featureKey == 'azkar') ...[
                            const SizedBox(height: 12),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              value: settings.endTimeReminderEnabled,
                              activeThumbColor: const Color(0xFF064E3B),
                              title: Text(
                                'reminder_before_end'.tr(),
                                style: GoogleFonts.getFont('Cairo',
                                    color: title, fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                'reminder_before_end_desc'.tr(),
                                style: GoogleFonts.getFont('Cairo',
                                    color: subtitle, fontSize: 11),
                              ),
                              onChanged: (v) => ref
                                  .read(notificationSettingsProvider(featureKey)
                                      .notifier)
                                  .toggleEndTimeReminder(v),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            await NotificationService().initialize();
                            await NotificationService().requestPermissions();
                            final settingsRepo = await ref
                                .read(notificationRepositoryProvider.future);
                            await settingsRepo.seedInitialContentIfNeeded();
                            final repo = PrayerRepositoryImpl();
                            final times = await repo.getPrayerTimes();
                            await AdhanSchedulerService()
                                .scheduleAllPrayers(times);
                            final pending = await NotificationService()
                                .getPendingNotifications();
                            _refreshPendingNotifications();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'reschedule_success'.tr(args: [pending.length.toString()]))),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('reschedule_failed'.tr(args: [e.toString()]))),
                            );
                          }
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text('reactivate_notifications_now'.tr(),
                            style: GoogleFonts.getFont('Cairo')),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            await NotificationService().initialize();
                            await NotificationService().requestPermissions();
                            await NotificationService()
                                .scheduleDebugNotificationInSeconds(
                                    seconds: 15);
                            _refreshPendingNotifications();
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'test_notification_started'.tr())),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('test_notification_failed'.tr(args: [e.toString()]))),
                            );
                          }
                        },
                        icon: const Icon(Icons.bug_report_rounded),
                        label: Text('test_notification_15s'.tr(),
                            style: GoogleFonts.getFont('Cairo')),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder(
                      future: _pendingNotificationsFuture,
                      builder: (context, snapshot) {
                        final all = snapshot.data ??
                            const <PendingNotificationRequest>[];
                        final ids = _featureNotificationIds(featureKey);
                        final list = all.where((n) {
                          if (ids.contains(n.id)) return true;
                          final payload = n.payload ?? '';
                          return payload.contains(featureKey);
                        }).toList();
                        final count = list.length;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'scheduled_notifications_count'.tr(args: [count.toString()]),
                              style: GoogleFonts.getFont('Cairo',
                                  fontSize: 11, color: subtitle),
                            ),
                            const SizedBox(height: 4),
                            if (list.isEmpty)
                              Text(
                                'no_scheduled_notifications'.tr(),
                                style: GoogleFonts.getFont('Cairo',
                                    fontSize: 10, color: subtitle),
                              )
                            else
                              ...list.take(5).map(
                                    (n) => Text(
                                      '• ${n.id}: ${n.title}',
                                      style: GoogleFonts.getFont('Cairo',
                                          fontSize: 10, color: subtitle),
                                    ),
                                  ),
                            const SizedBox(height: 2),
                            Text(
                              'total_on_device'.tr(args: [all.length.toString()]),
                              style: GoogleFonts.getFont('Cairo',
                                  fontSize: 10, color: subtitle),
                            ),
                          ],
                        );
                      },
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('settings_load_error'.tr()),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () =>
                    ref.invalidate(notificationSettingsProvider(featureKey)),
                icon: const Icon(Icons.refresh_rounded),
                label:
                    Text('retry'.tr(), style: GoogleFonts.getFont('Cairo')),
              ),
              const SizedBox(height: 4),
              Text(
                '$e',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont('Cairo',
                    fontSize: 10, color: const Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
      ),
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
    final chipSelected =
        isDark ? const Color(0xFF134E4A) : const Color(0xFFCCFBF1);
    final chipBorder =
        isDark ? const Color(0xFF334155) : const Color(0xFFDCE3EE);
    final textColor =
        isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);
    final selected = state.value?.preferredTypes.contains(type) ?? false;
    return ChoiceChip(
      label: Text(label,
          style: GoogleFonts.getFont('Cairo',
              color: textColor, fontWeight: FontWeight.w700)),
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
