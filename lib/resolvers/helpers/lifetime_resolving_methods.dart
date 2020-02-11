import 'package:vader_di/resolvers/resolving_context.dart';

import '../singleton_resolver.dart';

extension LifetimeResolvingMethods<T> on ResolvingContext<T> {
  ResolvingContext<T> withDispose(void Function(T) dispose) {
    container.addDispose<T>(dispose);
    return this;
  }

  ResolvingContext<T> asSingleton() {
    return this.toResolver(
      new SingletonResolver(resolver)
    );
  }
}