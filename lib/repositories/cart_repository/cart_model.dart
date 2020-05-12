import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../menu_repository/menu_entity.dart';

/// Represents the current cart of a user
class Cart {
  /// List of CartItem
  final List<CartItem> items;

  /// Location of current cart
  final String location;

  /// Email of logged in user
  final String user;

  /// Default constructor for Cart
  Cart(this.items, this.location, this.user);

  @override
  String toString() =>
      '{ user: $user, location: $location, itemCount: ${items.length}';

  /// Returns a cart the represents any changes made
  Cart copyWith(
          {List<CartItem> items, String location, String user, int count}) =>
      Cart(
        items ?? this.items,
        location ?? this.location,
        user ?? this.user,
      );

  /// Check if the cart is empty or not
  bool isEmpty() => items.length == 0 ? true : false;

  /// Deletes an item from the cart (any amount)
  Cart deleteItem(MenuItem item) {
    var currentItems = items;
    var idx = currentItems.indexWhere((i) => i.identifier == item.identifier);
    if (idx != -1) {
      currentItems.removeAt(idx);
      if (currentItems.length == 0) {
        return copyWith(items: currentItems, location: '', count: 0);
      }
      return copyWith(items: currentItems);
    }
    return copyWith();
  }

  /// Returns total quantity of all items in cart
  int getCount() {
    var newCount = 0;
    for (var i in items) {
      newCount += i.quantity;
    }
    return newCount;
  }

  /// Removes one item from the cart
  Cart removeItem(MenuItem item) {
    var currentItems = items;
    var idx = currentItems.indexWhere((i) => i.identifier == item.identifier);
    if (idx != -1) {
      currentItems[idx] = currentItems[idx].decrementQuantity();
      if (currentItems.length == 1 && currentItems[idx].quantity == 0) {
        return copyWith(items: <CartItem>[], location: '');
      }
      return copyWith(items: currentItems);
    }
    return copyWith();
  }

  /// Adds one item to the cart
  Cart addItem(MenuItem item) {
    var currentItems = items;
    var idx = currentItems.indexWhere((i) => i.identifier == item.identifier);
    if (idx != -1) {
      currentItems[idx] = currentItems[idx].incrementQuantity();
    } else {
      currentItems.add(CartItem.fromMenuItem(item));
    }
    return copyWith(items: currentItems, location: item.location);
  }

  /// Helper function to check if a menu item
  bool checkItemAdd(MenuItem item) =>
      location == '' ? true : location == item.location;

  /// Serializes Cart object into Firestore compatible document
  /// Pass in a price value so order history has cart price
  Map<String, dynamic> toDocument(double price) => <String, dynamic>{
        'items':
            FieldValue.arrayUnion(items.map((item) => item.toJson()).toList()),
        'user': user,
        'location': location,
        'orderid': Uuid().v4().toString(),
        'price': price,
        'ordertime': Timestamp.now(),
      };
}

/// Represents an item & quantity in a cart
class CartItem {
  /// Quantity of the item in the cart
  final int quantity;

  /// Identifier of the MenuItem
  final String identifier;

  /// Name of the item
  final String name;

  /// Default constructor for CartItem
  CartItem(this.quantity, this.identifier, this.name);

  /// Used to add a new item to the Cart
  CartItem.fromMenuItem(MenuItem item)
      : quantity = 1,
        identifier = item.identifier,
        name = item.name;

  /// Helps serialize CartItems to a Firestore document
  Map<String, dynamic> toJson() => <String, dynamic>{
        'identifier': identifier,
        'qty': quantity,
        'name': name,
      };

  /// Increases the quantity of an item by 1
  CartItem incrementQuantity() => CartItem(quantity + 1, identifier, name);

  /// Decreases the quantity of an item by 1
  CartItem decrementQuantity() {
    if (quantity == 0) {
      return CartItem(quantity, identifier, name);
    } else {
      return CartItem(quantity - 1, identifier, name);
    }
  }
}
