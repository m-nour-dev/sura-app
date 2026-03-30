import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sila_app/core/error/exceptions.dart';
import 'package:sila_app/features/quran/data/models/surah_model.dart'; // Import this for JSON decoding

abstract class QuranLocalDataSource {
  Future<List<SurahModel>> getSurahs();
  Future<SurahModel> getSurahDetail(int number);
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  QuranLocalDataSourceImpl({required this.assetBundle});
  final AssetBundle assetBundle;

  @override
  Future<List<SurahModel>> getSurahs() async {
    try {
      final jsonString =
          await assetBundle.loadString('assets/data/surahs.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => SurahModel.fromJson(json)).toList();
    } catch (e) {
      throw const CacheException('Failed to load local surah data');
    }
  }

  @override
  Future<SurahModel> getSurahDetail(int number) async {
    try {
      final surahs = await getSurahs();
      return surahs.firstWhere((element) => element.number == number);
    } catch (e) {
      throw const CacheException('Surah not found');
    }
  }
}
