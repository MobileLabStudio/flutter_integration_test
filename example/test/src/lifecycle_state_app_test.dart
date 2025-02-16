import 'package:flutter/widgets.dart';
import 'package:flutter_integration_test/flutter_integration_test.dart';
import 'package:flutter_integration_test_example/src/lifecycle_state_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  semiIntegrationTest(
    'Can mock app lifecycle state',
    (tester, helper) async {
      await tester.pumpWidget(const LifecycleStateApp());
      // Verify initial state is resumed
      expect(find.text(AppLifecycleState.resumed.toString()), findsOneWidget);

      for (final lifecycleState in AppLifecycleState.values) {
        await helper.mockAppLifecycleState(lifecycleState);
        expect(find.text(lifecycleState.toString()), findsOneWidget);
      }
    },
  );
}
