import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sila_app/features/azkar/data/models/azkar_model.dart';

class AzkarRepository {
  Future<Map<String, List<AzkarItem>>> getAzkar() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/azkar.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      
      final Map<String, List<AzkarItem>> result = {};
      
      jsonMap.forEach((key, value) {
        if (value is List) {
          result[key] = value.map((e) => AzkarItem.fromJson(e)).toList();
        }
      });
      
      return result;
    } catch (e) {
      print("Error loading Azkar: $e");
      return {};
    }
  }
}
