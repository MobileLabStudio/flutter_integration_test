import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

typedef TestCallback = bool Function();

extension WidgetTesterExt on WidgetTester {
  void pop<T extends Object?>([T? result]) => state<NavigatorState>(find.byType(Navigator)).pop(result);

  Future<bool> maybePop<T extends Object?>([T? result]) => state<NavigatorState>(find.byType(Navigator)).maybePop(result);

  Future<int> pumpUntil(
    PumpUntilStrategy strategy, {
    Duration duration = const Duration(milliseconds: 100),
    EnginePhase phase = EnginePhase.sendSemanticsUpdate,
    Duration timeout = const Duration(minutes: 10),
    bool ignoreScheduledFrames = true,
  }) async {
    assert(duration > Duration.zero);
    assert(timeout > Duration.zero);

    bool shouldPump() {
      if (ignoreScheduledFrames) return strategy.shouldPump();
      return binding.hasScheduledFrame || strategy.shouldPump();
    }

    return TestAsyncUtils.guard<int>(() async {
      final DateTime endTime = binding.clock.fromNowBy(timeout);
      int count = 0;
      do {
        if (binding.clock.now().isAfter(endTime)) {
          throw FlutterError('pumpUntil timed out');
        }
        await binding.pump(duration, phase);
        count += 1;
      } while (shouldPump());
      return count;
    });
  }
}

abstract interface class PumpUntilStrategy {
  const PumpUntilStrategy();

  const factory PumpUntilStrategy.finderFoundsAny(Finder finder) = PumpUntilFinderFoundsAny;
  const factory PumpUntilStrategy.finderFoundsNothing(Finder finder) = PumpUntilFinderFoundsNothing;
  const factory PumpUntilStrategy.condition(TestCallback test) = PumpUntilCondition;

  bool shouldPump();
}

final class PumpUntilFinderFoundsAny implements PumpUntilStrategy {
  const PumpUntilFinderFoundsAny(this.finder);

  final Finder finder;

  @override
  bool shouldPump() => finder.evaluate().isEmpty;
}

final class PumpUntilFinderFoundsNothing implements PumpUntilStrategy {
  const PumpUntilFinderFoundsNothing(this.finder);

  final Finder finder;

  @override
  bool shouldPump() => finder.evaluate().isNotEmpty;
}

final class PumpUntilCondition implements PumpUntilStrategy {
  const PumpUntilCondition(this.test);

  final TestCallback test;

  @override
  bool shouldPump() => test();
}
