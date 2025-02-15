import '../../../flutter_integration_test.dart';

abstract class IntegrationTestServerPool {
  IntegrationTestServerConfig findConfig();
  void releasePort(int port);
}
