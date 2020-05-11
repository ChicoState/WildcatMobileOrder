import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../cart_repository/cart_model.dart';


class Menu {
  final String location;
  final String closeTime;
  final String fcloseTime;
  final String openTime;
  final NetworkImage img;
  final List<String> categories;
  final List<MenuItem> items;

  Menu.fromSnapshot(DocumentSnapshot snapshot)
      : location = snapshot.data['name'],
        items = snapshot.data['items'].map<MenuItem>((dynamic item) =>
            MenuItem.fromMap(item, snapshot.data['name'])
        ).toList(),
        categories = snapshot.data['categories'].map<String>((dynamic cat) =>
            cat.toString()
        ).toList(),
        openTime = snapshot.data['opentime'],
        closeTime = snapshot.data['closetime'],
        fcloseTime = snapshot.data['fcloseTime'],
        img = NetworkImage(snapshot.data['imgurl']) {
    categories.sort();
    items.sort((a, b) => a.name.compareTo(b.name));
  }

  double calculateCartPrice(Cart cart) {
    var price = 0.0;
    for (var item in cart.items) {
      price += getItemById(item.identifier).price * item.quantity;
    }
    return price;
  }

  // returns a list of all items in a particular category
  List<MenuItem> getCategoryItems(String category) =>
      items.where((item) => item.category == category).toList();

  MenuItem getItemById(String id) =>
      items.firstWhere((item) => item.identifier == id, orElse: null);
}

class MenuItem {
  final String name;
  final String category;
  final double price;
  final String location;
  final NetworkImage img;
  final String description;
  final String identifier;

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
