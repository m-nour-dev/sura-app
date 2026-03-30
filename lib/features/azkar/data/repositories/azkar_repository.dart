import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sila_app/features/azkar/data/models/azkar_model.dart';
import 'package:flutter/foundation.dart';

class AzkarRepository {
  Future<Map<String, List<AzkarItem>>> getAzkar(String languageCode) async {
    try {
      String fileName;
      switch (languageCode) {
        case 'tr':
          fileName = 'azkar_tr.json';
          break;
        case 'en':
          fileName = 'azkar_en.json';
          break;
        case 'fr':
          fileName = 'azkar_fr.json';
          break;
        default:
          fileName = 'azkar.json';
      }
      final jsonString = await rootBundle.loadString('assets/data/$fileName');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      final result = <String, List<AzkarItem>>{};

      jsonMap.forEach((key, value) {
        if (value is List) {
          result[key] = value.map((e) => AzkarItem.fromJson(e)).toList();
        }
      });

      return result;
    } catch (e) {
      // Fallback to Arabic if specific language file fails
      if (languageCode != 'ar') {
        return getAzkar('ar');
      }
      debugPrint('Error loading Azkar ($languageCode): $e');
      return {};
    }
  }
}
