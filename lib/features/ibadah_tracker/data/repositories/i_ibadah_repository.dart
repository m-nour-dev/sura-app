import 'package:sura_app/features/ibadah_tracker/data/models/ibadah_record.dart';
import 'package:sura_app/features/ibadah_tracker/data/models/user_gender_prefs.dart';

abstract class IIbadahRepository {
  Future<IbadahRecord> getOrCreateRecord(DateTime date);
  Future<IbadahRecord?> getRecord(DateTime date);
  Future<DateTime?> getFirstRecordDate();
  Future<List<IbadahRecord>> getRecordsInRange({
    required DateTime start,
    required DateTime end,
  });

  Future<void> saveRecord(IbadahRecord record);
  Future<void> updatePrayerStatus({
    required DateTime date,
    required String prayer,
    required int status,
  });
  Future<void> updateMasjidStatus({
    required DateTime date,
    required String prayer,
    required bool inMasjid,
  });
  Future<void> updateBoolStatus({
    required DateTime date,
    required String key,
    required bool value,
  });
  Future<void> updatePersonalNote(
      {required DateTime date, required String? note});

  Future<UserGenderPrefs?> getGenderPrefs();
  Future<void> setGenderPrefs({required bool isMale});
}

