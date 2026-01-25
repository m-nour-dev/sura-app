// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quranLocalDataSourceHash() =>
    r'aab01b36421dd1f04f479f2ea0af3f4c24293fda';

/// See also [quranLocalDataSource].
@ProviderFor(quranLocalDataSource)
final quranLocalDataSourceProvider =
    AutoDisposeProvider<QuranLocalDataSource>.internal(
  quranLocalDataSource,
  name: r'quranLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quranLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef QuranLocalDataSourceRef = AutoDisposeProviderRef<QuranLocalDataSource>;
String _$quranRepositoryHash() => r'781a53cc9de446335e52c444c08058f064c5df25';

/// See also [quranRepository].
@ProviderFor(quranRepository)
final quranRepositoryProvider = AutoDisposeProvider<QuranRepository>.internal(
  quranRepository,
  name: r'quranRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quranRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef QuranRepositoryRef = AutoDisposeProviderRef<QuranRepository>;
String _$getSurahsHash() => r'b4aeaa9567978b8e2c9690ac3f1d77f88b03dcae';

/// See also [getSurahs].
@ProviderFor(getSurahs)
final getSurahsProvider = AutoDisposeProvider<GetSurahs>.internal(
  getSurahs,
  name: r'getSurahsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getSurahsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetSurahsRef = AutoDisposeProviderRef<GetSurahs>;
String _$getSurahDetailHash() => r'8690117fd96f8223c3e4d05cce4b5a0e9b3cb7f0';

/// See also [getSurahDetail].
@ProviderFor(getSurahDetail)
final getSurahDetailProvider = AutoDisposeProvider<GetSurahDetail>.internal(
  getSurahDetail,
  name: r'getSurahDetailProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getSurahDetailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetSurahDetailRef = AutoDisposeProviderRef<GetSurahDetail>;
String _$quranControllerHash() => r'feb90102aa30cce54f1bda8349c87940634055a8';

/// See also [QuranController].
@ProviderFor(QuranController)
final quranControllerProvider =
    AutoDisposeAsyncNotifierProvider<QuranController, List<Surah>>.internal(
  QuranController.new,
  name: r'quranControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quranControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuranController = AutoDisposeAsyncNotifier<List<Surah>>;
String _$surahDetailControllerHash() =>
    r'a36aa33378aed1c967dbcbb4708b20daa30c9701';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SurahDetailController
    extends BuildlessAutoDisposeAsyncNotifier<Surah> {
  late final int surahNumber;

  FutureOr<Surah> build(
    int surahNumber,
  );
}

/// See also [SurahDetailController].
@ProviderFor(SurahDetailController)
const surahDetailControllerProvider = SurahDetailControllerFamily();

/// See also [SurahDetailController].
class SurahDetailControllerFamily extends Family<AsyncValue<Surah>> {
  /// See also [SurahDetailController].
  const SurahDetailControllerFamily();

  /// See also [SurahDetailController].
  SurahDetailControllerProvider call(
    int surahNumber,
  ) {
    return SurahDetailControllerProvider(
      surahNumber,
    );
  }

  @override
  SurahDetailControllerProvider getProviderOverride(
    covariant SurahDetailControllerProvider provider,
  ) {
    return call(
      provider.surahNumber,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'surahDetailControllerProvider';
}

/// See also [SurahDetailController].
class SurahDetailControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SurahDetailController, Surah> {
  /// See also [SurahDetailController].
  SurahDetailControllerProvider(
    int surahNumber,
  ) : this._internal(
          () => SurahDetailController()..surahNumber = surahNumber,
          from: surahDetailControllerProvider,
          name: r'surahDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$surahDetailControllerHash,
          dependencies: SurahDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              SurahDetailControllerFamily._allTransitiveDependencies,
          surahNumber: surahNumber,
        );

  SurahDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.surahNumber,
  }) : super.internal();

  final int surahNumber;

  @override
  FutureOr<Surah> runNotifierBuild(
    covariant SurahDetailController notifier,
  ) {
    return notifier.build(
      surahNumber,
    );
  }

  @override
  Override overrideWith(SurahDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SurahDetailControllerProvider._internal(
        () => create()..surahNumber = surahNumber,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        surahNumber: surahNumber,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SurahDetailController, Surah>
      createElement() {
    return _SurahDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SurahDetailControllerProvider &&
        other.surahNumber == surahNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, surahNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SurahDetailControllerRef on AutoDisposeAsyncNotifierProviderRef<Surah> {
  /// The parameter `surahNumber` of this provider.
  int get surahNumber;
}

class _SurahDetailControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SurahDetailController,
        Surah> with SurahDetailControllerRef {
  _SurahDetailControllerProviderElement(super.provider);

  @override
  int get surahNumber => (origin as SurahDetailControllerProvider).surahNumber;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
