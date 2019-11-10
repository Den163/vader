import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:veider/resolvers/resolvers.dart';
import 'package:veider/src/di_container.dart';

void main() {
  group('Without parent', () {
    test('Container resolves value after adding a dependency', () {
      const expectedValue = 3;
      final container = new DiContainer();
      container.add(_makeResolver(expectedValue));
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
      container.add(_makeResolver(3));
      expect(container.has<int>(), true);
    });

    test('Container has<T> returns false if it hasn\'t resolver', () {
      final container = new DiContainer();
      expect(container.has<int>(), false);
    });

    test('Container hasInTree<T> returns true if it has resolver', () {
      final container = new DiContainer();
      container.add(_makeResolver(3));
      expect(container.hasInTree<int>(), true);
    });

    test('Container hasInTree<T> returns false if it hasn\'t value', () {
      final container = new DiContainer();
      expect(container.hasInTree<int>(), false);
    });
  });

  group('With parent', () {
    test('Container resolve<T> returns a value from parent container', () {
      const expectedValue = 3;
      final parentContainer = new DiContainer();
      final container = new DiContainer(parentContainer);

      parentContainer.add(_makeResolver(expectedValue));

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

      parentContainer.add(_makeResolver(3));

      expect(container.has<int>(), false);
    });

    test('Container has<T> returns false if parent hasn\`t a resolver', () {
      final container = new DiContainer(new DiContainer());
      expect(container.has<int>(), false);
    });

    test('Container hasInTree<T> returns true if parent has a resolver', () {
      final parentContainer = new DiContainer();
      final container = new DiContainer(parentContainer);

      parentContainer.add(_makeResolver(3));

      expect(container.hasInTree<int>(), true);
    });
  });
}

ResolverMock<T> _makeResolver<T>(T expectedValue) {

  final resolverMock = new ResolverMock<T>();
  when(resolverMock.resolve()).thenReturn(expectedValue);
  return resolverMock;
}

class ResolverMock<T> extends Mock implements Resolver<T> {

}