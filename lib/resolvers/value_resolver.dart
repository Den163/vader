import 'di_resolver.dart';

/// Resolves dependency with value
class ValueResolver<T> extends Resolver<T> {
  final T _value;

  ValueResolver(this._value);

  @override T resolve() => _value;
}