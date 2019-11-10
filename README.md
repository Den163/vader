# veider

A simple dependency injection library for personal needs inspired by C# ninject fluent builder style. Now it's just a some kind of an experiment and doesn't at production-ready stage 

Example (from ```example_test.dart```): 

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:veider/veider.dart';

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
```

## TODO:
1. Add flutter bindings (via provider package or standalone?)
2. Add async resolving support
3. Improve perfomance

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
