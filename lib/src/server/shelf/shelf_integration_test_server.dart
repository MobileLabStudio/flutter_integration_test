import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../http/fake_http_response.dart';
import '../integration_test_server.dart';

part 'shelf_proxy_server.dart';

final class ShelfIntegrationTestServer implements IntegrationTestServer, HttpOverrides {
  ShelfIntegrationTestServer([String proxyAddress = 'localhost', int proxyPort = 8888])
      : _proxyServer = ShelfProxyServer(proxyAddress, proxyPort);

  late final ShelfProxyServer _proxyServer;

  HttpOverrides get httpOverrides => this;

  @override
  Future<void> serve() => _proxyServer.start();

  @override
  Future<void> close() => _proxyServer.stop();

  @override
  void mockResponse(FakeHttpResponse mock) {
    _proxyServer.setMock(mock, consumable: false);
  }

  @override
  void mockConsumableResponse(FakeHttpResponse mock) {
    _proxyServer.setMock(mock, consumable: true);
  }

  @override
  void unMockResponse(FakeHttpResponse mock) {
    _proxyServer.removeMock(mock);
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    HttpOverrides.global = null;
    final client = HttpClient(context: context);
    HttpOverrides.global = this;
    return client;
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? _) {
    for (final mock in [..._proxyServer._mocks, ..._proxyServer._consumableMocks]) {
      if (mock.hasMatchInUrl(url)) {
        return _proxyServer.proxy;
      }
    }

    return 'DIRECT';
  }
}
