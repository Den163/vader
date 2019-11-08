import 'package:veider/resolvers/resolvers.dart';
import 'package:veider/src/di_container.dart';

/// Binds interface to another type of instance
class ToResolver<T, TImpl extends T> extends Resolver<T> {
  final DiContainer container;

  ToResolver(this.container);

  @override
  T resolve() => container.resolve<TImpl>();
}