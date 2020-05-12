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
  group('Cart', () {
    test('counter increments', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      expect(cart.addItem(menuItem).getCount(), 1);
    });
    test('counter increments twice', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      expect(cart.addItem(menuItem).addItem(menuItem).getCount(), 2);
    });
    test('counter decrements', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      expect(cart.addItem(menuItem).removeItem(menuItem).getCount(), 0);
    });
    test('removing last item resets location', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      expect(cart.addItem(menuItem).removeItem(menuItem).location, '');
    });
    test('check item add helper function', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      expect(cart.checkItemAdd(menuItem), true);
    });
    test('check item add helper function false', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      expect(cart.addItem(menuItem).checkItemAdd(menuItemLoc2), false);
    });
    test('add item adds to correct CartItem', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      expect(cart.addItem(menuItem).addItem(menuItem).items.length, 1);
    });
    test('delete item basic', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      final newCart = cart.addItem(menuItem).addItem(menuItem);
      expect(newCart.deleteItem(menuItem).items.length, 0);
    });
    test('delete item multiple items', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      final newCart = cart.addItem(menuItem).addItem(menuItem2);
      expect(newCart.deleteItem(menuItem).items.length, 1);
    });
    test('delete item resets location', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      final newCart = cart.addItem(menuItem).addItem(menuItem);
      expect(newCart.deleteItem(menuItem).location, '');
    });
    test('is empty', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      final newCart = cart.addItem(menuItem).deleteItem(menuItem);
      expect(newCart.isEmpty(), true);
    });
    test('is NOT empty', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      final newCart = cart.addItem(menuItem).addItem(menuItem);
      expect(newCart.isEmpty(), false);
    });
    test('is still not empty after changing location', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      final newCart =
          cart.addItem(menuItem).deleteItem(menuItem).addItem(menuItemLoc2);
      expect(newCart.isEmpty(), false);
    });
    test('is empty after changing location', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      final newCart = cart
          .addItem(menuItem)
          .deleteItem(menuItem)
          .addItem(menuItemLoc2)
          .deleteItem(menuItemLoc2);
      expect(newCart.isEmpty(), true);
    });
    test('toString()', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      expect(
          cart.toString(), '{ user: test@user.com, location: , itemCount: 0');
    });
    test('toString() with items', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      final newCart = cart.addItem(menuItem).addItem(menuItem2);
      expect(newCart.toString(),
          '{ user: test@user.com, location: test-location, itemCount: 2');
    });
    test('getCount() no items', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com');
      expect(cart.getCount(), 0);
    });
    test('getCount() one item', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com').addItem(menuItem);
      expect(cart.getCount(), 1);
    });
    test('getCount() one item, multiple quantity', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com').addItem(menuItem);
      final newCart = cart.addItem(menuItem);
      expect(cart.getCount(), 2);
    });
    test('getCount() multiple items', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com').addItem(menuItem);
      final newCart = cart.addItem(menuItem2);
      expect(newCart.getCount(), 2);
    });
    test('getCount() multiple items, multiple quantities', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com').addItem(menuItem);
      final newCart = cart.addItem(menuItem2).addItem(menuItem);
      expect(newCart.getCount(), 3);
    });
    test('getCount() multiple items, multiple quantities, another', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com').addItem(menuItem);
      final newCart =
          cart.addItem(menuItem2).addItem(menuItem).addItem(menuItem2);
      expect(newCart.getCount(), 4);
    });

    test('delete nonexistent item', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com').addItem(menuItem);
      final newCart = cart.deleteItem(menuItem2);
      expect(newCart.getCount(), cart.getCount());
    });
    test('decrement nonexistent item', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com').addItem(menuItem);
      final newCart = cart.removeItem(menuItem2);
      expect(newCart.getCount(), cart.getCount());
    });
    test('decrement with multiple items', () {
      final cart = Cart(<CartItem>[], '', 'test@user.com').addItem(menuItem);
      final newCart = cart.addItem(menuItem2).removeItem(menuItem);
      expect(newCart.getCount(), 1);
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
      final cartItem = CartItem.fromMenuItem(menuItem);
      expect(cartItem.decrementQuantity().decrementQuantity().quantity, 0);
    });
    test('toJson() method', () {
      final cartItem = CartItem.fromMenuItem(menuItem);
      expect(cartItem.toJson(), {
        'identifier': 'test-location-test-item',
        'qty': 1,
        'name': 'test-item'
      });
    });
    test('toJson() method additional quantity', () {
      final cartItem = CartItem.fromMenuItem(menuItem).incrementQuantity();
      expect(cartItem.toJson(), {
        'identifier': 'test-location-test-item',
        'qty': 2,
        'name': 'test-item'
      });
    });
  });
}
