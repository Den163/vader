import 'package:vader_di/resolvers/resolvers.dart';
import 'package:vader_di/resolvers/singleton_resolver.dart';
import 'package:vader_di/resolvers/value_resolver.dart';
import 'package:vader_di/src/di_container.dart';

import 'di_resolver.dart';
import 'factory_resolver.dart';

/// Facade with factories for all other resolvers
class ResolvingContext<T> extends Resolver<T> {
  Resolver<T> _resolver;
  final DiContainer _container;

  ResolvingContext(this._container) {
    _container.add(this);
  }

  ResolvingContext<T> toValue<TImpl extends T>(TImpl value) {
    _resolver = new ValueResolver<TImpl>(value);
    return this;
  }

  // Create factory resolver without any dependencies
  ResolvingContext<T> toPureFactory<TImpl extends T>(TImpl Function() factory) {
    _resolver = new FactoryResolver<TImpl>(factory);
    return this;
  }

  ResolvingContext<T> withDispose<TImpl extends T>(void Function(TImpl) dispose) {
    _container.addDispose<T>(dispose);
    return this;
  }

  ResolvingContext<T> asSingleton() {
    if (_resolver == null)
      throw StateError('Can\'t make singleton from null resolver');

    _resolver = new SingletonResolver(_resolver);
    return this;
  }

  @override
  T resolve() {
    verify();

    return _resolver.resolve();
  }

  void verify() {
    if (_resolver == null)
      throw StateError(
          'Can\'t resolve $T without any resolvers. '
              'Please check, may be you didn\'t do anything after bind()');
  }

  /// Create factory resolver with 1 dependency
  ResolvingContext<T> toFactory1<T1>(T Function(T1) factory) {
    _resolver = new FactoryResolver(
        () => factory(_container.resolve<T1>())
    );
    return this;
  }

  /// Create factory resolver with 2 dependencies
  ResolvingContext<T> toFactory2<T1, T2>(T Function(T1, T2) factory) {
    _resolver = new FactoryResolver(
        () => factory(_container.resolve<T1>(), _container.resolve<T2>())
    );
    return this;
  }

  /// Create factory resolver with 3 dependencies
  ResolvingContext<T> toFactory3<T1, T2, T3>(T Function(T1, T2, T3) factory) {
    _resolver = new FactoryResolver(
            () => factory(
              _container.resolve<T1>(),
              _container.resolve<T2>(),
              _container.resolve<T3>()
            )
    );
    return this;
  }

  /// Create factory resolver with 4 dependencies
  ResolvingContext<T> toFactory4<T1, T2, T3, T4>(T Function(T1, T2, T3, T4) factory) {
    _resolver = new FactoryResolver(
            () => factory(
            _container.resolve<T1>(),
            _container.resolve<T2>(),
            _container.resolve<T3>(),
            _container.resolve<T4>(),
        )
    );
    return this;
  }

  /// Create factory resolver with 5 dependencies
  ResolvingContext<T> toFactory5<T1, T2, T3, T4, T5>(T Function(T1, T2, T3, T4, T5) factory) {
    _resolver = new FactoryResolver(
            () => factory(
          _container.resolve<T1>(),
          _container.resolve<T2>(),
          _container.resolve<T3>(),
          _container.resolve<T4>(),
          _container.resolve<T5>(),
        )
    );
    return this;
  }

  /// Create factory resolver with 6 dependencies
  ResolvingContext<T> toFactory6<T1, T2, T3, T4, T5, T6>(
      T Function(T1, T2, T3, T4, T5, T6) factory
  ) {
    _resolver = new FactoryResolver(
            () => factory(
          _container.resolve<T1>(),
          _container.resolve<T2>(),
          _container.resolve<T3>(),
          _container.resolve<T4>(),
          _container.resolve<T5>(),
          _container.resolve<T6>(),
        )
    );
    return this;
  }

  /// Create factory resolver with 7 dependencies
  ResolvingContext<T> toFactory7<T1, T2, T3, T4, T5, T6, T7>(
      T Function(T1, T2, T3, T4, T5, T6, T7) factory
      ) {
    _resolver = new FactoryResolver(
            () => factory(
          _container.resolve<T1>(),
          _container.resolve<T2>(),
          _container.resolve<T3>(),
          _container.resolve<T4>(),
          _container.resolve<T5>(),
          _container.resolve<T6>(),
          _container.resolve<T7>(),
        )
    );
    return this;
  }

  /// Create factory resolver with 8 dependencies
  ResolvingContext<T> toFactory8<T1, T2, T3, T4, T5, T6, T7, T8>(
      T Function(T1, T2, T3, T4, T5, T6, T7, T8) factory
      ) {
    _resolver = new FactoryResolver(
            () => factory(
          _container.resolve<T1>(),
          _container.resolve<T2>(),
          _container.resolve<T3>(),
          _container.resolve<T4>(),
          _container.resolve<T5>(),
          _container.resolve<T6>(),
          _container.resolve<T7>(),
          _container.resolve<T8>(),
        )
    );
    return this;
  }
}