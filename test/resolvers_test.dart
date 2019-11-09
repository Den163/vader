import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:veider/resolvers/resolvers.dart';

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
    factoryResolver.onRegister();

    expect(
      factoryResolver.resolve(),
      expected
    );
  });

  test('Factory creates immediatly, without waiting for resolve() call', () {
    final spy = new SpyMock();
    final factoryResolver = new FactoryResolver(() => spy.onFactory());
    factoryResolver.onRegister();

    expect(spy.counter, 1);
  });

  test('Factory resolver resolves same value after multiple resolve() calls', () {
    final spy = new SpyMock();
    final factoryResolver = new FactoryResolver(() => spy.onFactory());
    factoryResolver.onRegister();

    factoryResolver.resolve();
    factoryResolver.resolve();
    factoryResolver.resolve();

    expect(spy.counter, 1);
  });

  test('Lazy resolver creates value only after resolve() call', () {
    final spy = new SpyMock();
    final factoryResolver = new FactoryResolver(() => spy.onFactory());
    final lazyResolver = new LazyResolver(factoryResolver);

    expect(spy.counter, 0);
    lazyResolver.resolve();
    expect(spy.counter, 1);
  });

  test('Lazy resolver resolves same value after multiple resolve() call', () {
    final spy = new SpyMock();
    final factoryResolver = new FactoryResolver(() => spy.onFactory());
    final lazyResolver = new LazyResolver(factoryResolver);

    lazyResolver.resolve();
    lazyResolver.resolve();
    lazyResolver.resolve();

    expect(spy.counter, 1);
  });
}


abstract class Spy {
  int get counter;
  void onFactory();
}
class SpyMock extends Mock  implements Spy {
  @override int get counter => _counter;

  var _counter = 0;
  void onFactory() => _counter++;
}