import 'package:sura_app/features/hifz/data/models/hifz_session.dart';
import 'package:sura_app/features/hifz/data/models/hifz_settings.dart';
import 'package:sura_app/features/hifz/data/models/hifz_user_profile.dart';
import 'package:sura_app/features/hifz/data/models/hifz_verse_record.dart';

abstract class IHifzRepository {
  Future<HifzUserProfile?> getProfile();
  Future<void> saveProfile(HifzUserProfile profile);

  Future<HifzVerseRecord?> getVerseRecord(int surahIndex, int verseNumber);
  Future<List<HifzVerseRecord>> getAllRecords();
  Future<List<HifzVerseRecord>> getDueReviews(DateTime before);
  Future<void> saveVerseRecord(HifzVerseRecord record);

  Future<void> saveSession(HifzSession session);
  Future<List<HifzSession>> getRecentSessions(int limit);



  Future<HifzSettings> getSettings();
  Future<void> saveSettings(HifzSettings settings);
}

