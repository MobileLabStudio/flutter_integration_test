import 'package:flutter_integration_test/flutter_integration_test.dart';
import 'package:flutter_integration_test_example/src/http_client_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  integrationTest(
    'Server responds',
    (tester, server) async {
      await tester.pumpWidget(const HttpClientApp());
      await tester.pumpAndSettle();
      expect(find.text('Server responds'), findsOneWidget);
    },
  );

  integrationTest(
    'Can mock response',
    (tester, server) async {
      const expectedResponseBody = 'Test response';
      server.mockAndConsume(
        FakeHttpResponse(
          method: 'GET',
          pattern: RegExp(r'test$'),
          body: expectedResponseBody,
          statusCode: 200,
        ),
      );
      await tester.pumpWidget(const HttpClientApp());
      await tester.pumpAndSettle();
      expect(find.text(expectedResponseBody), findsOneWidget);
    },
  );
}
