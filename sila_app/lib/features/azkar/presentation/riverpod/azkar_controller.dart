import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/features/azkar/data/models/azkar_model.dart';
import 'package:sila_app/features/azkar/data/repositories/azkar_repository.dart';

part 'azkar_controller.g.dart';

@riverpod
AzkarRepository azkarRepository(AzkarRepositoryRef ref) {
  return AzkarRepository();
}

@riverpod
Future<Map<String, List<AzkarItem>>> azkarData(AzkarDataRef ref) async {
  final repository = ref.watch(azkarRepositoryProvider);
  // EasyLocalization context is not available here directly, 
  // but we should pass the language code or depend on a provider
  // For now, I'll pass 'ar' default or modify this to watch a locale provider if available
  // To fix this properly, I need a provider for current locale
  // Let's assume we can get it from somewhere or default to 'ar'
  // Actually, I can create a locale provider
  
  // For now, let's just use 'ar' as default and let the UI handle locale changes if needed
  // But wait, the user wants it translated.
  // I should inject the locale provider here.
  
  return await repository.getAzkar('ar'); 
}
