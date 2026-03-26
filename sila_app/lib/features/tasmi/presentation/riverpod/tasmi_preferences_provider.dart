import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_preferences.dart';
import 'package:sila_app/features/tasmi/data/repositories/tasmi_preferences_repository.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final tasmiPreferencesRepositoryProvider = Provider<TasmiPreferencesRepository?>((ref) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  return prefsAsync.whenOrNull(data: TasmiPreferencesRepository.new);
});

final tasmiPreferencesNotifierProvider =
    NotifierProvider<TasmiPreferencesNotifier, TasmiPreferences>(
  TasmiPreferencesNotifier.new,
);

class TasmiPreferencesNotifier extends Notifier<TasmiPreferences> {
  @override
  TasmiPreferences build() {
    final repo = ref.watch(tasmiPreferencesRepositoryProvider);
    return repo?.load() ?? TasmiPreferences.defaults();
  }

  Future<void> update(TasmiPreferences newPrefs) async {
    state = newPrefs;
    final repo = ref.read(tasmiPreferencesRepositoryProvider);
    await repo?.save(newPrefs);
  }
}
