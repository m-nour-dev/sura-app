import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:sila_app/features/ibadah_tracker/data/models/mujahadah_record.dart';
import 'package:sila_app/features/ibadah_tracker/data/repositories/isar_mujahadah_repository.dart';

final isarMujahadahRepositoryProvider =
    Provider<IsarMujahadahRepository>((ref) {
  // This expects Isar to be initialized. In a real app we'd await IsarService().db
  // but for synchronous access we use Isar.getInstance() which is fine if initialized.
  final isar = Isar.getInstance()!;
  return IsarMujahadahRepository(isar);
});

final mujahadahListProvider = StateNotifierProvider<MujahadahController,
    AsyncValue<List<MujahadahRecord>>>((ref) {
  final repo = ref.watch(isarMujahadahRepositoryProvider);
  return MujahadahController(repo)..loadRecords();
});

class MujahadahController
    extends StateNotifier<AsyncValue<List<MujahadahRecord>>> {
  MujahadahController(this._repository) : super(const AsyncValue.loading());

  final IsarMujahadahRepository _repository;

  Future<void> loadRecords() async {
    try {
      state = const AsyncValue.loading();
      final records = await _repository.getAllRecords();
      state = AsyncValue.data(records);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addHabit(String title) async {
    await _repository.addHabit(title);
    await loadRecords();
  }

  Future<void> removeHabit(Id id) async {
    await _repository.removeHabit(id);
    await loadRecords();
  }

  Future<void> recordSuccess(Id id) async {
    await _repository.recordSuccess(id);
    await loadRecords();
  }

  Future<void> recordMinorSlip(Id id) async {
    await _repository.recordMinorSlip(id);
    await loadRecords();
  }

  Future<void> recordRelapse(Id id) async {
    await _repository.recordRelapse(id);
    await loadRecords();
  }
}
