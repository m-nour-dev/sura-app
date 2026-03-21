import 'package:isar/isar.dart';
import 'package:sila_app/features/ibadah_tracker/data/models/ibadah_record.dart';
import 'package:sila_app/features/ibadah_tracker/data/models/user_gender_prefs.dart';
import 'package:sila_app/features/ibadah_tracker/data/repositories/i_ibadah_repository.dart';

class IsarIbadahRepository implements IIbadahRepository {
  IsarIbadahRepository(this._isar);

  final Isar _isar;

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  Future<IbadahRecord> getOrCreateRecord(DateTime date) async {
    final normalized = _normalize(date);
    final existing =
        await _isar.ibadahRecords.filter().dateEqualTo(normalized).findFirst();
    if (existing != null) return existing;

    final record = IbadahRecord.freshFor(normalized);
    await _isar.writeTxn(() async {
      await _isar.ibadahRecords.put(record);
    });
    return record;
  }

  @override
  Future<IbadahRecord?> getRecord(DateTime date) {
    final normalized = _normalize(date);
    return _isar.ibadahRecords.filter().dateEqualTo(normalized).findFirst();
  }

  @override
  Future<DateTime?> getFirstRecordDate() async {
    final first = await _isar.ibadahRecords.where().sortByDate().findFirst();
    return first?.date;
  }

  @override
  Future<List<IbadahRecord>> getRecordsInRange({
    required DateTime start,
    required DateTime end,
  }) async {
    final s = _normalize(start);
    final e = _normalize(end);
    return _isar.ibadahRecords
        .filter()
        .dateBetween(s, e, includeLower: true, includeUpper: true)
        .sortByDate()
        .findAll();
  }

  @override
  Future<void> saveRecord(IbadahRecord record) async {
    record.lastUpdated = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.ibadahRecords.put(record);
    });
  }

  @override
  Future<void> updatePrayerStatus({
    required DateTime date,
    required String prayer,
    required int status,
  }) async {
    final record = await getOrCreateRecord(date);
    var handled = true;
    switch (prayer) {
      case 'fajr':
        record.fajrStatus = status;
        break;
      case 'dhuhr':
        record.dhuhrStatus = status;
        break;
      case 'asr':
        record.asrStatus = status;
        break;
      case 'maghrib':
        record.maghribStatus = status;
        break;
      case 'isha':
        record.ishaStatus = status;
        break;
      default:
        handled = false;
    }
    if (!handled) {
      throw ArgumentError.value(prayer, 'prayer', 'Unknown prayer key');
    }
    await saveRecord(record);
  }

  @override
  Future<void> updateMasjidStatus({
    required DateTime date,
    required String prayer,
    required bool inMasjid,
  }) async {
    final record = await getOrCreateRecord(date);
    switch (prayer) {
      case 'fajr':
        record.fajrInMasjid = inMasjid;
        break;
      case 'dhuhr':
        record.dhuhrInMasjid = inMasjid;
        break;
      case 'asr':
        record.asrInMasjid = inMasjid;
        break;
      case 'maghrib':
        record.maghribInMasjid = inMasjid;
        break;
      case 'isha':
        record.ishaInMasjid = inMasjid;
        break;
    }
    await saveRecord(record);
  }

  @override
  Future<void> updateBoolStatus({
    required DateTime date,
    required String key,
    required bool value,
  }) async {
    final record = await getOrCreateRecord(date);
    var handled = true;
    switch (key) {
      case 'wird':
        record.readWird = value;
        break;
      case 'azkar_sabah':
        record.readAzkarSabah = value;
        break;
      case 'azkar_masa':
        record.readAzkarMasa = value;
        break;
      case 'tasbih':
        record.didTasbih = value;
        break;
      case 'hifz':
        record.didHifz = value;
        break;
      case 'tasmi':
        record.didTasmi = value;
        break;
      case 'dhikr':
        record.rememberedAllah = value;
        break;
      default:
        handled = false;
    }
    if (!handled) {
      throw ArgumentError.value(key, 'key', 'Unknown status key');
    }
    await saveRecord(record);
  }

  @override
  Future<void> updatePersonalNote(
      {required DateTime date, required String? note}) async {
    final record = await getOrCreateRecord(date);
    record.personalNote = note;
    await saveRecord(record);
  }

  @override
  Future<UserGenderPrefs?> getGenderPrefs() {
    return _isar.userGenderPrefs.where().sortByCreatedAtDesc().findFirst();
  }

  @override
  Future<void> setGenderPrefs({required bool isMale}) async {
    final existing = await getGenderPrefs();
    final value = existing ?? UserGenderPrefs()
      ..createdAt = DateTime.now();
    value
      ..isMale = isMale
      ..onboardingDone = true;

    await _isar.writeTxn(() async {
      await _isar.userGenderPrefs.put(value);
    });
  }
}
