import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sila_app/core/services/analytics_service.dart';
import 'package:sila_app/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:sila_app/features/quran/data/repositories/quran_repository_impl.dart';
import 'package:sila_app/features/quran/domain/entities/surah.dart';
import 'package:sila_app/features/quran/domain/repositories/quran_repository.dart';
import 'package:sila_app/features/quran/domain/usecases/get_surah_detail.dart';
import 'package:sila_app/features/quran/domain/usecases/get_surahs.dart';

part 'quran_controller.g.dart';

// 1. Data Source Provider
@riverpod
QuranLocalDataSource quranLocalDataSource(QuranLocalDataSourceRef ref) {
  return QuranLocalDataSourceImpl(assetBundle: rootBundle);
}

// 2. Repository Provider
@riverpod
QuranRepository quranRepository(QuranRepositoryRef ref) {
  final localDataSource = ref.watch(quranLocalDataSourceProvider);
  return QuranRepositoryImpl(localDataSource: localDataSource);
}

// 3. UseCase Provider
@riverpod
GetSurahs getSurahs(GetSurahsRef ref) {
  final repository = ref.watch(quranRepositoryProvider);
  return GetSurahs(repository);
}

// 4. Controller (AsyncNotifier)
@riverpod
class QuranController extends _$QuranController {
  @override
  FutureOr<List<Surah>> build() async {
    final getSurahsUserCase = ref.watch(getSurahsProvider);
    final result = await getSurahsUserCase();

    return result.fold(
      (failure) => throw failure,
      (surahs) => surahs,
    );
  }
}

// 5. UseCase Provider for Details
@riverpod
GetSurahDetail getSurahDetail(GetSurahDetailRef ref) {
  final repository = ref.watch(quranRepositoryProvider);
  return GetSurahDetail(repository);
}

// 6. Detail Controller (Family AsyncNotifier)
@riverpod
class SurahDetailController extends _$SurahDetailController {
  @override
  FutureOr<Surah> build(int surahNumber) async {
    final getSurahDetailUseCase = ref.watch(getSurahDetailProvider);
    final result = await getSurahDetailUseCase(surahNumber);

    return result.fold(
      (failure) => throw failure,
      (surah) {
        ref.read(analyticsServiceProvider).logQuranSurahOpen(
              surahName: surah.nameArabic,
              surahNumber: surah.number,
            );
        return surah;
      },
    );
  }
}
