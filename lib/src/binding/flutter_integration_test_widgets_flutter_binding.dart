import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class FlutterIntegrationTestWidgetsFlutterBinding extends IntegrationTestWidgetsFlutterBinding {
  FlutterIntegrationTestWidgetsFlutterBinding._();

  static FlutterIntegrationTestWidgetsFlutterBinding? _instance;

  static FlutterIntegrationTestWidgetsFlutterBinding get instance => BindingBase.checkInstance(_instance);

  static FlutterIntegrationTestWidgetsFlutterBinding ensureInitialized() {
    return _instance ??= FlutterIntegrationTestWidgetsFlutterBinding._()..framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }
}
