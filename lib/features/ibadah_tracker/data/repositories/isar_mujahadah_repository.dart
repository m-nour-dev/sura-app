import 'package:isar/isar.dart';
import 'package:sila_app/features/ibadah_tracker/data/models/mujahadah_record.dart';

class IsarMujahadahRepository {
  IsarMujahadahRepository(this._isar);
  final Isar _isar;

  Future<List<MujahadahRecord>> getAllRecords() async {
    return _isar.mujahadahRecords.where().findAll();
  }

  Future<void> addHabit(String title) async {
    final existing = await _isar.mujahadahRecords
        .filter()
        .titleEqualTo(title)
        .findFirst();

    if (existing != null) return; // Habit already tracked

    final record = MujahadahRecord()
      ..title = title
      ..startDate = DateTime.now()
      ..currentStreak = 0
      ..longestStreak = 0
      ..lastRelapseDate = null
      ..lastCheckInDate = null;

    await _isar.writeTxn(() async {
      await _isar.mujahadahRecords.put(record);
    });
  }

  Future<void> removeHabit(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.mujahadahRecords.delete(id);
    });
  }

  Future<void> recordSuccess(Id id) async {
    final record = await _isar.mujahadahRecords.get(id);
    if (record == null) return;

    final now = DateTime.now();

    // Only allow one check-in per day (logic based on calendar day)
    if (record.lastCheckInDate != null) {
      final last = record.lastCheckInDate!;
      if (last.year == now.year &&
          last.month == now.month &&
          last.day == now.day) {
        return; // Already checked in today
      }
    }

    record.currentStreak += 1;
    if (record.currentStreak > record.longestStreak) {
      record.longestStreak = record.currentStreak;
    }
    record.lastCheckInDate = now;

    await _isar.writeTxn(() async {
      await _isar.mujahadahRecords.put(record);
    });
  }

  Future<void> recordMinorSlip(Id id) async {
    final record = await _isar.mujahadahRecords.get(id);
    if (record == null) return;

    final now = DateTime.now();

    // Only allow one check-in per day
    if (record.lastCheckInDate != null) {
      final last = record.lastCheckInDate!;
      if (last.year == now.year &&
          last.month == now.month &&
          last.day == now.day) {
        return; // Already checked in today
      }
    }

    // Minor slip: We DO NOT increment currentStreak, but we DO NOT reset it.
    // We just register the check-in for today.
    record.lastCheckInDate = now;

    await _isar.writeTxn(() async {
      await _isar.mujahadahRecords.put(record);
    });
  }

  Future<void> recordRelapse(Id id) async {
    final record = await _isar.mujahadahRecords.get(id);
    if (record == null) return;

    final now = DateTime.now();

    // Ensure we capture the longest streak before resetting
    if (record.currentStreak > record.longestStreak) {
      record.longestStreak = record.currentStreak;
    }

    record.currentStreak = 0;
    record.lastRelapseDate = now;
    // Clearing lastCheckInDate so they can check in immediately if they want,
    // though conceptually relapse is negative check-in, keeping it null makes sense
    record.lastCheckInDate = null;

    await _isar.writeTxn(() async {
      await _isar.mujahadahRecords.put(record);
    });
  }
}
