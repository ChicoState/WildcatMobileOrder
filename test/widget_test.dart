import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:WildcatMobileOrder/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final userRepository = UserRepository();
  final menuRepository = MenuRepository();
  final testMenuItem = {
    'name': 'test-item',
    'category': 'test-category',
    'price': 50.0,
    'description': 'test-description',
    'identifier': 'test-identifier',
    'imgurl': 'https://i.imgur.com/5PfXQjQ.jpg',
  };
  final testMenuItem2 = {
    'name': 'test-item2',
    'category': 'test-category2',
    'price': 4.50,
    'description': 'test-description2',
    'identifier': 'test-identifier2',
    'imgurl': 'https://i.imgur.com/5PfXQjQ.jpg',
  };
  final menuItem = MenuItem.fromMap(testMenuItem, 'test-location');
  final menuItem2 = MenuItem.fromMap(testMenuItem2, 'test-location');
  final menuItemLoc2 = MenuItem.fromMap(testMenuItem2, 'another-place');

  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
//  testWidgets('smoke test', (WidgetTester tester) async {
//    final app = MyApp(userRepository, menuRepository);
//    await tester.pumpWidget(app);
//    expect(find.text("0"), findsOneWidget);
//    await tester.tap(find.byIcon(Icons.add));
//    await tester.pump();
//    expect(find.text("1"), findsOneWidget);
//  });


}
