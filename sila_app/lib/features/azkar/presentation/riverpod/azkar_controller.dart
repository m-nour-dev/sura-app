import 'package:intl/intl.dart';
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
  
  // Get current locale and determine language code
  final languageCode = Intl.getCurrentLocale();
  final isTurkish = languageCode.startsWith('tr');
  
  // Load Turkish azkar if user is in Turkish locale, otherwise Arabic
  final locale = isTurkish ? 'tr' : 'ar';
  
  return await repository.getAzkar(locale); 
}
