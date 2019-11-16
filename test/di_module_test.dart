import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:vader_di/vader.dart';

void main() {
  test('Bind to the value resolves with value', () {
    final b = new B();
    final module = new ModuleMock();
    when(module.register())
      .thenAnswer((_) => module.bind<A>().toValue(b));
    module.install();

    expect(
      module.resolve<A>(),
      b
    );
  });

  test('Bind to the same type in the same container throws error', () {
    final module = new ModuleMock();
    when(module.register()).thenAnswer(
        (_) {
          module.bind<A>().toValue(new B());
          module.bind<A>().toValue(new B());
        });

    expect(
      () => module.install(),
      throwsA(isInstanceOf<StateError>())
    );
  });

  test('Bind to the factory resolves with value', () {
    final module = new ModuleMock();
    var b;
    when(module.register())
      .thenAnswer((_) => module.bind<A>().toPureFactory(() => b = new B()));
    module.install();

    expect(
      module.resolve<A>(),
      b
    );
  });

  test('Bind to the factory1 resolves value with dependency', () {
    final module = new ModuleMock();
    final b = new B();
    when(module.register())
      .thenAnswer((_) {
        module.bind<A>().toValue(b);
        module.bind<DependOnA>().toFactory1<A>((a) => DependOnA(a));
      });
    module.install();

    expect(
      module.resolve<DependOnA>().a,
      b
    );
  });

  test('Child container can resolve parent container\'s value', () {
    final moduleA = new ModuleMock();
    final b = new B();
    when(moduleA.register())
      .thenAnswer((_) => moduleA.bind<A>().toValue(b));
    moduleA.install();

    final containerB = new DiContainer(moduleA.container);
    final moduleB = new ModuleMock(containerB);
    final a = moduleB.resolve<A>();

    expect(b, a);
  });
}

class ModuleMock extends DiModule with Mock {
  ModuleMock([DiContainer container]) : super(container);
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
