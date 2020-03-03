# vader_di

A simple, flexible and platform agnostic Dependency Injection library with convenient syntax.
Note that it just core and it doesn't using any reflection, code generation or wrappers to easy
integrate with different approaches to different dart projects

If you need a Flutter integration look for package [vader_flutter] (https://pub.dev/packages/vader_flutter).
It contains widget wrappers and helpers to work with Inversion of Control principle

### News
New cool feature - Custom Factories. Create and dispose objects with parameters which not known at the
container configuration time. Documentation will be soon
 
### Getting Started
The main class for all operations is `DiContainer`. You can register your dependencies by getting
`ResolvingContext` via` bind<T>() `method and using it different resolving variations methods.
Next, you can get dependencies through `resolve<T>()`.
For example:

```dart
final container = new DiContainer();
container.bind <SomeService>().toValue(new SomeServiceImplementation());
/ *
...
 * /

// It's just returns the registered earlier instance
final someService = container.resolve<SomeService>();
```

# Lazy construction

Usually you create an instance of some object in the place you really need it. So you can
use lazy (on demand in other words) construction of the object through `from` method. For example:

```dart
final container = new DiContainer();
// In the from method you just define HOW to construct an instance through the factory lambda
container.bind<SomeService>().from(() => new SomeService());
/ *
...
 * /
// It will construct an instance through registered factory lambda every time you invoke it
final someService = container.resolve<SomeService>();
final anotherSomeService = container.resolve<SomeService>();
assert (someService != anotherSomeService);
```

But usually, you have many types with different dependencies, which form a dependency graph.
For example:

```dart
class A {}
class B {}

class C {
  final A a;
  final B b;
  
  B (this.a, this.b);
}
```

If you need to register some type dependent on other types from the container, you can use
`from1<T1>` - `from8<T1...T8>` methods,
where the number, in the end, is the amount of requested through type arguments dependencies.
(Note, that you need to define all of the dependencies in the type arguments - `from2<A1, A2>`).
For example:

```dart
class SomeService {
  final A a;
  final B b;
  
  SomeService(this.a, this.b)
}

final container = new DiContainer ();
container.bind<A>().from (() => new A());
container.bind<B>().from (() => new B());

/// Now in the factory lambda you define HOW to construct a dependency from other dependencies
/// (Order of resolved instances is according to the order of type arguments)
container.bind<SomeService>().from2<A, B>((a, b) => new SomeService(a, b));

/ *
...
 * /

/// It resolves some service through resolving it's dependencies.
/// In our case - it's resolving A and B
/// Note !!! That it will create new instances of A and B every time you invoke resolving of
/// SomeService
final someService = container.resolve<SomeService>();
```

# Instances life time and scopes control

But what can you do, if you want to create an instance of registered dependency only one time, but
you need to get/resolve it many times in the container? Singleton pattern? God forbid!
You can register your dependency with `asSingeton ()` addition. For example:

```dart
final container = new DiContainer();
container.bind<A>()
  .from (() => new A())
  .asSingleton();

container
  .bind<B>()
  .from(() => new B())
  .asSingleton();

container.bind<SomeService>().from2<A, B>((a, b) => SomeService(a, b));

// Code above means: Container, please register A and B creation
// only for the first time it will be requested, and register SomeService creation
// every time it will be requested.

final a = container.resolve<A>();
final b = container.resolve<B>();
final anotherA = container.resolve<A>();
final anotherB = container.resolve<B>();

assert(a == anotherA && b == anotherB);

final someService = container.resolve<SomeService>();
final anotherSomeService = container.resolve<SomeService>();

assert(someService != anotherSomeService);
```

If you want to immediately construct your registered instance you can invoke `resolve()`. For example:

```dart
final container = new DiContainer();
// It will force to resolve dependency creation after registration
container.bind <SomeService>()
  .from(() => new SomeService ())
  .asSingleton()
  .resolve();
```

When you work with the complex app, in most cases you can deal with many modules with its own dependencies.
These modules can be configured by different `DiContainer`s. So you need to compose your app with many containers.
There is no problem with it in Vader because you can attach the container to the other as a parent.
In this case parent's dependencies will be visible for child container and through it you can form different
dependencies scopes. For example:

```dart
final parentContainer = new DiContainer();
parentContainer.bind<A>().from(() => new A());

final childContainer = new DiContainer(parentContainer);
// Note that parent dependency A is visible for child container
final a = childContainer.resolve<A>();

/*
// But the next code will fail with an error because a parent does not know about its child.
final parentContainer = new DiContainer();
final childContainer = new DiContainer();
childContainer.bind<A>().from(() => new A());

// Throws error
final a = parentContainer.resolve<A>();
 */
```

In some cases your classes can capture some resources or subscriptions you want to close after 
using an instance. To deal with it you can register dispose strategy through `withDispose()` with 
disposing lambda. It will be invoked after your container's `dispose` method will be invoked. 
Note that if you define dispose strategy container will track all of resolved instances and 
call its disposes when it will be disposed. For example :

```dart
final container = DiContainer();
container.bind<A>()
  .from(() => new A())
  .withDispose((a) => a.dispose());

final a = container.resolve<A>();
final anotherA = container.resolve<A>();

/// a and anotherA will be disposed
container.dispose();
```

Note that disposing strategy is has no influence on containers children or parents. So if you want 
to dispose the whole containers tree, you need to dispose each child separately
 
### Library Design
The library design is very simple. It consist of `DiContainer` and `Resolver`s. 
`DiContainer` is a container with all `Resolver`s for different types. And `Resolver` is just an object
that knows how to resolve a given type. Many of resolvers are decorated by others, so it can be composed 
for different use-cases. 
`Resolver` is an abstract class so it has many implementations. Main one is the `ResolvingContext`. 
You can think about it as a context object that has helper methods for creating different resolving 
variations (`from`, `toValue`, `asSingleton`, `withDispose`, etc). But they all just using `toResolver` 
method to define some root resolver in the context.
When you request type from container with `resolve<T>()` method, it just find context for type and 
invokes root resolver, that can invoke other decorated resolvers.

Example (from ```example.dart```): 

```dart
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:vader_di/vader.dart';

void main() async {
  final dataModule = new DiContainer()
    ..bind<ApiClient>().toValue(new ApiClientMock())
    ..bind<DataService>().from1<ApiClient>((c) => new NetworkDataService(c))
    ..bind<DataBloc>().from1<DataService>((s) => new DataBloc(s));

  final dataBloc = dataModule.resolve<DataBloc>();
  dataBloc.data.listen(
    (d) => print('Received data: $d'),
    onError: (e) => print('Error: $e'),
    onDone: () => print('DONE')
  );

  await dataBloc.fetchData();
}

class DataBloc {
  final DataService _dataService;

  Stream<String> get data => _dataController.stream;
  StreamController<String> _dataController = new StreamController.broadcast();

  DataBloc(this._dataService);

  Future<void> fetchData() async {
    try {
      _dataController.sink.add(await _dataService.getData());
    } catch (e) {
      _dataController.sink.addError(e);
    }
  }

  void dispose() {
    _dataController.close();
  }
}

abstract class DataService {
  Future<String> getData();
}

class NetworkDataService implements DataService {
  final ApiClient _apiClient;
  final _token = '12345';

  NetworkDataService(this._apiClient);

  @override
  Future<String> getData() async =>
    await _apiClient.sendRequest(
      url: 'www.data.com', 
      token: _token, 
      requestBody: { 'type' : 'data' });
}

abstract class ApiClient {
  Future sendRequest({@required  String url, String token, Map requestBody});
}

class ApiClientMock implements ApiClient {
  @override
  Future sendRequest({@required String url, String token, Map requestBody}) async {
    return 'mock body';
  }
}
```