
import 'package:veider/resolvers/value_resolver.dart';
import 'package:veider/src/di_container.dart';

import 'di_resolver.dart';
import 'factory_resolver.dart';
import 'lazy_resolver.dart';

/// Facade with factories for all other resolvers
class ResolvingContext<T> extends Resolver<T> {
  Resolver<T> _resolver;
  final DiContainer _container;

  ResolvingContext(this._container) {
    _container.add(this);
  }

  // TODO implement to behavior
  ResolvingContext to<TImpl>() {
    throw UnimplementedError();
  }
  
  ResolvingContext toValue<TImpl extends T>(TImpl value) {
    _resolver = new ValueResolver(value);
    return this;
  }

  // Create factory resolver without any dependencies
  ResolvingContext toPureFactory(T Function() factory) {
    _resolver = new FactoryResolver(factory);
    return this;
  }

  // TODO implement singleton behavior
  ResolvingContext asSingleton<T>() {
    throw UnimplementedError();
  }

  ResolvingContext lazy<T>() {
    verify();
    _resolver = new LazyResolver(_resolver);
    return this;
  }

  @override
  void onRegister() => _resolver.onRegister();

  @override
  T resolve() {
    verify();

    return _resolver.resolve();
  }

  void _verifyCreation() {
    if (_resolver != null) throw new StateError(
        'Can\'t resolve `$T` twice. '
            'Possibly it was resolved with factory or value earlier.'
    );
  }

  void verify() {
    if (_resolver == null)
      throw StateError(
          'Can\'t resolve $T without any resolvers. '
              'Please check, may be you didn\'t do anything after bind()');
  }

  /// Create factory resolver with 1 dependency
  ResolvingContext toFactory1<T1>(T Function(T1) factory) {
    _resolver = new FactoryResolver(
        () => factory(_container.resolve<T1>())
    );
    return this;
  }

  /// Create factory resolver with 2 dependencies
  ResolvingContext toFactory2<T1, T2>(T Function(T1, T2) factory) {
    _resolver = new FactoryResolver(
        () => factory(_container.resolve<T1>(), _container.resolve<T2>())
    );
    return this;
  }

  /// Create factory resolver with 3 dependencies
  ResolvingContext toFactory3<T1, T2, T3>(T Function(T1, T2, T3) factory) {
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
  ResolvingContext toFactory4<T1, T2, T3, T4>(T Function(T1, T2, T3, T4) factory) {
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
  ResolvingContext toFactory5<T1, T2, T3, T4, T5>(T Function(T1, T2, T3, T4, T5) factory) {
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
  ResolvingContext toFactory6<T1, T2, T3, T4, T5, T6>(
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
  ResolvingContext toFactory7<T1, T2, T3, T4, T5, T6, T7>(
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
  ResolvingContext toFactory8<T1, T2, T3, T4, T5, T6, T7, T8>(
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