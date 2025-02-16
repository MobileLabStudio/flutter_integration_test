import 'dart:developer' as dev;
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'src/binding/semi_integration_test_widgets_flutter_binding.dart';
import 'src/server/pool/independent_integration_test_server_pool.dart';
import 'src/server/shelf/shelf_integration_test_server.dart';
import 'src/util/helper/test_helper.dart';
import 'src/util/mock_clock.dart';
import 'src/util/semi_integration_test_horeographer.dart';

export 'package:clock/clock.dart';

export 'src/binding/binding.dart';
export 'src/extension/extension.dart';
export 'src/server/http/fake_http_response.dart';
export 'src/server/integration_test_server.dart';
export 'src/server/pool/integration_test_server_pool.dart';

typedef SemiIntegrationTestCallback = Future<void> Function(
  WidgetTester tester,
  TestHelper helper,
);

@isTest
void semiIntegrationTest(
  String description,
  SemiIntegrationTestCallback callback, {
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
  int? retry,
  IndependentIntegrationTestServerPool? serverPool,
  String initialRoute = '/',
}) {
  // Setup binding. This must be called before `testWidgets` to create our own binding
  final binding = SemiIntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    description,
    (tester) async {
      await SemiIntegrationTestHoreographer.instance.runTest(() async {
        // Setup server
        final effectiveServerPool = serverPool ?? IndependentIntegrationTestServerPool.instance;
        final server = ShelfIntegrationTestServer();

        final httpOverrides = server;
        HttpOverrides.global = httpOverrides;

        binding.setInitialRoute(initialRoute);

        final config = effectiveServerPool.findConfig();
        try {
          dev.log('🧪 Starting test: `$description`');
          final clock = MockClock();
          final helper = TestHelper(tester, clock, binding, server);
          await server.serve(config);
          await withClock(clock, () => callback(tester, helper));
        } catch (_) {
          rethrow;
        } finally {
          await server.close();
          effectiveServerPool.releasePort(config.port);
        }
      });
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
    retry: retry,
  );
}
