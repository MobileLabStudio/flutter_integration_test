import 'package:flutter_integration_test/flutter_integration_test.dart';
import 'package:flutter_integration_test_example/main.dart';

void main() {
  integrationTest('main ...', (tester, server) async {
    await tester.pumpWidget(const MainApp());
  });
}
