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
    // sort menu items and categories alphabetically
    categories.sort();
    items.sort((a, b) => a.name.compareTo(b.name));
  }

  // returns a list of all items in a particular category
  List<MenuItem> getCategoryItems(String category) {
    return this.items.where((item) => item.category == category).toList();
  }
}

/// Individual items from a Menu
class MenuItem {
  final String name;
  final String category;
  final double price;
  final String location;
  final NetworkImage img;
  final String description;
  final String identifier;

  MenuItem.fromMap(Map<String, dynamic> map, String location)
      : assert(map['name'] != null),
        assert(map['price'] != null),
        name = map['name'],
        location = location,
        category = map['category'],
        price = map['price'],
        description = map['description'],
        identifier = '${map['location']}-${map['name']}',
        img = NetworkImage(map['imgurl']);
}
