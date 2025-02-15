part of 'shelf_integration_test_server.dart';

final class ShelfProxyServer {
  ShelfProxyServer(this.address, this.port);

  Completer<HttpServer>? _server;

  final String address;
  final int port;
  final _mocks = <FakeHttpResponse>{};
  final _consumableMocks = <FakeHttpResponse>{};

  Router get handler => Router()
    ..all('/<ignored|.*>', (Request request) {
      for (final mock in _mocks) {
        if (mock.hasMatchInRequest(request)) {
          return buildResponseFromMock(mock);
        }
      }

      FakeHttpResponse? consumed;
      for (final mock in _consumableMocks) {
        if (mock.hasMatchInRequest(request)) {
          consumed = mock;
          break;
        }
      }

      if (consumed != null) {
        _consumableMocks.remove(consumed);
        return buildResponseFromMock(consumed);
      }

      return Response.internalServerError();
    });

  Middleware get filterMiddleware => (Handler innerHandler) {
        return (request) async {
          // FILTER REQUESTS
          return innerHandler(request);
        };
      };

  String get proxy => 'PROXY $address:$port';

  void setMock(FakeHttpResponse mock, {required bool consumable}) {
    if (consumable) {
      _consumableMocks.add(mock);
    } else {
      _mocks.add(mock);
    }
  }

  void removeMock(FakeHttpResponse mock) {
    _mocks.remove(mock);
    _consumableMocks.remove(mock);
  }

  Response buildResponseFromMock(FakeHttpResponse mock) {
    return Response(
      mock.statusCode,
      body: mock.response,
      headers: mock.headers,
      encoding: mock.encoding,
      context: mock.context,
    );
  }

  Future<void> start() async {
    final pipeline = const Pipeline().addMiddleware(filterMiddleware).addHandler(handler.call);
    _server = Completer()..complete(io.serve(pipeline, address, port));
    final server = await _server?.future;
    print('Server running on localhost:${server?.port}');
  }

  Future<void> stop() async {
    if (_server?.isCompleted ?? true) return;
    final server = await _server?.future;
    await server?.close();
    print('Server stopped');
  }
}
