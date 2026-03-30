import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/core/models/reciter_settings.dart';
import 'package:sila_app/core/services/reciter_service.dart';
import 'package:sila_app/features/vefa/presentation/riverpod/vefa_providers.dart';

part 'reciter_provider.g.dart';

@riverpod
class ReciterController extends _$ReciterController {
  @override
  Future<ReciterModel> build() async {
    final isar = await ref.watch(isarInstanceProvider.future);
    final settings = await isar.reciterSettings.get(1);

    final id = settings?.selectedReciterId ?? ReciterService.defaultReciterId;
    return ReciterService.getById(id);
  }

  Future<void> selectReciter(String reciterId) async {
    final isar = await ref.watch(isarInstanceProvider.future);

    await isar.writeTxn(() async {
      await isar.reciterSettings.put(
        ReciterSettings()
          ..id = 1
          ..selectedReciterId = reciterId
          ..updatedAt = DateTime.now(),
      );
    });

    ref.invalidateSelf();
  }

  String buildAyahUrl(int surahNumber, int ayahNumber) {
    final reciter = state.valueOrNull ??
        ReciterService.getById(ReciterService.defaultReciterId);
    return reciter.buildAyahUrl(surahNumber, ayahNumber);
  }
}
