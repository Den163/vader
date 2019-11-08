import 'package:veider/resolvers/resolving_context.dart';

/// DiContainer is a data structure that keep all dependencies resolvers
class DiContainer {
  final Map<Type, ResolvingContext> _resolvers = {};

  void add<T>(ResolvingContext<T> context) {
    _resolvers[T] = context;
  }

  T resolve<T>() {
    final resolver = _resolvers[T];
    if (resolver == null) throw StateError(
      'Can\'t resolve dependency `$T`. Maybe you forget register it?');

    return resolver.resolve();
  }

  void onRegister() {
    _resolvers.values.forEach((v) {
      v.verify();
      v.onRegister();
    });
  }
}