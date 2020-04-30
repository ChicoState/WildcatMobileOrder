import 'package:WildcatMobileOrder/repositories/menu_repository/menu_entity.dart';

class Cart {
  final List<CartItem> items;
  final String location;
  final String user;

  Cart(this.items, this.location, this.user);

  Cart copyWith({List<CartItem> items, String location, String user}) {
    return Cart(
      items ?? this.items,
      location ?? this.location,
      user ?? this.user,
    );
  }

  bool isEmpty() {
    return items.length == 0 ? true : false;
  }

  Cart addItem(MenuItem item) {
    List<CartItem> currentItems = this.items;
    int idx = currentItems.indexWhere((i) => i.identifier == item.identifier);
    if (idx != -1) {
      currentItems[idx] =
          currentItems[idx].copyWith(quantity: currentItems[idx].quantity + 1);
    } else {
      currentItems.add(CartItem(1, item.identifier));
    }
    return this.copyWith(items: currentItems);
  }
}

class CartItem {
  final int quantity;
  final String identifier;

  CartItem(this.quantity, this.identifier);

  CartItem copyWith({int quantity, String identifier}) {
    return CartItem(
      quantity ?? this.quantity,
      identifier ?? this.identifier,
    );
  }
}
