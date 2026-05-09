import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sura_app/features/hifz/data/repositories/i_hifz_repository.dart';
import 'package:sura_app/features/hifz/data/repositories/isar_hifz_repository.dart';
import 'package:sura_app/features/vefa/presentation/riverpod/vefa_providers.dart';

final hifzRepositoryProvider = FutureProvider<IHifzRepository>((ref) async {
  final isar = await ref.watch(isarInstanceProvider.future);
  return IsarHifzRepository(isar);
});

