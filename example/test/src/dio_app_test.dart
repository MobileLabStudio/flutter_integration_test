import 'package:flutter_integration_test/flutter_integration_test.dart';
import 'package:flutter_integration_test_example/src/dio_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  semiIntegrationTest(
    'Can mock response for dio client',
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
      await tester.pumpWidget(const DioApp());
      await tester.pumpAndSettle();
      expect(find.text(expectedResponseBody), findsOneWidget);
    },
  );
}
