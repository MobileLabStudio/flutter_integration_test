import 'dart:io';

import 'package:meta/meta.dart';

import 'http/fake_http_response.dart';

abstract class IntegrationTestServer implements HttpOverrides {
  Future<void> serve(IntegrationTestServerConfig config);
  Future<void> close();
  void mock(FakeHttpResponse mock);
  void mockAndConsume(FakeHttpResponse mock);
  void unmock(FakeHttpResponse mock);
}

@immutable
final class IntegrationTestServerConfig {
  const IntegrationTestServerConfig({
    required this.address,
    required this.port,
    required this.shared,
  });

  const IntegrationTestServerConfig.localhost8888Shared()
      : address = 'localhost',
        port = 8888,
        shared = true;

  final String address;
  final int port;
  final bool shared;

  @override
  int get hashCode => Object.hashAll([address, port, shared]);

  @override
  bool operator ==(Object other) => other is IntegrationTestServerConfig && other.hashCode == hashCode;
}
