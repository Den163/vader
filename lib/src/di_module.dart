import 'package:vader_di/src/di_container.dart';
import 'package:vader_di/resolvers/resolving_context.dart';

/// DiModule is an abstraction for user extension, that defines all dependencies
/// in register() method
class DiModule {
  final DiContainer container;

  DiModule([DiContainer container]) :
    this.container = container ?? new DiContainer();

  /// Return resolving context that helps
  /// define dependencies in fluent builder style
  ResolvingContext<T> bind<T>() {
    return new ResolvingContext<T>(container);
  }

  /// Delegates dependency resolving to the DiContainer
  T resolve<T>() => container.resolve<T>();

  void dispose() => container.dispose();
}