import 'package:vader_di/resolvers/custom_factory_resolver.dart';
import 'package:vader_di/resolvers/helpers/custom_factory.dart';
import 'package:vader_di/resolvers/disposable_custom_factory_resolver.dart';
import 'package:vader_di/resolvers/resolving_context.dart';
import 'package:vader_di/src/di_container.dart';

extension CustomFactoriesContainerMethods<TArgs> on DiContainer {
  /// Helper method to convenient create custom factory
  ResolvingContext<CustomFactory<T, TArgs>> bindCustomFactory<T, TArgs>() {
    return this.bind<CustomFactory<T, TArgs>>();
  }

  /// Makes an object with resolved [CustomFactory<T, TArgs>]
  T make<T, TArgs>(TArgs args) {
    return this.resolve<CustomFactory<T, TArgs>>().make(args);
  }
}

extension CustomFactoriesResolvingLifeTimeMethods<T, TArgs>
    on ResolvingContext<CustomFactory<T, TArgs>> {

  /// Set dispose method for every created object with CustomFactory,
  /// (Will be disposed when container was disposed)
  ResolvingContext<CustomFactory<T, TArgs>> withDispose(
    void Function(T) dispose,
  ) {
    return this.toResolver(
      new DisposableCustomFactoryResolver(
          resolver as CustomFactoryResolver<T, TArgs>, dispose),
    )..container.addDispose<CustomFactory<T, TArgs>>(
        (fac) => (fac as DisposableCustomFactoryResolver<T, TArgs>).dispose(),
      );
  }
}

extension CustomFactoriesMethods<T, TArgs>
    on ResolvingContext<CustomFactory<T, TArgs>> {
  ResolvingContext<CustomFactory<T, TArgs>> from(
    T Function(TArgs) factory,
  ) {
    return this.toResolver(
        new CustomFactoryResolver<T, TArgs>((args) => factory(args)));
  }

  ResolvingContext<CustomFactory<T, TArgs>> from1<T1>(
    T Function(T1, TArgs) factory,
  ) {
    return this.toResolver(new CustomFactoryResolver<T, TArgs>(
        (args) => factory(container.resolve<T1>(), args)));
  }

  ResolvingContext<CustomFactory<T, TArgs>> from2<T1, T2>(
    T Function(T1, T2, TArgs) factory,
  ) {
    return this.toResolver(
      new CustomFactoryResolver<T, TArgs>(
        (args) => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          args,
        ),
      ),
    );
  }

  ResolvingContext<CustomFactory<T, TArgs>> from3<T1, T2, T3>(
    T Function(T1, T2, T3, TArgs) factory,
  ) {
    return this.toResolver(
      new CustomFactoryResolver<T, TArgs>(
        (args) => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          args,
        ),
      ),
    );
  }

  ResolvingContext<CustomFactory<T, TArgs>> from4<T1, T2, T3, T4>(
    T Function(T1, T2, T3, T4, TArgs) factory,
  ) {
    return this.toResolver(
      new CustomFactoryResolver<T, TArgs>(
        (args) => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          container.resolve<T4>(),
          args,
        ),
      ),
    );
  }

  ResolvingContext<CustomFactory<T, TArgs>> from5<T1, T2, T3, T4, T5>(
    T Function(T1, T2, T3, T4, T5, TArgs) factory,
  ) {
    return this.toResolver(
      new CustomFactoryResolver<T, TArgs>(
        (args) => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          container.resolve<T4>(),
          container.resolve<T5>(),
          args,
        ),
      ),
    );
  }

  ResolvingContext<CustomFactory<T, TArgs>> from6<T1, T2, T3, T4, T5, T6>(
    T Function(T1, T2, T3, T4, T5, T6, TArgs) factory,
  ) {
    return this.toResolver(
      new CustomFactoryResolver<T, TArgs>(
        (args) => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          container.resolve<T4>(),
          container.resolve<T5>(),
          container.resolve<T6>(),
          args,
        ),
      ),
    );
  }

  ResolvingContext<CustomFactory<T, TArgs>> from7<T1, T2, T3, T4, T5, T6, T7>(
    T Function(T1, T2, T3, T4, T5, T6, T7, TArgs) factory,
  ) {
    return this.toResolver(
      new CustomFactoryResolver<T, TArgs>(
        (args) => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          container.resolve<T4>(),
          container.resolve<T5>(),
          container.resolve<T6>(),
          container.resolve<T7>(),
          args,
        ),
      ),
    );
  }

  ResolvingContext<CustomFactory<T, TArgs>>
      from8<T1, T2, T3, T4, T5, T6, T7, T8>(
    T Function(T1, T2, T3, T4, T5, T6, T7, T8, TArgs) factory,
  ) {
    return this.toResolver(
      new CustomFactoryResolver<T, TArgs>(
        (args) => factory(
          container.resolve<T1>(),
          container.resolve<T2>(),
          container.resolve<T3>(),
          container.resolve<T4>(),
          container.resolve<T5>(),
          container.resolve<T6>(),
          container.resolve<T7>(),
          container.resolve<T8>(),
          args,
        ),
      ),
    );
  }
}
