import 'package:isar/isar.dart';

part 'mujahadah_record.g.dart';

@collection
class MujahadahRecord {
  Id id = Isar.autoIncrement;

  /// اسم الذنب أو العادة التي يريد المستخدم التخلص منها
  @Index(unique: true, replace: true)
  late String title;

  /// تاريخ التسجيل الأصلي (عندما قرر تركها لأول مرة)
  late DateTime startDate;

  /// أفضل إنجاز حققه (أطول مدة صمود بالأيام)
  int longestStreak = 0;

  /// العداد الحالي للصمود (يزيد فقط إذا ضغط المستخدم "صمدت اليوم")
  int currentStreak = 0;

  /// آخر مرة سجل فيها انكساره أو زلّته، ليتم تصفير العداد من بعدها
  DateTime? lastRelapseDate;

  /// آخر يوم قام فيه بالتأكيد على توبته بالضغط على "صمدت اليوم"
  DateTime? lastCheckInDate;
}
