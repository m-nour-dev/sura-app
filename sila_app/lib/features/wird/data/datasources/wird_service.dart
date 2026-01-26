import 'package:isar/isar.dart';
import 'package:sila_app/features/wird/data/models/wird_settings.dart';

class WirdService {
  final Isar _isar;

  WirdService(this._isar);

  Future<WirdSettings> getSettings() async {
    final settings = await _isar.wirdSettings.where().findFirst();
    
    if (settings == null) {
      // Create default settings
      final newSettings = WirdSettings()
        ..currentPage = 1
        ..pagesPerDay = 2
        ..khatmaStartDate = DateTime.now();
      
      await _isar.writeTxn(() async {
        await _isar.wirdSettings.put(newSettings);
      });
      return newSettings;
    }
    
    return settings;
  }

  Future<void> updateCurrentPage(int page) async {
    final settings = await getSettings();
    settings.currentPage = page;
    
    await _isar.writeTxn(() async {
      await _isar.wirdSettings.put(settings);
    });
  }

  Future<void> updatePagesPerDay(int pages) async {
    final settings = await getSettings();
    settings.pagesPerDay = pages;
    
    await _isar.writeTxn(() async {
      await _isar.wirdSettings.put(settings);
    });
  }

  Future<void> completeDailyWird() async {
    final settings = await getSettings();
    settings.lastCompletionDate = DateTime.now();
    
    await _isar.writeTxn(() async {
      await _isar.wirdSettings.put(settings);
    });
  }

  Future<void> resetKhatma() async {
    final settings = await getSettings();
    
    settings.currentPage = 1;
    settings.khatmaStartDate = DateTime.now();
    settings.lastCompletionDate = null;
    
    await _isar.writeTxn(() async {
      await _isar.wirdSettings.put(settings);
    });
  }
}
