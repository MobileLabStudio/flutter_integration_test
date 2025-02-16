import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';

final class SemiIntegrationTestHoreographer {
  SemiIntegrationTestHoreographer._();

  /// Create new instance of this class ONLY for testing purposes.
  /// Any other cases must use [instance] static property
  @visibleForTesting
  SemiIntegrationTestHoreographer.newInstance() {
    final isTest = Platform.environment['FLUTTER_TEST'] == 'true';
    assert(isTest);
  }

  static SemiIntegrationTestHoreographer? _instance;
  static SemiIntegrationTestHoreographer get instance => _instance ??= SemiIntegrationTestHoreographer._();

  Completer<void>? _completer;

  Future<void> runTest(Future<void> Function() callback) async {
    if (_completer == null) {
      _completer = Completer();
    } else {
      await _completer?.future;
    }
    try {
      await callback();
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }
}
