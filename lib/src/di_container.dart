import 'package:veider/resolvers/resolving_context.dart';

/// DiContainer is a data structure that keep all dependencies resolvers
class DiContainer {
  final Map<Type, ResolvingContext> _resolvers = {};
  DiContainer get parent => _parent;
  DiContainer _parent;

  DiContainer([this._parent]);

  /// Add dependency resolver to the container.
  /// Note that value overwriting within same container is prohibited
  void add<T>(ResolvingContext<T> context) {
    if (_resolvers.containsKey(T))
      throw StateError('Dependency of type `$T` is already exist in container');

    _resolvers[T] = context;
  }

  T resolve<T>() {
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

  void onRegister() {
    _resolvers.values.forEach((v) {
      v.verify();
      v.onRegister();
    });
  }

  void dispose() {

  }
}