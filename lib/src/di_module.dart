import 'package:vader_di/src/di_container.dart';
import 'package:vader_di/resolvers/resolving_context.dart';

extension DiModule on DiContainer {
  /// Return resolving context that helps
  /// define dependencies in fluent builder style
  ResolvingContext<T> bind<T>() {
    return new ResolvingContext<T>(this);
  }
}
