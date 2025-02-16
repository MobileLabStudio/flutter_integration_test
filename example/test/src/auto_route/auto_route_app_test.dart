import 'package:flutter/material.dart';
import 'package:flutter_integration_test/flutter_integration_test.dart';
import 'package:flutter_integration_test_example/src/auto_route/auto_route_app.dart';
import 'package:flutter_integration_test_example/src/auto_route/routes/screens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  integrationTest('Can push and pop pages', (tester, server) async {
    await tester.pumpWidget(const AutoRouteApp());
    await tester.pumpAndSettle();
    final buttonNext = find.byType(FilledButton);
    final screen1 = find.byType(Screen1);
    final screen2 = find.byType(Screen2);
    final screen3 = find.byType(Screen3);

    expect(screen1, findsOneWidget);

    await tester.tap(buttonNext);
    await tester.pumpAndSettle();
    expect(screen2, findsOneWidget);

    await tester.tap(buttonNext);
    await tester.pumpAndSettle();
    expect(screen3, findsOneWidget);

    tester.pop();
    await tester.pumpAndSettle();
    expect(screen2, findsOneWidget);

    tester.pop();
    await tester.pumpAndSettle();
    expect(screen1, findsOneWidget);
  });
}
