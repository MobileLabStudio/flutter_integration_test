import 'package:flutter/material.dart';
import 'package:flutter_integration_test/flutter_integration_test.dart';
import 'package:flutter_integration_test_example/src/locale_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  semiIntegrationTest('Can mock locale', (tester, helper) async {
    const testLocale1 = Locale('en', 'GB');
    const testLocale2 = Locale('en', 'US');

    await tester.pumpWidget(const LocaleApp());
    await tester.pumpAndSettle();

    await helper.mockLocale(testLocale1);
    expect(find.text(testLocale1.toString()), findsOneWidget);

    await helper.mockLocale(testLocale2);
    expect(find.text(testLocale2.toString()), findsOneWidget);
  });
}
