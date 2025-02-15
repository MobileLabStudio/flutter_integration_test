import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../http/fake_http_response.dart';
import '../integration_test_server.dart';

part 'shelf_proxy_server.dart';

final class ShelfIntegrationTestServer extends HttpOverrides implements IntegrationTestServer {
  late final _shelf = ShelfProxyServer();

  HttpOverrides get httpOverrides => this;

  @override
  Future<void> serve(IntegrationTestServerConfig config) async {
    await _shelf.serve(config.address, config.port, shared: config.shared);
  }

  @override
  Future<void> close() => _shelf.close();

  @override
  void mock(FakeHttpResponse mock) {
    _shelf.setMock(mock, consumable: false);
  }

  @override
  void mockAndConsume(FakeHttpResponse mock) {
    _shelf.setMock(mock, consumable: true);
  }

  @override
  void unmock(FakeHttpResponse mock) {
    _shelf.removeMock(mock);
  }

  @override
  String findProxyFromEnvironment(Uri url, Map<String, String>? env) {
    final mocks = [..._shelf._mocks, ..._shelf._consumableMocks];
    dev.log('🔎 Checking if proxy must be used - Examining ${mocks.length} mocks');
    for (final mock in mocks) {
      if (mock.hasMatchInUrl(url)) {
        dev.log('🔀 Using proxy for: $url');
        return _shelf.proxy;
      }
    }

    dev.log('📡 Ommiting proxy for: $url');
    return 'DIRECT';
  }
}
