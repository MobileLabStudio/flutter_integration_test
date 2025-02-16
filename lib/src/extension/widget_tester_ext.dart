import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterExt on WidgetTester {
  void pop<T extends Object?>([T? result]) => state<NavigatorState>(find.byType(Navigator)).pop(result);
  Future<bool> maybePop<T extends Object?>([T? result]) => state<NavigatorState>(find.byType(Navigator)).maybePop(result);
}
