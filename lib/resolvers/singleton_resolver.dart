import 'package:veider/resolvers/di_resolver.dart';
import 'package:veider/src/di_container.dart';

class SingletonResolver<T> extends Resolver<T> {
  SingletonResolver<T> singletonResolver(DiContainer diContainer) {

  }

  @override
  T resolve() {
    // TODO: implement resolve
    return null;
  }
}