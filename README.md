# vader_di

A simple dependency injection library for personal needs inspired by C# ninject fluent builder style. Now it's just a some kind of an experiment and doesn't at production-ready stage 

Example (from ```example.dart```): 

```dart
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:vader_di/vader_di.dart';

void main() async {
  final dataModule = new DataModule();
  dataModule.install();

  final dataBloc = dataModule.resolve<DataBloc>();
  dataBloc.data.listen(
    (d) => print('Received data: $d'),
    onError: (e) => print('Error: $e'),
    onDone: () => print('DONE')
  );

  await dataBloc.fetchData();
}

class DataModule extends DiModule {
  @override
  void register() {
    bind<ApiClient>().toValue(new ApiClientMock());
    bind<DataService>().toFactory1<ApiClient>((c) => new NetworkDataService(c));
    bind<DataBloc>().toFactory1<DataService>((s) => new DataBloc(s));
  }
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
