import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/features/hifz/data/models/hifz_settings.dart';
import 'package:sila_app/features/hifz/data/repositories/hifz_repository_provider.dart';

part 'hifz_settings_controller.g.dart';

@riverpod
class HifzSettingsController extends _$HifzSettingsController {
  @override
  Future<HifzSettings> build() async {
    final repository = await ref.watch(hifzRepositoryProvider.future);
    return repository.getSettings();
  }

  Future<void> save(HifzSettings settings) async {
    final repository = await ref.read(hifzRepositoryProvider.future);
    await repository.saveSettings(settings);
    state = AsyncData(settings);
  }

  Future<void> updateSettings({
    HifzVerificationMode? verificationMode,
    int? attemptsBeforeHint,
    int? hintDelaySeconds,
    int? listenRepeats,
    int? ayahsPerSession,
    bool? hideVisibleDiacritics,
    bool? playCorrectOnError,
    bool? beginnerMode,
    bool? smartStrictness,
    bool? nightMode,
  }) async {
    final current = state.valueOrNull ?? HifzSettings.defaults();
    final next = HifzSettings()
      ..id = 1
      ..setVerificationMode(
        verificationMode ?? current.readVerificationMode(),
      )
      ..attemptsBeforeHint = attemptsBeforeHint ?? current.attemptsBeforeHint
      ..hintDelaySeconds = hintDelaySeconds ?? current.hintDelaySeconds
      ..listenRepeats = listenRepeats ?? current.listenRepeats
      ..ayahsPerSession = ayahsPerSession ?? current.ayahsPerSession
      ..hideVisibleDiacritics =
          hideVisibleDiacritics ?? current.hideVisibleDiacritics
      ..playCorrectOnError = playCorrectOnError ?? current.playCorrectOnError
      ..beginnerMode = beginnerMode ?? current.beginnerMode
      ..smartStrictness = smartStrictness ?? current.smartStrictness
      ..nightMode = nightMode ?? current.nightMode;

    await save(next);
  }
}
