import 'package:flutter_test/flutter_test.dart';
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
    final spy = new Spy();
    final factoryResolver = new FactoryResolver(() => spy.onFactory());
    factoryResolver.onRegister();

    expect(spy.checkedOnFactory, true);
  });

  test('Lazy resolver creates value only after resolve() call', () {
    final spy = new Spy();
    final factoryResolver = new FactoryResolver(() => spy.onFactory());
    final lazyResolver = new LazyResolver(factoryResolver);

    expect(spy.checkedOnFactory, false);
    lazyResolver.resolve();
    expect(spy.checkedOnFactory, true);
  });
}


class A {}
class Spy implements A {
  bool get checkedOnFactory => _checked;
  var _checked = false;

  void onFactory() => _checked = true;
}