import 'package:flutter/material.dart';
import 'package:flutter_integration_test/flutter_integration_test.dart';
import 'package:flutter_integration_test_example/src/clock_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  semiIntegrationTest('Can mock and un-mock time', (tester, helper) async {
    final dateTime = DateTime(1234, 5, 6, 7, 8, 9, 10, 11);
    await helper.mockTime(dateTime);
    runApp(const ClockApp());
    await tester.pumpAndSettle();
    expect(find.text(dateTime.toIso8601String()), findsOneWidget);

    await helper.mockTime(); // Unmock time
    await tester.tap(find.byType(FilledButton)); // Refresh widget
    await tester.pumpAndSettle();
    expect(find.text(dateTime.toIso8601String()), findsNothing);
  });
}
