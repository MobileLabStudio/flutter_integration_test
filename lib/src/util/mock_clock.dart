import 'package:clock/clock.dart';

final class MockClock extends Clock {
  DateTime? _mockTime;

  @override
  DateTime now() => _mockTime ?? super.now();

  void mock([DateTime? dateTime]) {
    _mockTime = dateTime;
  }
}
