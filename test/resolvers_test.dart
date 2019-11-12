import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart' as mockito;
import 'package:vader/resolvers/resolvers.dart';
import 'package:vader/resolvers/singleton_resolver.dart';

void main() {
  test('Value resolver resolves with selected value', () {
    var a = 3;
    final valResolver = new ValueResolver(a);

    expect(
      valResolver.resolve(),
      a
    );
  });

  test('Factory resolver resolves with factory', () {
    const expected = 3;
    final factoryResolver = new FactoryResolver(() => expected);

    expect(
      factoryResolver.resolve(),
      expected
    );
  });

  test('Factory creates value only after resolve() call', () {
    final spy = new SpyMock();
    final factoryResolver = new FactoryResolver(() => spy.onFactory());

    mockito.verifyNever(spy.onFactory());
    factoryResolver.resolve();
    mockito.verify(spy.onFactory());
  });

  test('Not singleton resolver resolves different values after multiple resolve() calls', () {
    const callCount = 3;
    final spy = new SpyMock();
    final factoryResolver = new FactoryResolver(() => spy..onFactory());

    for (var i = 0; i < callCount; i++) factoryResolver.resolve();

    mockito.verify(spy.onFactory()).called(callCount);
  });

  test('Singleton resolver resolves same value after multiple resolve() calls', () {
    const callCount = 3;
    final spy = new SpyMock();
    final singletonResolver = new SingletonResolver(
      new FactoryResolver(() => spy..onFactory())
    );

    for (var i = 0; i < callCount; i++) singletonResolver.resolve();

    mockito.verify(spy.onFactory()).called(1);
  });
}


abstract class Spy {
  void onFactory();
  void dispose();
}
class SpyMock extends mockito.Mock implements Spy {}