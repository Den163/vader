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