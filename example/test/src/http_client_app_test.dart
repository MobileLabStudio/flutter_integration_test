import 'package:flutter_integration_test/flutter_integration_test.dart';
import 'package:flutter_integration_test_example/src/http_client_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  semiIntegrationTest(
    'Can mock response',
    (tester, helper) async {
      const expectedResponseBody = 'Test response';
      helper.server.mockAndConsume(
        FakeHttpResponse(
          method: 'GET',
          pattern: RegExp(r'test$'),
          body: expectedResponseBody,
          statusCode: 200,
        ),
      );
      final finder = find.text(expectedResponseBody);
      await tester.pumpWidget(const HttpClientApp());
      await tester.pumpUntil(PumpUntilStrategy.finderFoundsAny(finder));
      expect(find.text(expectedResponseBody), findsOneWidget);
    },
  );
}
