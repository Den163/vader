import 'package:disposable_utils/disposable_utils.dart';
import 'package:vader_di/resolvers/resolvers.dart';

/// DiContainer is a data structure that keep all dependencies resolvers
class DiContainer {
  final _resolvers = <Type, ResolvingContext> {};
  final _typesToDispose = <Type, void Function(Object)>{};
  final _disposables = <Type, List<Disposable>> {};

  DiContainer? get parent => _parent;
  final DiContainer? _parent;

  DiContainer([this._parent]);

  /// Adds dependency resolver of type [T] to the container.
  /// Note that value overwriting within same container is prohibited.
  /// If you need it, please use [override] method instead.
  ResolvingContext<T> bind<T>() {
    final context = new ResolvingContext<T>(this);
    if (hasInTree<T>())
      throw StateError('Dependency of type `$T` is already exist in containers tree');

    _resolvers[T] = context;

    return context;
  }

  /// Overrides dependency resolver for type [T] in the container
  ResolvingContext<T> override<T>() {
    final context = new ResolvingContext<T>(this);
    _resolvers[T] = context;

    return context;
  }

  /// Defines dispose strategy for type [T].
  /// (It calls for every resolved dependency of type [T]
  /// when container's [dispose] was invoked
  void addDispose<T>(void Function(T) disposeFunc) {
    if (_typesToDispose.containsKey(T)) {
      throw StateError('Dispose for dependency of type `$T` '
                       'is already defined in the container');
    }

    // To satisfy strict compiler we need to cast Function(T) to Function(Object)
    _typesToDispose[T] = (Object o) => disposeFunc(o as T);
  }

  /// Returns true if this container has dependency resolver for type [T}.
  /// If you want to check it for the whole containers tree,
  /// use [hasInTree] instead.
  bool has<T>() => _resolvers.containsKey(T);

  /// Returns true if the container
  /// or it's parents contains dependency resolver for type [T].
  /// If you want to check it only for this container,
  /// use [has] instead.
  bool hasInTree<T>() =>
      has<T>() ||
      (_parent?.hasInTree<T>() ?? false);

  /// Returns resolved dependency defined by type parameter [T].
  /// Throws [StateError] if dependency can't be resolved.
  /// If you want to get [null] if dependency can't be resolved,
  /// use [tryResolve] instead
  T resolve<T>() {
    final resolved = tryResolve<T>();
    if (resolved != null) {
      return resolved;
    } else {
      throw StateError(
        'Can\'t resolve dependency `$T`. '
        'Maybe you forget register it?');
    }
  }

  /// Returns resolved dependency of type [T] or null
  /// if it can't be resolved.
  T? tryResolve<T>() {
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
    final disposable = Disposable.create(
      resolved, _typesToDispose[T] as void Function(T));
    final disposablesList = _disposables[T];
    if (disposablesList != null) {
      disposablesList.add(disposable);
    } else {
      _disposables[T] = [ disposable ];
    }
  }

  /// Disposes all resolved dependencies by the container and clear all dependencies
  void dispose() {
    _disposables.values.expand((v) => v).forEach((d) => d.dispose());
    _disposables.clear();
    _resolvers.clear();
  }
}
