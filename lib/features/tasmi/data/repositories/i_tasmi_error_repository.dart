import 'package:sila_app/features/tasmi/data/models/tasmi_word_error.dart';

abstract class ITasmiErrorRepository {
  Future<void> saveError(TasmiWordError error);
  Future<List<TasmiWordError>> getAll();
  Future<List<TasmiWordError>> getBySurah(int surahIndex);
  Future<void> clearAll();
}
