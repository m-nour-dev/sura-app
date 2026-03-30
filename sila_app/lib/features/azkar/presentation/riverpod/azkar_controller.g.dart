// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'azkar_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$azkarRepositoryHash() => r'd6a0795dd84bb731ab1becbaaad6d621af3ef517';

/// See also [azkarRepository].
@ProviderFor(azkarRepository)
final azkarRepositoryProvider = AutoDisposeProvider<AzkarRepository>.internal(
  azkarRepository,
  name: r'azkarRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$azkarRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AzkarRepositoryRef = AutoDisposeProviderRef<AzkarRepository>;
String _$azkarDataHash() => r'9998d08b6a24648e5a7d7a155bb1d2a13541a785';

/// See also [azkarData].
@ProviderFor(azkarData)
final azkarDataProvider =
    AutoDisposeFutureProvider<Map<String, List<AzkarItem>>>.internal(
  azkarData,
  name: r'azkarDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$azkarDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AzkarDataRef
    = AutoDisposeFutureProviderRef<Map<String, List<AzkarItem>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
