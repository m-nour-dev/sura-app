import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main() async {
  print('🚀 Starting Quran Data Seeding...');

  // 1. Fetch Meta (Surah Names)
  print('📥 Fetching Surah List...');
  final metaResponse = await http.get(Uri.parse('http://api.alquran.cloud/v1/surah'));
  if (metaResponse.statusCode != 200) throw Exception('Failed to fetch meta');
  final metaData = json.decode(metaResponse.body)['data'] as List;

  // 2. Fetch Text (Uthmani) - Full Quran
  print('📥 Fetching Quran Text (Uthmani)...');
  final textResponse = await http.get(Uri.parse('http://api.alquran.cloud/v1/quran/quran-uthmani'));
  if (textResponse.statusCode != 200) throw Exception('Failed to fetch text');
  final textData = json.decode(textResponse.body)['data']['surahs'] as List;

  // 3. Fetch Translation (Turkish) - Full Quran
  print('📥 Fetching Quran Translation (Turkish)...');
  final trResponse = await http.get(Uri.parse('http://api.alquran.cloud/v1/quran/tr.diyanet'));
  if (trResponse.statusCode != 200) throw Exception('Failed to fetch translation');
  final trData = json.decode(trResponse.body)['data']['surahs'] as List;

  // 4. Merge Data
  print('🔄 Merging Data...');
  final finalSurahs = <Map<String, dynamic>>[];

  for (var i = 0; i < 114; i++) {
    final meta = metaData[i];
    final textSurah = textData[i];
    final trSurah = trData[i];

    final ayahs = <Map<String, dynamic>>[];
    final textAyahs = textSurah['ayahs'] as List;
    final trAyahs = trSurah['ayahs'] as List;

    for (var j = 0; j < textAyahs.length; j++) {
      final textAyah = textAyahs[j];
      final trAyah = trAyahs[j];
      final number = textAyah['numberInSurah'];
      
      // Generate Audio URL (EveryAyah format: surah (3 digits) + ayah (3 digits))
      final surahPad = (i + 1).toString().padLeft(3, '0');
      final ayahPad = number.toString().padLeft(3, '0');
      final audioUrl = 'https://everyayah.com/data/Husary_128kbps/$surahPad$ayahPad.mp3';

      ayahs.add({
        'number': number,
        'text': textAyah['text'],
        'translation': trAyah['text'],
        'audioUrl': audioUrl
      });
    }

    finalSurahs.add({
      'number': meta['number'],
      'nameArabic': meta['name'],
      'nameTurkish': meta['englishName'], // Fallback (API doesn't strictly have Turkish names in this endpoint, usually uses English transliteration)
      'englishName': meta['englishName'],
      'numberOfAyahs': meta['numberOfAyahs'],
      'revelationType': meta['revelationType'],
      'ayahs': ayahs,
    });
  }

  // 5. Write to File
  print('💾 Saving to assets/data/surahs.json...');
  final file = File('assets/data/surahs.json');
  await file.writeAsString(json.encode(finalSurahs));

  print('✅ Done! Successfully seeded ${finalSurahs.length} Surahs.');
}
