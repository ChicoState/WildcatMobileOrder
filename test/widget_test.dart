// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:WildcatMobileOrder/screens/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:WildcatMobileOrder/main.dart';
void main() {
final UserRepository userRepository = UserRepository();
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
testWidgets('smoke test', (WidgetTester tester) async {
  final app = MyApp(userRepository);
  await tester.pumpWidget(app);
  expect(find.text("0"), findsOneWidget);
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  expect(find.text("1"), findsOneWidget);
});
}