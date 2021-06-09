import 'package:vader_di/resolvers/resolvers.dart';
import 'package:vader_di/src/di_container.dart';

import 'di_resolver.dart';

///
class ResolvingContext<T> extends Resolver<T> {
  /// Root resolver
  Resolver<T> get resolver => _resolver;
  final DiContainer container;

  late Resolver<T> _resolver;

  ResolvingContext(this.container);

  /// Adds resolver as a root resolver. Through this method you can add
  /// any custom resolver
  ResolvingContext<T> toResolver<TImpl extends T>(Resolver<TImpl> resolver) {
    _resolver = resolver;
    return this;
  }

  /// Resolves dependency of type [T]
  @override
  T resolve() {
    verify();

    return _resolver.resolve();
  }

  void verify() {
    if (_resolver == null)
      throw StateError('Can\'t resolve $T without any resolvers. '
          'Please check, may be you didn\'t do anything after bind()');
  }
}
