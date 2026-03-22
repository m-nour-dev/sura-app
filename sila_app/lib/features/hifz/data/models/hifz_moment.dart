import 'package:isar/isar.dart';

part 'hifz_moment.g.dart';

@collection
class HifzMoment {
  Id id = Isar.autoIncrement;

  late int surahIndex;
  late int verseNumber;
  late String reflection;
  late String feeling;
  late DateTime createdAt;
}
