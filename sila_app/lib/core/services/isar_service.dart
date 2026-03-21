import 'dart:async';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sila_app/features/hifz/data/models/hifz_moment.dart';
import 'package:sila_app/features/hifz/data/models/hifz_session.dart';
import 'package:sila_app/features/hifz/data/models/hifz_user_profile.dart';
import 'package:sila_app/features/hifz/data/models/hifz_verse_record.dart';
import 'package:sila_app/features/ibadah_tracker/data/models/ibadah_record.dart';
import 'package:sila_app/features/ibadah_tracker/data/models/user_gender_prefs.dart';
import 'package:sila_app/features/notifications/data/models/notification_content.dart';
import 'package:sila_app/features/notifications/data/models/notification_settings.dart';
import 'package:sila_app/features/notifications/data/models/user_activity_log.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_word_error.dart';
import 'package:sila_app/features/vefa/data/models/vefa_person_model.dart';
import 'package:sila_app/features/wird/data/models/wird_settings.dart';
import 'package:sila_app/features/wird/data/models/wird_history.dart';

class IsarService {
  static IsarService? _instance;
  factory IsarService() => _instance ??= IsarService._internal();
  IsarService._internal();

  static Future<Isar>? _dbFuture;

  Future<Isar> get db {
    _dbFuture ??= _openWithRetry().catchError((Object e, StackTrace st) {
      _dbFuture = null;
      throw e;
    });
    return _dbFuture!;
  }

  Future<Isar> _openWithRetry() async {
    for (var attempt = 0; attempt < 20; attempt++) {
      try {
        final existing = Isar.getInstance();
        if (existing != null) return existing;

        final dir = await getApplicationDocumentsDirectory();
        return await Isar.open(
          [
            VefaPersonModelSchema,
            WirdSettingsSchema,
            WirdHistorySchema,
            TasmiWordErrorSchema,
            HifzUserProfileSchema,
            HifzVerseRecordSchema,
            HifzSessionSchema,
            HifzMomentSchema,
            IbadahRecordSchema,
            UserGenderPrefsSchema,
            NotificationContentSchema,
            NotificationSettingsSchema,
            UserActivityLogSchema,
          ],
          directory: dir.path,
          inspector: true,
        );
      } catch (e) {
        final msg = e.toString();
        if (msg.contains('MdbxError (11)')) {
          await Future<void>.delayed(Duration(milliseconds: 150 * (attempt + 1)));
          continue;
        }
        rethrow;
      }
    }

    throw StateError('Isar initialization retry limit reached');
  }

  Future<void> closeDB() async {
    final db = Isar.getInstance();
    if (db != null) {
      await db.close();
    }
    _dbFuture = null;
  }
}
