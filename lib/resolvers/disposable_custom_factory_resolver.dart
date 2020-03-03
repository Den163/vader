import 'package:vader_di/resolvers/custom_factory_resolver.dart';
import 'package:vader_di/resolvers/helpers/custom_factory.dart';
import 'package:vader_di/vader.dart';

/// It wraps [CustomFactoryResolver] , track it's all made dependencies and
/// dispose all when container was disposed
class DisposableCustomFactoryResolver<T, TArgs>
implements CustomFactoryResolver<T, TArgs>, Disposable {
  final CustomFactoryResolver<T, TArgs> customFactoryResolver;
  final void Function(T) disposer;
  final List<T> _emitted = <T>[];

  DisposableCustomFactoryResolver(
    this.customFactoryResolver,
    this.disposer,
  );

  @override
  T make(TArgs args) {
    final resolved = customFactoryResolver.make(args);
    _emitted.add(resolved);
    return resolved;
  }

  @override
  void dispose() => _emitted..forEach(disposer)..clear();

  @override
  CustomFactory<T, TArgs> resolve() => this;
}
