// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$prayerRepositoryHash() => r'9dcfac8f343b46cbfa5b0afa59c55417e51519fd';

/// See also [prayerRepository].
@ProviderFor(prayerRepository)
final prayerRepositoryProvider =
    AutoDisposeProvider<PrayerRepositoryImpl>.internal(
  prayerRepository,
  name: r'prayerRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$prayerRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PrayerRepositoryRef = AutoDisposeProviderRef<PrayerRepositoryImpl>;
String _$prayerTimesControllerHash() =>
    r'72b91277c13bc96b0c6434f7150142332e0552db';

/// See also [PrayerTimesController].
@ProviderFor(PrayerTimesController)
final prayerTimesControllerProvider = AutoDisposeAsyncNotifierProvider<
    PrayerTimesController, PrayerTimesEntity>.internal(
  PrayerTimesController.new,
  name: r'prayerTimesControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$prayerTimesControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PrayerTimesController = AutoDisposeAsyncNotifier<PrayerTimesEntity>;
String _$nextPrayerControllerHash() =>
    r'03fc2726494a407dc3e063eaf2557e6e6ffbe9c8';

/// See also [NextPrayerController].
@ProviderFor(NextPrayerController)
final nextPrayerControllerProvider =
    AutoDisposeAsyncNotifierProvider<NextPrayerController, Prayer>.internal(
  NextPrayerController.new,
  name: r'nextPrayerControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nextPrayerControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NextPrayerController = AutoDisposeAsyncNotifier<Prayer>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
