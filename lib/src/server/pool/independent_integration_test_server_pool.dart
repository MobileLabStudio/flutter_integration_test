import '../../../flutter_integration_test.dart';

typedef PORT = int;

final class IndependentIntegrationTestServerPool extends IntegrationTestServerPool {
  IndependentIntegrationTestServerPool._();

  static IndependentIntegrationTestServerPool? _instance;

  static IndependentIntegrationTestServerPool get instance => _instance ??= IndependentIntegrationTestServerPool._();

  final String address = 'localhost';
  final bool shared = false;

  @override
  IntegrationTestServerConfig findConfig() {
    return IntegrationTestServerConfig(
      address: address,
      port: 0, // Let the system assign available port
      shared: shared,
    );
  }

  @override
  void releasePort(int _) {
    // DO NOTHING
  }
}
