import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../menu_repository/menu_entity.dart';

class Cart {
  final List<CartItem> items;
  final String location;
  final String user;
  final int count;

  Cart(this.items, this.location, this.user, this.count);

  @override
  String toString() =>
      '{ user: $user, location: $location, itemCount: ${items.length}';

  Cart copyWith(
          {List<CartItem> items, String location, String user, int count}) =>
      Cart(
        items ?? this.items,
        location ?? this.location,
        user ?? this.user,
        count ?? this.count,
      );

  bool isEmpty() => items.length == 0 ? true : false;

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

  Map<String, dynamic> toJson() => <String, dynamic>{
        'identifier': identifier,
        'qty': quantity,
        'name': name,
      };

  CartItem.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        quantity = json['qty'],
        name = json['name'];

  CartItem incrementQuantity() => CartItem(quantity + 1, identifier, name);

  //Added the case of a cart decrementing into negative quantities
  CartItem decrementQuantity() {
    if (quantity == 0) {
      return CartItem(quantity, identifier, name);
    } else {
      return CartItem(quantity - 1, identifier, name);
    }
  }

  CartItem copyWith({int quantity, String identifier, String name}) => CartItem(
        quantity ?? this.quantity,
        identifier ?? this.identifier,
        name ?? this.name,
      );
}
