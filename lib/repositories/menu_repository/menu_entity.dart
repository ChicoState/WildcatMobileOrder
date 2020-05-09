import 'package:WildcatMobileOrder/repositories/cart_repository/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuEntity {
  final String location;
  final String closeTime;
  final String fcloseTime;
  final String openTime;
  final NetworkImage img;
  final List<String> categories;
  final List<MenuItem> items;

  MenuEntity.fromSnapshot(DocumentSnapshot snapshot)
      : location = snapshot.data['name'],
        items = snapshot.data['items'].map<MenuItem>((item) {
          return MenuItem.fromMap(item, snapshot.data['name']);
        }).toList(),
        categories = snapshot.data['categories'].map<String>((cat) {
          return cat.toString();
        }).toList(),
        openTime = snapshot.data['opentime'],
        closeTime = snapshot.data['closetime'],
        fcloseTime = snapshot.data['fcloseTime'],
        img = NetworkImage(snapshot.data['imgurl']) {
    categories.sort();
    items.sort((a, b) => a.name.compareTo(b.name));
  }

  double calculateCartPrice(Cart cart) {
    double price = 0;
    cart.items.forEach((i) {
      price += getItemById(i.identifier).price * i.quantity;
    });
    return price;
  }

  // returns a list of all items in a particular category
  List<MenuItem> getCategoryItems(String category) {
    return this.items.where((item) => item.category == category).toList();
  }

  MenuItem getItemById(String id) {
    return this.items.firstWhere((item) => item.identifier == id, orElse: null);
  }
}

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
        identifier = '$location-${map['name']}',
        img = NetworkImage(map['imgurl']);
}
