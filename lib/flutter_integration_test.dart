import 'dart:developer' as dev;
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'src/binding/flutter_integration_test_widgets_flutter_binding.dart';
import 'src/server/integration_test_server.dart';
import 'src/server/pool/independent_integration_test_server_pool.dart';
import 'src/server/shelf/shelf_integration_test_server.dart';

export 'src/binding/flutter_integration_test_widgets_flutter_binding.dart';
export 'src/server/http/fake_http_response.dart';
export 'src/server/integration_test_server.dart';
export 'src/server/pool/integration_test_server_pool.dart';

typedef FlutterIntegrationTestCallback = Future<void> Function(
  WidgetTester tester,
  IntegrationTestServer server,
);

@isTest
void integrationTest(
  String description,
  FlutterIntegrationTestCallback callback, {
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
  int? retry,
  IndependentIntegrationTestServerPool? serverPool,
}) {
  // Setup binding
  FlutterIntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Setup server
  final effectiveServerPool = serverPool ?? IndependentIntegrationTestServerPool.instance;
  final server = ShelfIntegrationTestServer();
  final httpOverrides = server;

  testWidgets(
    description,
    (tester) async {
      // Assigning global HttpOverrides must be invoked inside each test callback
      // to avoid using same proxy by multuple tests instances
      HttpOverrides.global = httpOverrides;

      final config = effectiveServerPool.findConfig();
      try {
        dev.log('🧪 Starting test: `$description`');
        await server.serve(config);
        await callback(tester, server);
      } catch (_) {
        rethrow;
      } finally {
        await server.close();
        effectiveServerPool.releasePort(config.port);
      }
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
    retry: retry,
  );
}
