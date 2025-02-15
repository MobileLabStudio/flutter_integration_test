part of 'shelf_integration_test_server.dart';

final class ShelfProxyServer {
  Completer<HttpServer>? _server;

  final _mocks = <FakeHttpResponse>{};
  final _consumableMocks = <FakeHttpResponse>{};
  String? _proxy;
  String get proxy {
    if (_proxy == null) throw StateError('Cannot obtain proxy. The server is not started yet');
    return _proxy!;
  }

  Router get handler => Router()
    ..all('/<ignored|.*>', (Request request) {
      Response? response;

      for (final mock in _mocks) {
        if (mock.hasMatchInRequest(request)) {
          response = buildResponseFromMock(mock);
          break;
        }
      }

      if (response == null) {
        for (final mock in _consumableMocks) {
          if (mock.hasMatchInRequest(request)) {
            response = buildResponseFromMock(mock);
            _consumableMocks.remove(mock);
            break;
          }
        }
      }

      if (response != null) {
        dev.log('✏️ Mocked response for request - ${request.method} /${request.url}');
        return response;
      }

      return Response.internalServerError();
    });

  Middleware get filterMiddleware => (Handler innerHandler) {
        return (request) async {
          // FILTER REQUESTS
          return innerHandler(request);
        };
      };

  void setMock(FakeHttpResponse mock, {required bool consumable}) {
    if (consumable) {
      _consumableMocks.add(mock);
      dev.log('➕🍴 Registered consumable mock - $mock');
    } else {
      _mocks.add(mock);
      dev.log('➕ Registered mock - $mock');
    }
  }

  void removeMock(FakeHttpResponse mock) {
    if (_mocks.remove(mock)) {
      _mocks.remove(mock);
      dev.log('➕ Unregistered mock');
    } else if (_consumableMocks.remove(mock)) {
      _consumableMocks.remove(mock);
      dev.log('➕🍴 Unregistered consumable mock');
    }
  }

  Response buildResponseFromMock(FakeHttpResponse mock) {
    return Response(
      mock.statusCode,
      body: mock.body,
      headers: mock.headers,
      encoding: mock.encoding,
      context: mock.context,
    );
  }

  Future<void> serve(String address, int port, {required bool shared}) async {
    dev.log('🚀 Starting server ...');
    try {
      final pipeline = const Pipeline().addMiddleware(filterMiddleware).addHandler(handler.call);
      _server = Completer()
        ..complete(
          io.serve(
            pipeline,
            address,
            port,
            shared: shared,
          ),
        );
      final server = await _server?.future;
      final serverHost = server?.address.host;
      final serverPort = server?.port;
      _proxy = 'PROXY $serverHost:$serverPort';
      dev.log('🛰️ Server responds at $serverHost:$serverPort');
    } catch (e, st) {
      dev.log('💥🚀 Failed to start the server', error: e, stackTrace: st);
    }
  }

  Future<void> close() async {
    final server = await _server?.future;
    _server = null;
    _proxy = null;
    final address = server?.address.host;
    final port = server?.port;
    dev.log('🍃 Stopping server $address:$port ...');
    await server?.close(force: true);
    dev.log('☕ Stopped server $address:$port');
  }
}
