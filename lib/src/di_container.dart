import 'package:vader_di/resolvers/resolvers.dart';
import 'package:vader_di/src/utils/disposable.dart';

/// DiContainer is a data structure that keep all dependencies resolvers
class DiContainer {
  final _resolvers = <Type, Resolver> {};
  final _typesToDispose = <Type, void Function(Object)>{};
  final _disposables = <Type, List<Disposable>> {};

  DiContainer get parent => _parent;
  DiContainer _parent;

  DiContainer([this._parent]);

  /// Add dependency resolver to the container.
  /// Note that value overwriting within same container is prohibited
  void add<T>(Resolver<T> context) {
    if (hasInTree<T>())
      throw StateError('Dependency of type `$T` is already exist in containers tree');

    _resolvers[T] = context;
  }

  void override<T>(Resolver<T> context) {
    _resolvers[T] = context;
  }

  void addDispose<T>(void Function(T) disposeFunc) {
    if (_typesToDispose.containsKey(T)) {
      throw StateError('Dispose for dependency of type `$T` '
                       'is already defined in the container');
    }

    // To satisfy strict compiler we need to cast Function(T) to Function(Object)
    _typesToDispose[T] = (Object o) => disposeFunc(o);
  }

  bool has<T>() => _resolvers.containsKey(T);
  bool hasInTree<T>() =>
      has<T>() ||
      (_parent != null && _parent.hasInTree<T>());

  T resolve<T extends Object>() {
    final resolved = tryResolve<T>();
    if (resolved != null) {
      return resolved;
    } else {
      throw StateError(
        'Can\'t resolve dependency `$T`. '
        'Maybe you forget register it?');
    }
  }

  T tryResolve<T>() {
    final resolver = _resolvers[T];

    if (resolver != null) {
      final resolved = resolver.resolve();
      if (_typesToDispose.containsKey(T)) _addDisposable<T>(resolved);

      return resolved;
    } else {
      return parent?.tryResolve();
    }
  }

  void _addDisposable<T>(T resolved) {
    final disposable = Disposable.from(
      object: resolved, dispose: _typesToDispose[T]);
    final disposablesList = _disposables[T];
    if (disposablesList != null) {
      disposablesList.add(disposable);
    } else {
      _disposables[T] = [ disposable ];
    }
  }

  void dispose() {
    _disposables.values.expand((v) => v).forEach((d) => d.dispose());
  }
}
