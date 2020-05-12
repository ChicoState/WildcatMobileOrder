import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../cart_repository/cart_model.dart';

/// Represents menu and location information
class Menu {
  /// Name of the location
  final String location;

  /// Normal closing time
  final String closeTime;

  /// Closing time on Fridays
  final String fcloseTime;

  /// Normal opening time
  final String openTime;

  /// Widget to display image of the location
  final NetworkImage img;

  /// List of all categories on the menu
  final List<String> categories;

  /// List of menu items
  final List<MenuItem> items;

  /// Constructor used to load menu information from Firebase
  Menu.fromSnapshot(DocumentSnapshot snapshot)
      : location = snapshot.data['name'],
        items = snapshot.data['items']
            .map<MenuItem>(
                (dynamic item) => MenuItem.fromMap(item, snapshot.data['name']))
            .toList(),
        categories = snapshot.data['categories']
            .map<String>((dynamic cat) => cat.toString())
            .toList(),
        openTime = snapshot.data['opentime'],
        closeTime = snapshot.data['closetime'],
        fcloseTime = snapshot.data['fcloseTime'],
        img = NetworkImage(snapshot.data['imgurl']) {
    categories.sort();
    items.sort((a, b) => a.name.compareTo(b.name));
  }

  /// Calculates a cart's price based on current menu information
  double calculateCartPrice(Cart cart) {
    var price = 0.0;
    for (var item in cart.items) {
      price += getItemById(item.identifier).price * item.quantity;
    }
    return price;
  }

  /// Returns a list of all items in a particular category
  List<MenuItem> getCategoryItems(String category) =>
      items.where((item) => item.category == category).toList();

  /// Returns a particular item based on a matching id
  MenuItem getItemById(String id) =>
      items.firstWhere((item) => item.identifier == id, orElse: null);
}

/// Represents an item in a menu
class MenuItem {
  /// Name of menu item
  final String name;

  /// Category of item
  final String category;

  /// Price of item
  final double price;

  /// Location item belongs to
  final String location;

  /// Widget to display an image of item
  final NetworkImage img;

  /// Description of item
  final String description;

  /// Identifier used with Cart objects
  final String identifier;

  /// Constructor to build a MenuItem from Firebase
  MenuItem.fromMap(Map<String, dynamic> map, this.location)
      : assert(map['name'] != null),
        assert(map['price'] != null),
        name = map['name'],
        category = map['category'],
        price = map['price'],
        description = map['description'],
        identifier = '$location-${map['name']}',
        img = NetworkImage(map['imgurl']);
}
