import 'package:isar/isar.dart';
import 'package:sila_app/features/wird/data/models/wird_settings.dart';
import 'package:sila_app/features/wird/data/models/wird_history.dart';

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

  Future<List<WirdHistory>> getHistory() async {
    return await _isar.wirdHistorys.where().sortByDateDesc().findAll();
  }

  Future<void> updateCurrentPage(int page) async {
    final settings = await getSettings();
    settings.currentPage = page;
    
    await _isar.writeTxn(() async {
      await _isar.wirdSettings.put(settings);
    });
  }

  Future<void> updateBookmark(int page) async {
    final settings = await getSettings();
    settings.bookmarkPage = page;
    
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

  Future<void> completeDailyWird(int startPage, int endPage) async {
    final settings = await getSettings();
    settings.lastCompletionDate = DateTime.now();
    settings.currentPage = endPage; // Advance current page
    
    final history = WirdHistory()
      ..date = DateTime.now()
      ..startPage = startPage
      ..endPage = endPage
      ..isFullCompletion = true;

    await _isar.writeTxn(() async {
      await _isar.wirdSettings.put(settings);
      await _isar.wirdHistorys.put(history);
    });
  }

  Future<void> resetKhatma() async {
    final settings = await getSettings();
    
    settings.currentPage = 1;
    settings.khatmaStartDate = DateTime.now();
    settings.lastCompletionDate = null;
    
    await _isar.writeTxn(() async {
      await _isar.wirdSettings.put(settings);
      // Optional: Clear history on reset? Usually no, but for now we leave it.
    });
  }
}
