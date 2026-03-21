import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sila_app/features/hifz/data/models/hifz_moment.dart';
import 'package:sila_app/features/hifz/data/models/hifz_session.dart';
import 'package:sila_app/features/hifz/data/models/hifz_user_profile.dart';
import 'package:sila_app/features/hifz/data/models/hifz_verse_record.dart';
import 'package:sila_app/features/notifications/data/models/notification_content.dart';
import 'package:sila_app/features/notifications/data/models/notification_settings.dart';
import 'package:sila_app/features/notifications/data/models/user_activity_log.dart';
import 'package:sila_app/features/tasmi/data/models/tasmi_word_error.dart';
import 'package:sila_app/features/vefa/data/models/vefa_person_model.dart';
import 'package:sila_app/features/wird/data/models/wird_settings.dart';
import 'package:sila_app/features/wird/data/models/wird_history.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
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
          NotificationContentSchema,
          NotificationSettingsSchema,
          UserActivityLogSchema,
        ],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
