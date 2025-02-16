import 'package:flutter_integration_test/src/util/semi_integration_test_horeographer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Runs tests one by one', () async {
    final results = <int>[];

    // Unordered taskss
    await Future.wait([
      Future(() async {
        await Future.delayed(const Duration(milliseconds: 200));
        results.add(1);
      }),
      Future(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        results.add(2);
      }),
    ]);

    expect(results, [2, 1]);

    results.clear();

    final horeographer = SemiIntegrationTestHoreographer.newInstance();

    // Ordered tasks
    await Future.wait([
      horeographer.runTest(
        () async {
          await Future.delayed(const Duration(milliseconds: 200));
          results.add(1);
        },
      ),
      horeographer.runTest(
        () async {
          await Future.delayed(const Duration(milliseconds: 100));
          results.add(2);
        },
      ),
    ]);

    expect(results, [1, 2]);
  });
}
