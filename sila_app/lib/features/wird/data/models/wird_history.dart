import 'package:isar/isar.dart';

part 'wird_history.g.dart';

@collection
class WirdHistory {
  Id id = Isar.autoIncrement;

  @Index()
  DateTime date = DateTime.now();

  int startPage = 0;
  int endPage = 0;
  
  // Optional: Store surah names for display in history
  String? description; 

  // Whether this was a full completion or just a partial read
  bool isFullCompletion = true;
}
