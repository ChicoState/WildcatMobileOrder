import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Manages a Locations Menu
class Menu {
  final String location;
  List<MenuItem> items;
  List<String> categories;
  DocumentReference reference;

  // constructor for Menu object
  // uses initialization list
  Menu.fromSnapshot(DocumentSnapshot snapshot)
      : location = snapshot['name'],
        reference = snapshot.reference {
    items = snapshot['items'].map<MenuItem>((item) {
      return MenuItem.fromMap(item, location);
    }).toList();
    categories = snapshot['categories'].map<String>((category) {
      return category.toString();
    }).toList();
  }
}

/// Individual items from a Menu
// TODO: Member functions for sorting by category, only return items from a particular category
class MenuItem {
  final String name;
  final String category;
  double price;
  final String location;
  final NetworkImage img;

  MenuItem.fromMap(Map<String, dynamic> map, String location)
      : assert(map['name'] != null),
        assert(map['price'] != null),
        name = map['name'],
        location = location,
        category = map['category'],
        price = map['price'],
        img = NetworkImage(map['imgurl']);

  /// Helper method to return a String representing the price of the MenuItem
  String getPrice() {
    return '\$${this.price.toStringAsFixed(2)}';
  }
}
