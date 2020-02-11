import 'package:vader_di/resolvers/di_resolver.dart';

class SingletonResolver<T> extends Resolver<T> {
  final Resolver<T> _decoratedResolver;
  T _value;

  SingletonResolver(this._decoratedResolver) :
    assert(_decoratedResolver != null);

  @override
  T resolve() => _value ?? (_value = _decoratedResolver.resolve());
}