// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commentsProviderHash() => r'7b9d9a49ad9930737954800abf09eef4d7eac98b';

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

/// See also [commentsProvider].
@ProviderFor(commentsProvider)
const commentsProviderProvider = CommentsProviderFamily();

/// See also [commentsProvider].
class CommentsProviderFamily extends Family<AsyncValue<List<Comment>>> {
  /// See also [commentsProvider].
  const CommentsProviderFamily();

  /// See also [commentsProvider].
  CommentsProviderProvider call({
    User? user,
    required String postId,
  }) {
    return CommentsProviderProvider(
      user: user,
      postId: postId,
    );
  }

  @override
  CommentsProviderProvider getProviderOverride(
    covariant CommentsProviderProvider provider,
  ) {
    return call(
      user: provider.user,
      postId: provider.postId,
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
  String? get name => r'commentsProviderProvider';
}

/// See also [commentsProvider].
class CommentsProviderProvider
    extends AutoDisposeStreamProvider<List<Comment>> {
  /// See also [commentsProvider].
  CommentsProviderProvider({
    User? user,
    required String postId,
  }) : this._internal(
          (ref) => commentsProvider(
            ref as CommentsProviderRef,
            user: user,
            postId: postId,
          ),
          from: commentsProviderProvider,
          name: r'commentsProviderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$commentsProviderHash,
          dependencies: CommentsProviderFamily._dependencies,
          allTransitiveDependencies:
              CommentsProviderFamily._allTransitiveDependencies,
          user: user,
          postId: postId,
        );

  CommentsProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.user,
    required this.postId,
  }) : super.internal();

  final User? user;
  final String postId;

  @override
  Override overrideWith(
    Stream<List<Comment>> Function(CommentsProviderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CommentsProviderProvider._internal(
        (ref) => create(ref as CommentsProviderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        user: user,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Comment>> createElement() {
    return _CommentsProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommentsProviderProvider &&
        other.user == user &&
        other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, user.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CommentsProviderRef on AutoDisposeStreamProviderRef<List<Comment>> {
  /// The parameter `user` of this provider.
  User? get user;

  /// The parameter `postId` of this provider.
  String get postId;
}

class _CommentsProviderProviderElement
    extends AutoDisposeStreamProviderElement<List<Comment>>
    with CommentsProviderRef {
  _CommentsProviderProviderElement(super.provider);

  @override
  User? get user => (origin as CommentsProviderProvider).user;
  @override
  String get postId => (origin as CommentsProviderProvider).postId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
