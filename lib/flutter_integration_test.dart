import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'src/binding/flutter_integration_test_widgets_flutter_binding.dart';
import 'src/server/integration_test_server.dart';
import 'src/server/shelf/shelf_integration_test_server.dart';

export 'src/binding/flutter_integration_test_widgets_flutter_binding.dart';
export 'src/server/http/fake_http_response.dart';
export 'src/server/integration_test_server.dart';

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
  IntegrationTestServer? server,
}) {
  // Setup binding
  FlutterIntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Setup http client
  final effectiveServer = server ?? ShelfIntegrationTestServer();
  HttpOverrides.global = effectiveServer;

  testWidgets(
    description,
    (tester) async {
      try {
        await effectiveServer.serve();
        await callback(tester, effectiveServer);
      } catch (_) {
        rethrow;
      } finally {
        await effectiveServer.close();
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
