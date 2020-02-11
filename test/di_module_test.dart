import 'package:flutter_test/flutter_test.dart';
import 'package:vader_di/vader.dart';

void main() {
  test('Bind to the value resolves with value', () {
    final b = new B();
    final module = new DiContainer();
    module.bind<A>().toValue(b);

    expect(
      module.resolve<A>(),
      b
    );
  });

  test('Bind to the same type in the same container throws error', () {
    final module = new DiContainer();
    module.bind<A>().toValue(new B());

    expect(
      () => module.bind<A>().toValue(new B()),
      throwsA(isInstanceOf<StateError>())
    );
  });

  test('Bind to the factory resolves with value', () {
    final module = new DiContainer();
    var b;
    module.bind<A>().toPureFactory(() => b = new B());

    expect(
      module.resolve<A>(),
      b
    );
  });

  test('Bind to the factory1 resolves value with dependency', () {
    final module = new DiContainer();
    final b = new B();
    module.bind<A>().toValue(b);
    module.bind<DependOnA>().toFactory1<A>((a) => DependOnA(a));

    expect(
      module.resolve<DependOnA>().a,
      b
    );
  });

  test('Child container can resolve parent container\'s value', () {
    final moduleA = new DiContainer();
    final b = new B();
    moduleA.bind<A>().toValue(b);

    final containerB = new DiContainer(moduleA);
    final moduleB = new DiContainer(containerB);
    final a = moduleB.resolve<A>();

    expect(b, a);
  });
}

abstract class A {}
class B implements A {}
class C implements A {}

class DependOnA {
  final A a;

  DependOnA(this.a) : assert(a != null);
}

class T1 {}
class T2 {}
class T3 {}
class T4 {}
class T5 {}
class T6 {}
class T7 {}
class T8 {}
