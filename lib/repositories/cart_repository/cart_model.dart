import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../menu_repository/menu_entity.dart';

/// Represents the current cart of a user
class Cart {
  final List<CartItem> items;
  final String location;
  final String user;
  final int count;

  /// Default constructor for Cart
  Cart(this.items, this.location, this.user, this.count);

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
        count ?? this.count,
      );

  /// Check if the cart is empty or not
  bool isEmpty() => items.length == 0 ? true : false;

  /// Deletes an item from the cart (any amount)
  Cart deleteItem(MenuItem item) {
    var currentItems = items;
    var idx = currentItems.indexWhere((i) => i.identifier == item.identifier);
    if (idx != -1) {
      var quantity = currentItems[idx].quantity;
      currentItems.removeAt(idx);
      if (currentItems.length == 0) {
        return copyWith(items: currentItems, location: '', count: 0);
      }
      return copyWith(items: currentItems, count: count - quantity);
    }
    return copyWith();
  }

  /// Removes one item from the cart
  Cart removeItem(MenuItem item) {
    var currentItems = items;
    var idx = currentItems.indexWhere((i) => i.identifier == item.identifier);
    if (idx != -1) {
      currentItems[idx] = currentItems[idx].decrementQuantity();
      if (count == 1) {
        return copyWith(items: currentItems, count: count - 1, location: '');
      }
      return copyWith(items: currentItems, count: count - 1);
    }
    return copyWith();
  }

  /// Adds one item to the cart
  Cart addItem(MenuItem item) {
    var currentItems = items;
    var idx = currentItems.indexWhere((i) => i.identifier == item.identifier);
    var newCount = count + 1;
    if (idx != -1) {
      currentItems[idx] = currentItems[idx].incrementQuantity();
    } else {
      currentItems.add(CartItem.fromMenuItem(item));
    }
    return copyWith(
        items: currentItems, location: item.location, count: newCount);
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

  /// Serializes Cart object into Json string for persistence
  Map<String, dynamic> toJson() => <String, dynamic>{
        'items': jsonEncode(items),
        'user': user,
        'location': location,
      };
}

/// Represents an item & quantity in a cart
class CartItem {
  final int quantity;
  final String identifier;
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

  /// Construct a CartItem from a Firestore document
  CartItem.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        quantity = json['qty'],
        name = json['name'];

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

  /// Returns a modified CartItem
  CartItem copyWith({int quantity, String identifier, String name}) => CartItem(
        quantity ?? this.quantity,
        identifier ?? this.identifier,
        name ?? this.name,
      );
}
