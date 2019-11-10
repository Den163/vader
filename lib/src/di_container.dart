import 'package:veider/resolvers/resolvers.dart';

/// DiContainer is a data structure that keep all dependencies resolvers
class DiContainer {
  final _resolvers = <Type, Resolver> {};

  DiContainer get parent => _parent;
  DiContainer _parent;

  DiContainer([this._parent]);

  /// Add dependency resolver to the container.
  /// Note that value overwriting within same container is prohibited
  void add<T>(Resolver<T> context) {
    if (_resolvers.containsKey(T))
      throw StateError('Dependency of type `$T` is already exist in container');

    _resolvers[T] = context;
  }

  bool has<T>() => _resolvers.containsKey(T);
  bool hasInTree<T>() =>
      has<T>() ||
      (_parent != null && _parent.hasInTree<T>());

  T resolve<T extends Object>() {
    final resolved = tryResolve<T>();
    if (resolved != null) {
      return resolved;
    } else {
      throw StateError(
        'Can\'t resolve dependency `$T`. '
        'Maybe you forget register it?');
    }
  }

  T tryResolve<T>() {
    final resolver = _resolvers[T];

    return resolver != null
      ? resolver.resolve()
      : parent?.tryResolve();
  }
}