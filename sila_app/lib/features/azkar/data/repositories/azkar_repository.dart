import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sila_app/features/azkar/data/models/azkar_model.dart';

class AzkarRepository {
  Future<Map<String, List<AzkarItem>>> getAzkar(String languageCode) async {
    try {
      final String fileName = languageCode == 'tr' ? 'azkar_tr.json' : 'azkar.json';
      final jsonString = await rootBundle.loadString('assets/data/$fileName');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      final Map<String, List<AzkarItem>> result = {};
      
      jsonMap.forEach((key, value) {
        if (value is List) {
          result[key] = value.map((e) => AzkarItem.fromJson(e)).toList();
        }
      });
      
      return result;
    } catch (e) {
      // Fallback to Arabic if Turkish file fails or doesn't exist yet
      if (languageCode == 'tr') {
        return getAzkar('ar');
      }
      print("Error loading Azkar: $e");
      return {};
    }
  }
}
