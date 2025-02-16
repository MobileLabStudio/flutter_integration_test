import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

final class SemiIntegrationTestPlatformDispatcher extends TestPlatformDispatcher {
  SemiIntegrationTestPlatformDispatcher() : super(platformDispatcher: PlatformDispatcher.instance);

  late String initialRoute;

  @override
  late String defaultRouteName;
}
