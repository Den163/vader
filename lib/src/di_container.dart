import 'package:veider/resolvers/resolving_context.dart';

/// DiContainer is a data structure that keep all dependencies resolvers
class DiContainer {
  final Map<Type, ResolvingContext> _resolvers = {};
  DiContainer get parent => _parent;
  DiContainer _parent;

  DiContainer([this._parent]);

  void add<T>(ResolvingContext<T> context) {
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
}