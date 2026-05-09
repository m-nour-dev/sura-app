import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sura_app/features/azkar/data/models/azkar_model.dart';
import 'package:sura_app/features/azkar/data/repositories/azkar_repository.dart';
import 'package:sura_app/features/quran/presentation/riverpod/quran_data_provider.dart';

part 'azkar_controller.g.dart';

@riverpod
AzkarRepository azkarRepository(AzkarRepositoryRef ref) {
  return AzkarRepository();
}

@riverpod
Future<Map<String, List<AzkarItem>>> azkarData(AzkarDataRef ref) async {
  final repository = ref.watch(azkarRepositoryProvider);
  final locale = ref.watch(appLocaleProvider);
  return await repository.getAzkar(locale.languageCode);
}

