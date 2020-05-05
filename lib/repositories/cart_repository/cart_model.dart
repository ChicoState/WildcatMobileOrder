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
    print(newCart.items.length);
    return newCart;
  }

  /// Serializes Cart object into Firestore compatible document
  /// Pass in a price value so order history has cart price
  Map<String, dynamic> toDocument(double price) => {
        'items': FieldValue.arrayUnion(items.map((item) {
          return item.toJson();
        }).toList()),
        'user': user,
        'location': location,
        'orderid' : Uuid().v4().toString(),
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

  CartItem(this.quantity, this.identifier);

  // used to create a new item and initialize quantity to 1
  CartItem.fromMenuItem(MenuItem item)
      : quantity = 1,
        identifier = item.identifier;

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'qty': quantity,
      };

  CartItem.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        quantity = json['qty'];

  CartItem incrementQuantity() {
    print('incrementing qty to ${this.quantity + 1} of ${this.identifier}');
    return CartItem(this.quantity + 1, this.identifier);
  }

  //Added the case of a cart decrementing into negative quantities
  CartItem decrementQuantity() {
    if (this.quantity == 0)
      return CartItem(this.quantity, this.identifier);
    else
      return CartItem(this.quantity - 1, this.identifier);
  }

  CartItem copyWith({int quantity, String identifier}) {
    return CartItem(
      quantity ?? this.quantity,
      identifier ?? this.identifier,
    );
  }
}
