// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:WildcatMobileOrder/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  final MenuRepository menuRepository = MenuRepository();
  final Map<String, dynamic> testMenuItem = {
    'name': 'test-item',
    'category': 'test-category',
    'price': 50.0,
    'description': 'test-description',
    'identifier': 'test-identifier',
    'imgurl': 'https://i.imgur.com/5PfXQjQ.jpg',
  };
  final Map<String, dynamic> testMenuItem2 = {
    'name': 'test-item2',
    'category': 'test-category2',
    'price': 4.50,
    'description': 'test-description2',
    'identifier': 'test-identifier2',
    'imgurl': 'https://i.imgur.com/5PfXQjQ.jpg',
  };
  final MenuItem menuItem = MenuItem.fromMap(testMenuItem, 'test-location');
  final MenuItem menuItem2 = MenuItem.fromMap(testMenuItem2, 'test-location');
  final MenuItem menuItemLoc2 =
      MenuItem.fromMap(testMenuItem2, 'another-place');

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
  group('Cart', () {
    test('counter increments', () {
      final Cart cart = Cart(List<CartItem>(), '', 'test@user.com', 0);
      expect(cart.addItem(menuItem).count, 1);
    });
    test('counter increments twice', () {
      final Cart cart = Cart(List<CartItem>(), '', 'test@user.com', 0);
      expect(cart.addItem(menuItem).addItem(menuItem).count, 2);
    });
    test('counter decrements', () {
      final Cart cart = Cart(List<CartItem>(), '', 'test@user.com', 0);
      expect(cart.addItem(menuItem).removeItem(menuItem).count, 0);
    });
    test('removing last item resets location', () {
      final Cart cart = Cart(List<CartItem>(), '', 'test@user.com', 0);
      expect(cart.addItem(menuItem).removeItem(menuItem).location, '');
    });
    test('check item add helper function', () {
      final Cart cart = Cart(List<CartItem>(), '', 'test@user.com', 0);
      expect(cart.checkItemAdd(menuItem), true);
    });
    test('check item add helper function false', () {
      final Cart cart = Cart(List<CartItem>(), '', 'test@user.com', 0);
      expect(cart.addItem(menuItem).checkItemAdd(menuItemLoc2), false);
    });
    test('add item adds to correct CartItem', () {
      final Cart cart = Cart(List<CartItem>(), '', 'test@user.com', 0);
      expect(cart.addItem(menuItem).addItem(menuItem).items.length, 1);
    });
    test('delete item basic', () {
      final Cart cart = Cart(List<CartItem>(), '', 'test@user.com', 0);
      final Cart newCart = cart.addItem(menuItem).addItem(menuItem);
      expect(newCart.deleteItem(menuItem).items.length, 0);
    });
    test('delete item multiple items', () {
      final Cart cart = Cart(List<CartItem>(), '', 'test@user.com', 0);
      final Cart newCart = cart.addItem(menuItem).addItem(menuItem2);
      expect(newCart.deleteItem(menuItem).items.length, 1);
    });
    test('delete item resets location', () {
      final Cart cart = Cart(List<CartItem>(), '', 'test@user.com', 0);
      final Cart newCart = cart.addItem(menuItem).addItem(menuItem);
      expect(newCart.deleteItem(menuItem).location, '');
    });
  });

  group('CartItem', () {
    test('starts with quantity of 1', () {
      expect(CartItem.fromMenuItem(menuItem).quantity, 1);
    });
    test('increment quantity', () {
      expect(CartItem.fromMenuItem(menuItem).incrementQuantity().quantity, 2);
    });
    test('decrement quantity', () {
      expect(CartItem.fromMenuItem(menuItem).decrementQuantity().quantity, 0);
    });
    test('decrement quantity handles negative', () {
      final CartItem cartItem = CartItem.fromMenuItem(menuItem);
      expect(cartItem.decrementQuantity().decrementQuantity().quantity, 0);
    });
  });
}
