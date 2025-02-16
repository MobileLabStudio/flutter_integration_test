import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'platform_dispatcher/semi_integration_test_platform_dispatcher.dart';

class SemiIntegrationTestWidgetsFlutterBinding extends LiveTestWidgetsFlutterBinding {
  SemiIntegrationTestWidgetsFlutterBinding._(this._fakeTestPlatformDispatcher);

  static SemiIntegrationTestWidgetsFlutterBinding? _instance;

  static SemiIntegrationTestWidgetsFlutterBinding get instance => BindingBase.checkInstance(_instance);

  static SemiIntegrationTestWidgetsFlutterBinding ensureInitialized() {
    return _instance ??= SemiIntegrationTestWidgetsFlutterBinding._(SemiIntegrationTestPlatformDispatcher())
      ..framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }

  late final SemiIntegrationTestPlatformDispatcher _fakeTestPlatformDispatcher;

  @override
  TestPlatformDispatcher get platformDispatcher => _fakeTestPlatformDispatcher;

  @override
  AppLifecycleState? get lifecycleState => super.lifecycleState ?? AppLifecycleState.resumed;

  void setInitialRoute(String value) {
    _fakeTestPlatformDispatcher.defaultRouteName = value;
  }

  void setLifecycleState(AppLifecycleState lifecycleState) {
    handleAppLifecycleStateChanged(lifecycleState);
    scheduleForcedFrame(); // Schedule frame for each lifecycle state
  }

  Future<void> setAppLocale(Locale? locale) async {
    await setLocales([if (locale != null) locale]);
  }
}
