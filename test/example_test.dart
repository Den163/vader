import 'package:flutter_test/flutter_test.dart';
import 'package:vader/vader.dart';

void main() {
  test('Module resolves all dependencies', () {
    const expectedResult = 'ABC';
    final module = new ModuleA();
    module.install();
    final resolvedService = module.resolve<ServiceA>();

    expect(
      resolvedService.doA(),
      expectedResult
    );
  });
}

class ModuleA extends DiModule {
  @override
  void register() {
    bind<ServiceB>().toValue(new ServiceB());
    bind<ServiceC>().toValue(new ServiceC());
    bind<ServiceA>().toFactory2<ServiceB, ServiceC>(
      (b, c) => ServiceAImplementation(b, c));
  }
}

abstract class ServiceA {
  String doA();
}

class ServiceAImplementation implements ServiceA {
  final ServiceB serviceB;
  final ServiceC serviceC;

  ServiceAImplementation(this.serviceB, this.serviceC);

  @override
  String doA() => 'A' + serviceB.doB() + serviceC.doC();
}

class ServiceB {
  String doB() => 'B';
}
class ServiceC {
  String doC() => 'C';
}