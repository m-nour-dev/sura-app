import 'package:isar/isar.dart';
import 'package:sila_app/features/hifz/data/models/hifz_moment.dart';
import 'package:sila_app/features/hifz/data/models/hifz_session.dart';
import 'package:sila_app/features/hifz/data/models/hifz_user_profile.dart';
import 'package:sila_app/features/hifz/data/models/hifz_verse_record.dart';
import 'package:sila_app/features/hifz/data/repositories/i_hifz_repository.dart';

class IsarHifzRepository implements IHifzRepository {
  late final Isar _isar;

  IsarHifzRepository(Isar isar) {
    _isar = isar;
  }

  @override
  Future<HifzUserProfile?> getProfile() async {
    return await _isar.hifzUserProfiles.where().sortByCreatedAtDesc().findFirst();
  }

  @override
  Future<void> saveProfile(HifzUserProfile profile) async {
    await _isar.writeTxn(() async {
      await _isar.hifzUserProfiles.put(profile);
    });
  }

  @override
  Future<HifzVerseRecord?> getVerseRecord(int surahIndex, int verseNumber) async {
    return await _isar.hifzVerseRecords
        .filter()
        .surahIndexEqualTo(surahIndex)
        .verseNumberEqualTo(verseNumber)
        .findFirst();
  }

  @override
  Future<List<HifzVerseRecord>> getAllRecords() async {
    return await _isar.hifzVerseRecords.where().findAll();
  }

  @override
  Future<List<HifzVerseRecord>> getDueReviews(DateTime before) async {
    return await _isar.hifzVerseRecords
        .filter()
        .nextReviewDateLessThan(before, include: true)
        .findAll();
  }

  @override
  Future<void> saveVerseRecord(HifzVerseRecord record) async {
    await _isar.writeTxn(() async {
      await _isar.hifzVerseRecords.put(record);
    });
  }

  @override
  Future<void> saveSession(HifzSession session) async {
    await _isar.writeTxn(() async {
      await _isar.hifzSessions.put(session);
    });
  }

  @override
  Future<List<HifzSession>> getRecentSessions(int limit) async {
    return await _isar.hifzSessions.where().sortByDateDesc().limit(limit).findAll();
  }

  @override
  Future<void> saveMoment(HifzMoment moment) async {
    await _isar.writeTxn(() async {
      await _isar.hifzMoments.put(moment);
    });
  }

  @override
  Future<List<HifzMoment>> getRecentMoments(int limit) async {
    return await _isar.hifzMoments.where().sortByCreatedAtDesc().limit(limit).findAll();
  }

  // TODO[phase-2: CloudSync]:
  //   Add uploadToCloud(String userId) for
  //   cross-device progress sync
}
