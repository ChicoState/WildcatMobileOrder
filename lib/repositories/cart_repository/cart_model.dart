import 'dart:convert';
import 'package:WildcatMobileOrder/repositories/menu_repository/menu_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Cart {
  final List<CartItem> items;
  final String location;
  final String user;

  Cart(this.items, this.location, this.user);

  @override
  String toString() =>
      '{ user: $user, location: $location, itemCount: ${items.length}';

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

  Cart deleteItem(MenuItem item) {
    List<CartItem> currentItems = this.items;
    int idx = currentItems.indexWhere((i) => i.identifier == item.identifier);
    if (idx != -1) {
      currentItems.removeAt(idx);
    }
    if (currentItems.length == 0) {
      return copyWith(items: currentItems, location: '');
    }
    return copyWith(items: currentItems);
  }

  Cart removeItem(MenuItem item) {
    List<CartItem> currentItems = this.items;
    int idx = currentItems.indexWhere((i) => i.identifier == item.identifier);
    if (idx != -1) {
      currentItems[idx] = currentItems[idx].decrementQuantity();
    }
    return copyWith(items: currentItems);
  }

  Cart addItem(MenuItem item) {
    List<CartItem> currentItems = this.items;
    int idx = currentItems.indexWhere((i) => i.identifier == item.identifier);
    if (idx != -1) {
      currentItems[idx] = currentItems[idx].incrementQuantity();
    } else {
      currentItems.add(CartItem.fromMenuItem(item));
    }
    Cart newCart = copyWith(items: currentItems, location: item.location);
    return newCart;
  }

  /// Helper function to check if a menu item
  bool checkItemAdd(MenuItem item) {
    return this.location == '' ? true : this.location == item.location;
  }

  /// Serializes Cart object into Firestore compatible document
  /// Pass in a price value so order history has cart price
  Map<String, dynamic> toDocument(double price) => {
        'items': FieldValue.arrayUnion(items.map((item) {
          return item.toJson();
        }).toList()),
        'user': user,
        'location': location,
        'orderid': Uuid().v4().toString(),
        'price': price,
        'ordertime': Timestamp.now(),
      };

  /// Serializes Cart object into Json string for persistence
  Map<String, dynamic> toJson() => {
        'items': jsonEncode(items),
        'user': user,
        'location': location,
      };
}

class CartItem {
  final int quantity;
  final String identifier;
  final String name;

  CartItem(this.quantity, this.identifier, this.name);

  // used to create a new item and initialize quantity to 1
  CartItem.fromMenuItem(MenuItem item)
      : quantity = 1,
        identifier = item.identifier,
        name = item.name;

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'qty': quantity,
        'name': name,
      };

  CartItem.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        quantity = json['qty'],
        name = json['name'];

  CartItem incrementQuantity() {
    return CartItem(this.quantity + 1, this.identifier, this.name);
  }

  //Added the case of a cart decrementing into negative quantities
  CartItem decrementQuantity() {
    if (this.quantity == 0)
      return CartItem(this.quantity, this.identifier, this.name);
    else
      return CartItem(this.quantity - 1, this.identifier, this.name);
  }

  CartItem copyWith({int quantity, String identifier, String name}) {
    return CartItem(
      quantity ?? this.quantity,
      identifier ?? this.identifier,
      name ?? this.name,
    );
  }
}
