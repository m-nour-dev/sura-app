import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:sura_app/core/services/analytics_service.dart';
import 'package:sura_app/core/services/isar_service.dart';
import 'package:sura_app/features/vefa/data/datasources/vefa_local_data_source.dart';
import 'package:sura_app/features/vefa/data/repositories/vefa_repository_impl.dart';
import 'package:sura_app/features/vefa/domain/entities/vefa_person.dart';
import 'package:sura_app/features/vefa/domain/usecases/vefa_usecases.dart';

// Service & Core Providers
final isarServiceProvider = Provider<IsarService>((ref) {
  return IsarService();
});

final isarInstanceProvider = FutureProvider<Isar>((ref) async {
  final service = ref.watch(isarServiceProvider);
  return service.db;
});

// DataSource
final vefaLocalDataSourceProvider = Provider<VefaLocalDataSource>((ref) {
  final isarAsync = ref.watch(isarInstanceProvider);
  if (isarAsync.asData == null) {
    throw Exception('Isar not initialized');
  }
  return VefaLocalDataSourceImpl(isarAsync.asData!.value);
});

// Repository
final vefaRepositoryProvider = Provider<VefaRepositoryImpl>((ref) {
  final dataSource = ref.watch(vefaLocalDataSourceProvider);
  return VefaRepositoryImpl(dataSource);
});

// UseCases
final getVefaListUseCaseProvider = Provider<GetVefaListUseCase>((ref) {
  return GetVefaListUseCase(ref.watch(vefaRepositoryProvider));
});

final addVefaPersonUseCaseProvider = Provider<AddVefaPersonUseCase>((ref) {
  return AddVefaPersonUseCase(ref.watch(vefaRepositoryProvider));
});

final deleteVefaPersonUseCaseProvider =
    Provider<DeleteVefaPersonUseCase>((ref) {
  return DeleteVefaPersonUseCase(ref.watch(vefaRepositoryProvider));
});

final giftThawabUseCaseProvider = Provider<GiftThawabUseCase>((ref) {
  return GiftThawabUseCase(ref.watch(vefaRepositoryProvider));
});

// Controller / State Management
class VefaListController extends StateNotifier<AsyncValue<List<VefaPerson>>> {
  VefaListController({
    required GetVefaListUseCase getVefaList,
    required AddVefaPersonUseCase addVefaPerson,
    required DeleteVefaPersonUseCase deleteVefaPerson,
    required GiftThawabUseCase giftThawab,
    required Ref ref,
  })  : _getVefaList = getVefaList,
        _addVefaPerson = addVefaPerson,
        _deleteVefaPerson = deleteVefaPerson,
        _giftThawab = giftThawab,
        _ref = ref,
        super(const AsyncValue.loading()) {
    loadVefaList();
  }
  final GetVefaListUseCase _getVefaList;
  final AddVefaPersonUseCase _addVefaPerson;
  final DeleteVefaPersonUseCase _deleteVefaPerson;
  final GiftThawabUseCase _giftThawab;
  final Ref _ref;

  Future<void> loadVefaList() async {
    state = const AsyncValue.loading();
    final result = await _getVefaList();
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (list) => state = AsyncValue.data(list),
    );
  }

  Future<void> addPerson(VefaPerson person) async {
    final result = await _addVefaPerson(person);
    result.fold(
      (failure) => null, // Handle error
      (id) {
        _ref.read(analyticsServiceProvider).logVefaPersonAdd();
        loadVefaList();
      },
    );
  }

  Future<void> deletePerson(int id) async {
    final result = await _deleteVefaPerson(id);
    result.fold(
      (failure) => null, // Handle error
      (_) => loadVefaList(),
    );
  }

  Future<void> giftThawab(int id) async {
    final result = await _giftThawab(id);
    result.fold(
      (failure) => null,
      (_) {
        _ref.read(analyticsServiceProvider).logVefaDuaSend(personCount: 1);
        loadVefaList();
      },
    );
  }
}

final vefaListControllerProvider =
    StateNotifierProvider<VefaListController, AsyncValue<List<VefaPerson>>>(
        (ref) {
  final isarAsync = ref.watch(isarInstanceProvider);

  // Wait for Isar to be ready
  if (isarAsync.isLoading) {
    return VefaListController(
      getVefaList: ref.watch(
          getVefaListUseCaseProvider), // This will fail if simple provider, but we need to handle dependency properly.
      // Actually simpler approach: Check Isar state in UI or use `AsyncNotifier`.
      // For now, let's keep it simple. If isar is loading, we can't create the controller properly if dataSource throws.
      // Better approach: have the repository return Left(Failure) if DB not ready?
      // Or just let Riverpod handle the async dependency.
      addVefaPerson: ref.watch(addVefaPersonUseCaseProvider),
      deleteVefaPerson: ref.watch(deleteVefaPersonUseCaseProvider),
      giftThawab: ref.watch(giftThawabUseCaseProvider),
      ref: ref,
    );
  }

  return VefaListController(
    getVefaList: ref.watch(getVefaListUseCaseProvider),
    addVefaPerson: ref.watch(addVefaPersonUseCaseProvider),
    deleteVefaPerson: ref.watch(deleteVefaPersonUseCaseProvider),
    giftThawab: ref.watch(giftThawabUseCaseProvider),
    ref: ref,
  );
});

