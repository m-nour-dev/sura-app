import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/notifications/data/models/notification_settings.dart';
import 'package:sila_app/features/notifications/presentation/controllers/notification_providers.dart';

final notificationSettingsProvider = StateNotifierProvider.family<
    NotificationSettingsController,
    AsyncValue<NotificationSettings>,
    String>((ref, featureKey) {
  return NotificationSettingsController(ref, featureKey);
});

class NotificationSettingsController
    extends StateNotifier<AsyncValue<NotificationSettings>> {
  final Ref _ref;
  final String _featureKey;

  NotificationSettingsController(this._ref, this._featureKey)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = await _ref.read(notificationRepositoryProvider.future);
      final settings = await repo.getSettings(_featureKey);
      state = AsyncValue.data(settings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleEnabled(bool value) => _update((s) => s.isEnabled = value);
  Future<void> setFrequency(String value) => _update((s) => s.frequency = value);
  Future<void> setFixedTime(int hour, int minute) =>
      _update((s) {
        s.timingType = 'fixed';
        s.fixedHour = hour;
        s.fixedMinute = minute;
      });

  Future<void> setRelativeToPrayer(String prayerName, int minutesAfter) =>
      _update((s) {
        s.timingType = 'relative_to_prayer';
        s.prayerName = prayerName;
        s.minutesAfterPrayer = minutesAfter;
      });

  Future<void> togglePreferredType(String type) => _update((s) {
        if (s.preferredTypes.contains(type)) {
          s.preferredTypes = s.preferredTypes.where((e) => e != type).toList();
        } else {
          s.preferredTypes = [...s.preferredTypes, type];
        }
      });

  Future<void> toggleEndTimeReminder(bool value) =>
      _update((s) => s.endTimeReminderEnabled = value);

  Future<void> _update(void Function(NotificationSettings settings) change) async {
    final current = state.value;
    if (current == null) return;
    change(current);
    state = AsyncValue.data(current);
    final repo = await _ref.read(notificationRepositoryProvider.future);
    await repo.saveSettings(current);
  }
}
