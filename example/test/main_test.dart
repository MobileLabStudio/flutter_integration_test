import 'package:flutter_integration_test/flutter_integration_test.dart';
import 'package:flutter_integration_test_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  integrationTest(
    'Server responds',
    (tester, server) async {
      await tester.pumpWidget(const HttpClientExample());
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
      await tester.pumpWidget(const HttpClientExample());
      await tester.pumpAndSettle();
      expect(find.text(expectedResponseBody), findsOneWidget);
    },
  );

  integrationTest(
    'Can mock response for dio client',
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
      await tester.pumpWidget(const DioExample());
      await tester.pumpAndSettle();
      expect(find.text(expectedResponseBody), findsOneWidget);
    },
  );
}
