import 'package:disposable_utils/disposable_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:vader_di/vader.dart';

import 'di_container_test.mocks.dart';

@GenerateMocks(
    [Disposable],
    customMocks: [
      MockSpec<DisposableBaseResolver>(as: #MockDisposableResolver),
      MockSpec<IntBaseResolver>(as: #MockIntResolver)
])
void main() {
  group('Without parent', () {
    test('Container add<T> throws state error if it\'s already has resolver', () {
      final container = new DiContainer();
      container.bind<int>().toResolver(_makeIntResolver(5));

      expect(
        () => container.bind<int>().toResolver(_makeIntResolver(3)),
        throwsA(isInstanceOf<StateError>())
      );
    });

    test('Container resolves value after adding a dependency', () {
      const expectedValue = 3;
      final container = new DiContainer();
      container.bind<int>().toResolver(_makeIntResolver(expectedValue));
      expect(container.resolve<int>(), expectedValue);
    });

    test('Container throws state error if the value can\'t be resolved', () {
      final container = new DiContainer();
      expect(
        () => container.resolve<int>(),
        throwsA(isInstanceOf<StateError>())
      );
    });

    test('Container has<T>() returns true if it has resolver', () {
      final container = new DiContainer();
      container.bind<int>().toResolver(_makeIntResolver(3));
      expect(container.has<int>(), true);
    });

    test('Container has<T> returns false if it hasn\'t resolver', () {
      final container = new DiContainer();
      expect(container.has<int>(), false);
    });

    test('Container hasInTree<T> returns true if it has resolver', () {
      final container = new DiContainer();
      container.bind<int>().toResolver(_makeIntResolver(3));
      expect(container.hasInTree<int>(), true);
    });

    test('Container hasInTree<T> returns false if it hasn\'t value', () {
      final container = new DiContainer();
      expect(container.hasInTree<int>(), false);
    });

    test('Container dispose() disposes values properly', () {
      const resolutionsCount = 3;
      final container = new DiContainer();
      final disposable = new MockDisposable();

      container.bind<Disposable>().toResolver(
        _makeDisposableResolver(disposable)
      );
      container.addDispose<Disposable>((disposable) => disposable.dispose());

      for (var i = 0; i < resolutionsCount; i++) {
        container.resolve<Disposable>();
      }

      container.dispose();
      verify(disposable.dispose()).called(resolutionsCount);
    });
  });

  group('With parent', () {
    test('Container add<T> throws state error '
         'if it\'s parent already has a resolver', () {
      final parentContainer = new DiContainer();
      final container = new DiContainer(parentContainer);

      parentContainer.bind<int>().toResolver(_makeIntResolver(5));

      expect(
        () => container.bind<int>().toResolver(_makeIntResolver(3)),
        throwsA(isInstanceOf<StateError>())
      );
    });

    test('Container resolve<T> returns a value from parent container', () {
      const expectedValue = 3;
      final parentContainer = new DiContainer();
      final container = new DiContainer(parentContainer);

      parentContainer.bind<int>().toResolver(_makeIntResolver(expectedValue));

      expect(container.resolve<int>(), expectedValue);
    });

    test('Container resolve<T> throws a state error if parent hasn\'t value too', () {
      final container = new DiContainer(new DiContainer());
      expect(
          () => container.resolve<int>(),
          throwsA(isInstanceOf<StateError>())
      );
    });

    test('Container has<T> returns false if parent has a resolver', () {
      final parentContainer = new DiContainer();
      final container = new DiContainer(parentContainer);

      parentContainer.bind<int>().toResolver(_makeIntResolver(3));

      expect(container.has<int>(), false);
    });

    test('Container has<T> returns false if parent hasn\`t a resolver', () {
      final container = new DiContainer(new DiContainer());
      expect(container.has<int>(), false);
    });

    test('Container hasInTree<T> returns true if parent has a resolver', () {
      final parentContainer = new DiContainer();
      final container = new DiContainer(parentContainer);

      parentContainer.bind<int>().toResolver(_makeIntResolver(3));

      expect(container.hasInTree<int>(), true);
    });

    test('Container dispose() doesn\'t disposes values in parent container', () {
      const resolutionsCount = 3;
      final parentContainer = new DiContainer();
      final container = new DiContainer(parentContainer);

      final disposable = new MockDisposable();
      parentContainer.bind<Disposable>().toResolver(
        _makeDisposableResolver(disposable)
      );
      parentContainer.addDispose<Disposable>((disposable) => disposable.dispose());

      for (var i = 0; i < resolutionsCount; i++) {
        container.resolve<Disposable>();
      }

      container.dispose();
      verifyNever(disposable.dispose());
    });

    test(
      "Disposing of child container " 
      "shouldn't dispose parent container's dependencies", () {
        DiContainer containerA = new DiContainer();
        DiContainer containerB = DiContainer(containerA);

        final disposableMock = new MockDisposable();
        containerA.bind<Disposable>()
          .toValue(disposableMock)
          .withDispose((mock) => mock.dispose())
          .asSingleton();

        containerB.resolve<Disposable>();
        containerB.dispose();

        verifyNever(disposableMock.dispose());
      });
  });

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
    module.bind<A>().from(() => b = new B());

    expect(
      module.resolve<A>(),
      b
    );
  });

  test('Bind to the factory1 resolves value with dependency', () {
    final module = new DiContainer();
    final b = new B();
    module.bind<A>().toValue(b);
    module.bind<DependOnA>().from1<A>((a) => DependOnA(a));

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

MockDisposableResolver _makeDisposableResolver(Disposable expectedValue) {
  final resolverMock = new MockDisposableResolver();
  when(resolverMock.resolve()).thenReturn(expectedValue);
  return resolverMock;
}

MockIntResolver _makeIntResolver(int expectedValue) {
  final resolverMock = new MockIntResolver();
  when(resolverMock.resolve()).thenReturn(expectedValue);
  return resolverMock;
}

class IntBaseResolver extends Resolver<int> {
  @override
  int resolve() => 0;
}

class DisposableBaseResolver extends Resolver<Disposable> {
  @override
  Disposable resolve() => Disposable.create(0, (_) {});
}

abstract class A {}
class B implements A {}

class DependOnA {
  final A a;

  DependOnA(this.a);
}
