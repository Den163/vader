import 'package:veider/src/di_container.dart';
import 'package:meta/meta.dart';
import 'package:veider/resolvers/resolving_context.dart';

/// DiModule is an abstraction for user extension, that defines all dependencies
/// in register() method
abstract class DiModule {
  final DiContainer _container;

  DiModule([DiContainer container]) :
    _container = container ?? new DiContainer();

  /// Return resolving context that helps
  /// define dependencies in fluent builder style
  @protected ResolvingContext<T> bind<T>() { 
    return new ResolvingContext<T>(_container);
  }

  /// In this method override user configure all dependencies for the module
  @protected void register();

  /// Method for user code all other libraries to install all dependencies
  /// configured in the register method
  void install() {
     register();
     _container.onRegister();
  }

  /// Delegates dependency resolving to the DiContainer
  T resolve<T>() => _container.resolve<T>();
}