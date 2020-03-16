import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
        reference = snapshot.reference,
        items = snapshot['items'].map<MenuItem>((item) {
          return MenuItem.fromMap(item);
        }).toList(),
        categories = snapshot['categories'].map<String>((category) {
          return category.toString();
        }).toList();
}

/// Individual items from a Menu
// TODO: Member functions for sorting by category, only return items from a particular category
class MenuItem {
  String name;
  String category;
  String gsurl;
  double price;

  MenuItem.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['price'] != null),
        name = map['name'],
        category = map['category'],
        gsurl = map['img'],
        price = map['price'];

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
}
