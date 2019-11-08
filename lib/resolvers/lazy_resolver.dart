import 'di_resolver.dart';

/// Resolves value not immediately but on demand (when resolve() will be called)
class LazyResolver<T> extends Resolver<T> {
  final Resolver<T> _decoratedResolver;

  LazyResolver(this._decoratedResolver);

  @override
  T resolve() {
    _decoratedResolver.onRegister();
    return _decoratedResolver.resolve();
  }

}