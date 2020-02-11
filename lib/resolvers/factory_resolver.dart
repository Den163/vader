import 'di_resolver.dart';

/// Resolves dependency with factory function
class FactoryResolver<T> extends Resolver<T> {
  final T Function() _factory;

  FactoryResolver(this._factory) :
      assert(_factory != null);

  @override
  T resolve() => _factory();
}