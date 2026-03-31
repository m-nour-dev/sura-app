import 'package:isar/isar.dart';

part 'notification_content.g.dart';

@collection
class NotificationContent {
  Id id = Isar.autoIncrement;

  late String contentId;
  late String category;
  late String type;
  late String arabicText;
  late String source;
  late String grade;

  String? sourceTr;
  String? gradeTr;
  String? shortExplanationTr;

  String shortExplanation = '';
  List<String> triggerTags = <String>[];
  List<String> seasonTags = <String>['عام'];
  int surahNumber = 0;
  int ayahNumber = 0;
  int shownCount = 0;
  DateTime? lastShown;
  bool isFavorited = false;

  /// Returns the notification text for the given language code.
  String getTextForLang(String lang) {
    if (lang == 'tr' &&
        shortExplanationTr != null &&
        shortExplanationTr!.isNotEmpty) {
      return shortExplanationTr!;
    }
    if (lang == 'ar' && arabicText.isNotEmpty) {
      return arabicText;
    }
    if (shortExplanation.isNotEmpty) {
      return shortExplanation;
    }
    return arabicText;
  }
}
