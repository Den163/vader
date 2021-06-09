import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vader_di/src/di_container.dart';
import 'package:vader_di/resolvers/helpers/custom_factories_methods.dart';
import 'package:vader_di/resolvers/helpers/creating_resolving_methods.dart';
import 'package:vader_di/vader.dart';

void main() {
  test('DiContainer binds with from and makes with custom factory', () {
    const expected = 5;
    final container = new DiContainer();
    container.bindCustomFactory<A, AArgs>()..from((args) => A(args));

    final a = container.make<A, AArgs>(new AArgs(expected));
    expect(a.args.value, expected);
  });

  test('DiContainer binds with from1 and makes with custom factory', () {
    const expected = 5;
    final container = new DiContainer();
    container.bind<B>().from(() => new B());
    container.bindCustomFactory<A, AArgs>()..from1<B>((b, args) => A(args, b));

    final a = container.make<A, AArgs>(new AArgs(expected));
    expect(a.args.value, expected);
    expect(a.b, isNotNull);
  });

  test('DiContainer custom factory works with disposing', () {
    final container = new DiContainer();
    container
        .bindCustomFactory<Disposable, AArgs>()
        .from((args) => DisposableMock())
        .withDispose((disposable) => disposable.dispose());

    final a = container.make<Disposable, AArgs>(new AArgs(5));
    final a2 = container.make<Disposable, AArgs>(new AArgs(5));

    container.dispose();

    verify(a.dispose());
    verify(a2.dispose());
  });
}

class A {
  final AArgs args;
  final B? b;

  A(this.args, [this.b]);
}

class B {}

class DisposableMock extends Mock implements Disposable {}

class AArgs {
  final int value;

  AArgs(this.value);
}
