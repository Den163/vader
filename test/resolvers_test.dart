import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart' as mockito;
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

  test('Factory creates value only after resolve() call', () {
    final spy = new SpyMock();
    final factoryResolver = new FactoryResolver(() => spy.onFactory());
    factoryResolver.onRegister();

    mockito.verifyNever(spy.onFactory());
    factoryResolver.resolve();
    mockito.verify(spy.onFactory());
  });

  test('Not singleton resolver resolves different values after multiple resolve() calls', () {
    final spy = new SpyMock();
    final factoryResolver = new FactoryResolver(() => spy.onFactory());
    factoryResolver.onRegister();

    const callCount = 3;

    for (var i = 0; i < 3; i++) factoryResolver.resolve();

    mockito.verify(spy.onFactory()).called(callCount);
  });
}


abstract class Spy {
  void onFactory();
  void dispose();
}
class SpyMock extends mockito.Mock implements Spy {}