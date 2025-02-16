import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import '../../binding/semi_integration_test_widgets_flutter_binding.dart';
import '../../server/integration_test_server.dart';
import '../mock_clock.dart';

class TestHelper {
  TestHelper(this._tester, this._clock, this._binding, this.server);

  final WidgetTester _tester;
  final MockClock _clock;
  final SemiIntegrationTestWidgetsFlutterBinding _binding;
  final IntegrationTestServer server;

  Future<void> mockTime([DateTime? dateTime]) async {
    _clock.mock(dateTime);
    await _tester.pumpAndSettle();
  }

  Future<void> mockAppLifecycleState(AppLifecycleState lifecycleState) async {
    _binding.setLifecycleState(lifecycleState);
    await _tester.pumpAndSettle();
  }

  Future<void> mockLocale([Locale? locale]) async {
    await _binding.setAppLocale(locale);
    await _tester.pumpAndSettle();
  }
}
