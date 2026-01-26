import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sila_app/features/vefa/presentation/riverpod/vefa_providers.dart';
import 'package:sila_app/features/wird/data/datasources/wird_service.dart';
import 'package:sila_app/features/wird/data/models/wird_settings.dart';

// Provider for WirdService
final wirdServiceProvider = Provider<WirdService>((ref) {
  final isarService = ref.watch(isarInstanceProvider).valueOrNull;
  if (isarService == null) throw Exception('Isar not initialized');
  return WirdService(isarService);
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

  WirdState({
    required this.currentPage,
    required this.pagesPerDay,
    required this.targetPage,
    required this.isCompletedToday,
    this.khatmaStart,
    required this.daysDifference,
    required this.khatmaProgress,
  });

  // Helper to calculate progress text
  String get progressText => 'من صفحة $currentPage إلى صفحة $targetPage';
}

// Controller
class WirdController extends StateNotifier<AsyncValue<WirdState>> {
  final WirdService _service;

  WirdController(this._service) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _service.getSettings();
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
      
      if (settings.khatmaStartDate != null && settings.pagesPerDay > 0) {
        final daysSinceStart = now.difference(settings.khatmaStartDate!).inDays + 1; // +1 to include today
        final expectedPage = daysSinceStart * settings.pagesPerDay;
        final pageDiff = settings.currentPage - expectedPage;
        
        // Convert page difference to approximate days
        daysDifference = (pageDiff / settings.pagesPerDay).round();
        
        // Progress percentage
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
    // Only update if changed
    if (state.value?.currentPage != page) {
      await _service.updateCurrentPage(page);
      // We don't reload everything to avoid stutter, just silent update usually,
      // but for simplicity we reload
      await _loadSettings();
    }
  }

  Future<void> completeWird() async {
    await _service.completeDailyWird();
    // After completion, we might want to advance the page automatically?
    // For now, let's just mark complete.
    await _loadSettings();
  }
}

// Global Provider
final wirdControllerProvider = StateNotifierProvider<WirdController, AsyncValue<WirdState>>((ref) {
  final service = ref.watch(wirdServiceProvider);
  return WirdController(service);
});
