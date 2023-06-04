// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$githubServiceHash() => r'71f50b374640054092e0a366b22b7fdc8f8c8123';

/// See also [githubService].
@ProviderFor(githubService)
final githubServiceProvider = AutoDisposeProvider<GithubService>.internal(
  githubService,
  name: r'githubServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$githubServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GithubServiceRef = AutoDisposeProviderRef<GithubService>;
String _$githubRepositoryHash() => r'a21eee185645f4822c8ce5364444be29c2bf1c41';

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

typedef GithubRepositoryRef
    = AutoDisposeFutureProviderRef<GithubRepositoryDto?>;

/// See also [githubRepository].
@ProviderFor(githubRepository)
const githubRepositoryProvider = GithubRepositoryFamily();

/// See also [githubRepository].
class GithubRepositoryFamily extends Family<AsyncValue<GithubRepositoryDto?>> {
  /// See also [githubRepository].
  const GithubRepositoryFamily();

  /// See also [githubRepository].
  GithubRepositoryProvider call(
    RepositorySlug slug, {
    String path = 'src',
    String? branch,
    List<String> extensions = const ['ts', 'tsx'],
  }) {
    return GithubRepositoryProvider(
      slug,
      path: path,
      branch: branch,
      extensions: extensions,
    );
  }

  @override
  GithubRepositoryProvider getProviderOverride(
    covariant GithubRepositoryProvider provider,
  ) {
    return call(
      provider.slug,
      path: provider.path,
      branch: provider.branch,
      extensions: provider.extensions,
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
  String? get name => r'githubRepositoryProvider';
}

/// See also [githubRepository].
class GithubRepositoryProvider
    extends AutoDisposeFutureProvider<GithubRepositoryDto?> {
  /// See also [githubRepository].
  GithubRepositoryProvider(
    this.slug, {
    this.path = 'src',
    this.branch,
    this.extensions = const ['ts', 'tsx'],
  }) : super.internal(
          (ref) => githubRepository(
            ref,
            slug,
            path: path,
            branch: branch,
            extensions: extensions,
          ),
          from: githubRepositoryProvider,
          name: r'githubRepositoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$githubRepositoryHash,
          dependencies: GithubRepositoryFamily._dependencies,
          allTransitiveDependencies:
              GithubRepositoryFamily._allTransitiveDependencies,
        );

  final RepositorySlug slug;
  final String path;
  final String? branch;
  final List<String> extensions;

  @override
  bool operator ==(Object other) {
    return other is GithubRepositoryProvider &&
        other.slug == slug &&
        other.path == path &&
        other.branch == branch &&
        other.extensions == extensions;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);
    hash = _SystemHash.combine(hash, path.hashCode);
    hash = _SystemHash.combine(hash, branch.hashCode);
    hash = _SystemHash.combine(hash, extensions.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
