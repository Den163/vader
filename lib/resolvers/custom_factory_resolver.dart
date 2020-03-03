import 'package:vader_di/resolvers/factory_resolver.dart';
import 'package:vader_di/resolvers/helpers/custom_factory.dart';
import 'package:vader_di/vader.dart';

import 'di_resolver.dart';

class CustomFactoryResolver<T, TArgs>
extends Resolver<CustomFactory<T, TArgs>>
implements CustomFactory<T, TArgs> {
  TArgs _args;

  FactoryResolver<T> _factoryResolver;

  CustomFactoryResolver(T Function(TArgs) factory) {
    // It takes _args in closure to allow assign it later and send to factory
    _factoryResolver = new FactoryResolver(
      () => factory(_args)
    );
  }

  @override
  T make(TArgs args) {
    _args = args;
    return _factoryResolver.resolve();
  }

  @override
  CustomFactory<T, TArgs> resolve() => this;
}
