import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
      return MenuItem.fromMap(item, this.location);
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
  final String gsurl;
  double price;
  final String location;
  Future<NetworkImage> image;

  //Future<CachedNetworkImage> image;

  MenuItem.fromMap(Map<String, dynamic> map, String location)
      : assert(map['name'] != null),
        assert(map['price'] != null),
        location = location,
        name = map['name'],
        category = map['category'],
        gsurl = map['img'],
        price = map['price'] {
    // load image
    image = getImage();
  }

  /// Helper method to return a String representing the price of the MenuItem
  String getPrice() {
    return '\$${this.price.toStringAsFixed(2)}';
  }

  /// Parses a URL of the MenuItem image
  Future<String> loadImage() async {
    final ref = FirebaseStorage.instance.getReferenceFromUrl(this.gsurl);
    dynamic url = await ref.then((doc) => doc.getDownloadURL());
    return url.toString();
  }

  Future<NetworkImage> getImage() async {
    final ref = FirebaseStorage.instance.getReferenceFromUrl(this.gsurl);
    dynamic url = await ref.then((doc) => doc.getDownloadURL());
    return NetworkImage(url);
    //return NetworkImage(url);
  }
}
