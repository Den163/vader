import 'di_resolver.dart';

/// Resolves value not immediately but on demand (when resolve() will be called)
class LazyResolver<T> extends Resolver<T> {
  final Resolver<T> _decoratedResolver;
  T _value;

  LazyResolver(this._decoratedResolver);

  @override
  T resolve() {
    if (_value == null) {
      _decoratedResolver.onRegister();
      _value = _decoratedResolver.resolve();
    }

    return _value;
  }
}