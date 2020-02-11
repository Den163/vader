import 'package:vader_di/resolvers/factory_resolver.dart';
import 'package:vader_di/resolvers/resolving_context.dart';
import 'package:vader_di/resolvers/value_resolver.dart';

extension CreatingResolvingMethods<T> on ResolvingContext<T> {

  /// Create value resolver
  ResolvingContext<T> toValue<TImpl extends T>(TImpl value) {
    return this.toResolver(new ValueResolver<TImpl>(value));
  }

  // Create factory resolver without any dependencies
  ResolvingContext<T> from<TImpl extends T>(TImpl Function() factory) {
    return this.toResolver(new FactoryResolver<TImpl>(factory));
  }

  /// Create factory resolver with 1 dependency from container
  ResolvingContext<T> from1<T1>(T Function(T1) factory) {
    return this.toResolver(
      new FactoryResolver(
          () => factory(
          container.resolve<T1>(),
        ),
      ),
    );
  }

  /// Create factory resolver with 2 dependencies from container
  ResolvingContext<T> from2<T1, T2>(T Function(T1, T2) factory) {
    return this.toResolver(
      new FactoryResolver(
          () => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
        ),
      ),
    );
  }

  /// Create factory resolver with 3 dependencies from container
  ResolvingContext<T> from3<T1, T2, T3>(T Function(T1, T2, T3) factory) {
    return this.toResolver(
      new FactoryResolver(
          () => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
        ),
      ),
    );
  }

  /// Create factory resolver with 4 dependencies from container
  ResolvingContext<T> from4<T1, T2, T3, T4>(
    T Function(T1, T2, T3, T4) factory) {
    return this.toResolver(
      new FactoryResolver(
          () => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          container.resolve<T4>(),
        ),
      ),
    );
  }

  /// Create factory resolver with 5 dependencies from container
  ResolvingContext<T> from5<T1, T2, T3, T4, T5>(
    T Function(T1, T2, T3, T4, T5) factory) {
    return this.toResolver(
      new FactoryResolver(
          () => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          container.resolve<T4>(),
          container.resolve<T5>(),
        ),
      ),
    );
  }

  /// Create factory resolver with 6 dependencies from container
  ResolvingContext<T> from6<T1, T2, T3, T4, T5, T6>(
    T Function(T1, T2, T3, T4, T5, T6) factory) {
    return this.toResolver(
      new FactoryResolver(
          () => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          container.resolve<T4>(),
          container.resolve<T5>(),
          container.resolve<T6>(),
        ),
      ),
    );
  }

  /// Create factory resolver with 7 dependencies from container
  ResolvingContext<T> from7<T1, T2, T3, T4, T5, T6, T7>(
    T Function(T1, T2, T3, T4, T5, T6, T7) factory) {
    return this.toResolver(
      new FactoryResolver(
          () => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          container.resolve<T4>(),
          container.resolve<T5>(),
          container.resolve<T6>(),
          container.resolve<T7>(),
        ),
      ),
    );
  }

  /// Create factory resolver with 8 dependencies from container
  ResolvingContext<T> from8<T1, T2, T3, T4, T5, T6, T7, T8>(
    T Function(T1, T2, T3, T4, T5, T6, T7, T8) factory) {
    return this.toResolver(
      new FactoryResolver(
          () => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          container.resolve<T4>(),
          container.resolve<T5>(),
          container.resolve<T6>(),
          container.resolve<T7>(),
          container.resolve<T8>(),
        ),
      ),
    );
  }
}