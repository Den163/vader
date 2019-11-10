import 'dart:async';
import 'package:meta/meta.dart';

abstract class Disposable {
  static Disposable fromStreamSubscription<T>(StreamSubscription<T> sub) {
    return new _DisposableProxy<StreamSubscription<T>>(
      sub,
      (s) => s.cancel()
    );
  }

  static Disposable from<T>({
    @required T object,
    @required void Function(T) dispose
  }) {
    return new _DisposableProxy(object, dispose);
  }

  void dispose();
}

class _DisposableProxy<T> implements Disposable {
  final T disposable;
  final void Function(T) disposer;

  _DisposableProxy(this.disposable, this.disposer);

  @override
  bool operator ==(other) =>
    (other is _DisposableProxy<T> && other.disposable == disposable) ||
    other == disposable;

  @override
  int get hashCode => disposable.hashCode;

  @override
  void dispose() {
    disposer(disposable);
  }
}
