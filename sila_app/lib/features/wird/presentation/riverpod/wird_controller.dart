import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/features/vefa/presentation/riverpod/vefa_providers.dart';
import 'package:sila_app/features/wird/data/datasources/wird_service.dart';
import 'package:sila_app/features/wird/data/models/wird_settings.dart';
import 'package:sila_app/features/wird/data/models/wird_history.dart';

// Provider for WirdService
final wirdServiceProvider = FutureProvider<WirdService>((ref) async {
  final isar = await ref.watch(isarInstanceProvider.future);
  return WirdService(isar);
});

// State class for the Wird
class WirdState {
  final int currentPage;
  final int pagesPerDay;
  final int targetPage;
  final bool isCompletedToday;
  final DateTime? khatmaStart;
  final int daysDifference; // +ve means ahead, -ve means behind
  final double khatmaProgress;
  final List<WirdHistory> history;
  final int completedWirdsCount;
  final int remainingWirdsCount;
  final int? bookmarkPage;

  WirdState({
    required this.currentPage,
    required this.pagesPerDay,
    required this.targetPage,
    required this.isCompletedToday,
    this.khatmaStart,
    required this.daysDifference,
    required this.khatmaProgress,
    required this.history,
    required this.completedWirdsCount,
    required this.remainingWirdsCount,
    this.bookmarkPage,
  });

  // Helper to calculate progress text
  String get progressText => 'من صفحة $currentPage إلى صفحة $targetPage';
}

// Controller
class WirdController extends StateNotifier<AsyncValue<WirdState>> {
  final WirdService _service;
  final Ref _ref;

  WirdController(this._service, this._ref) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _service.getSettings();
      final history = await _service.getHistory();
      final now = DateTime.now();
      
      // Check if completed today
      bool completed = false;
      if (settings.lastCompletionDate != null) {
        final last = settings.lastCompletionDate!;
        if (last.year == now.year && last.month == now.month && last.day == now.day) {
          completed = true;
        }
      }

      // Calculate Khatma Status
      int daysDifference = 0;
      double progress = 0.0;
      int completedWirds = 0;
      int remainingWirds = 0;
      
      if (settings.pagesPerDay > 0) {
        // Calculation logic as discussed with user:
        // Completed = pages read so far / pages per day
        completedWirds = ((settings.currentPage - 1) / settings.pagesPerDay).floor();
        
        final totalWirds = (WirdSettings.totalQuranPages / settings.pagesPerDay).ceil();
        remainingWirds = totalWirds - completedWirds;

        if (settings.khatmaStartDate != null) {
          final daysSinceStart = now.difference(settings.khatmaStartDate!).inDays; 
          final expectedPage = (daysSinceStart + 1) * settings.pagesPerDay;
          final pageDiff = settings.currentPage - expectedPage;
          daysDifference = (pageDiff / settings.pagesPerDay).floor();
        }
        
        progress = settings.currentPage / WirdSettings.totalQuranPages;
      }

      state = AsyncValue.data(WirdState(
        currentPage: settings.currentPage,
        pagesPerDay: settings.pagesPerDay,
        targetPage: settings.targetPageForToday,
        isCompletedToday: completed,
        khatmaStart: settings.khatmaStartDate,
        daysDifference: daysDifference,
        khatmaProgress: progress,
        history: history,
        completedWirdsCount: completedWirds,
        remainingWirdsCount: remainingWirds,
        bookmarkPage: settings.bookmarkPage,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePagesPerDay(int pages) async {
    await _service.updatePagesPerDay(pages);
    await _loadSettings();
  }

  Future<void> updateCurrentPage(int page) async {
    if (state.value?.currentPage != page) {
      await _service.updateCurrentPage(page);
      _ref.read(analyticsServiceProvider).logWirdPageRead(pageNumber: page);
      await _loadSettings();
    }
  }

  Future<void> updateBookmark(int page) async {
    await _service.updateBookmark(page);
    await _loadSettings();
  }

  Future<void> completeWird(int startPage, int endPage) async {
    await _service.completeDailyWird(startPage, endPage);
    if (endPage >= 604) {
      _ref.read(analyticsServiceProvider).logWirdKhatmaComplete();
    }
    await _loadSettings();
  }

  Future<void> startNewKhatma() async {
    // Save the last portion if not already saved (assuming it was)
    // Reset reading progress to page 1
    await _service.updateCurrentPage(1);
    
    // Optionally, we could record a 'Khatma Completed' event in history here.
    
    await _loadSettings();
  }
}

// Global Provider
final wirdControllerProvider = StateNotifierProvider<WirdController, AsyncValue<WirdState>>((ref) {
  final asyncService = ref.watch(wirdServiceProvider);
  return asyncService.maybeWhen(
    data: (service) => WirdController(service, ref),
    orElse: () => WirdController(_FallbackWirdService(), ref),
  );
});

class _FallbackWirdService implements WirdService {
  @override
  Future<void> completeDailyWird(int startPage, int endPage) async {}

  @override
  Future<List<WirdHistory>> getHistory() async => <WirdHistory>[];

  @override
  Future<WirdSettings> getSettings() async => WirdSettings();

  @override
  Future<void> updateBookmark(int page) async {}

  @override
  Future<void> updateCurrentPage(int page) async {}

  @override
  Future<void> updatePagesPerDay(int pagesPerDay) async {}

  @override
  Future<void> resetKhatma() async {}
}
