import 'dart:io';

import 'http/fake_http_response.dart';

abstract class IntegrationTestServer implements HttpOverrides {
  Future<void> serve();
  Future<void> close();
  void mockResponse(FakeHttpResponse mock);
  void mockConsumableResponse(FakeHttpResponse mock);
  void unMockResponse(FakeHttpResponse mock);
}
