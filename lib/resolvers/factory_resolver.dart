import 'di_resolver.dart';

/// Resolves dependency with factory function
class FactoryResolver<T> extends Resolver<T> {
  final T Function() _factory;
  T _value;

  FactoryResolver(this._factory);

  @override
  void onRegister() {
    _value = _factory();
  }

  @override
  T resolve() =>  _value;
}