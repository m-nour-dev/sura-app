import 'package:isar/isar.dart';

part 'ibadah_record.g.dart';

@collection
class IbadahRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date;

  late int fajrStatus;
  late int dhuhrStatus;
  late int asrStatus;
  late int maghribStatus;
  late int ishaStatus;

  late bool? fajrInMasjid;
  late bool? dhuhrInMasjid;
  late bool? asrInMasjid;
  late bool? maghribInMasjid;
  late bool? ishaInMasjid;

  late bool readWird;
  late bool readAzkarSabah;
  late bool readAzkarMasa;
  late bool didTasbih;
  late bool didHifz;
  late bool didTasmi;
  late bool rememberedAllah;

  late String? personalNote;
  late DateTime lastUpdated;

  static IbadahRecord freshFor(DateTime rawDate) {
    final date = DateTime(rawDate.year, rawDate.month, rawDate.day);
    return IbadahRecord()
      ..date = date
      ..fajrStatus = 0
      ..dhuhrStatus = 0
      ..asrStatus = 0
      ..maghribStatus = 0
      ..ishaStatus = 0
      ..fajrInMasjid = null
      ..dhuhrInMasjid = null
      ..asrInMasjid = null
      ..maghribInMasjid = null
      ..ishaInMasjid = null
      ..readWird = false
      ..readAzkarSabah = false
      ..readAzkarMasa = false
      ..didTasbih = false
      ..didHifz = false
      ..didTasmi = false
      ..rememberedAllah = false
      ..personalNote = null
      ..lastUpdated = DateTime.now();
  }
}
