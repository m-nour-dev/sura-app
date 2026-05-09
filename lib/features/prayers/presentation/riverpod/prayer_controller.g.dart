// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$prayerRepositoryHash() => r'c6cab4350d3079fc981d3ac1125295bf754d4bad';

/// See also [prayerRepository].
@ProviderFor(prayerRepository)
final prayerRepositoryProvider = Provider<PrayerRepositoryImpl>.internal(
  prayerRepository,
  name: r'prayerRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$prayerRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PrayerRepositoryRef = ProviderRef<PrayerRepositoryImpl>;
String _$prayerTimesControllerHash() =>
    r'c2b82b1fdaf910f53b9b94366cfbddb13a8ee36f';

/// See also [PrayerTimesController].
@ProviderFor(PrayerTimesController)
final prayerTimesControllerProvider =
    AsyncNotifierProvider<PrayerTimesController, PrayerTimesEntity>.internal(
  PrayerTimesController.new,
  name: r'prayerTimesControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$prayerTimesControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrayerTimesController = AsyncNotifier<PrayerTimesEntity>;
String _$nextPrayerControllerHash() =>
    r'f6575f99b37b059cba7c43217378ca772d8eceae';

/// See also [NextPrayerController].
@ProviderFor(NextPrayerController)
final nextPrayerControllerProvider =
    AsyncNotifierProvider<NextPrayerController, Prayer>.internal(
  NextPrayerController.new,
  name: r'nextPrayerControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nextPrayerControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NextPrayerController = AsyncNotifier<Prayer>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
