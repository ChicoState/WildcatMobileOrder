import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a location'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Coffee Place 1'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuView(
                          location: 'Coffee Place 1',
                        )));
          },
        ),
      ),
    );
  }
}

class MenuView extends StatelessWidget {
  final String location;

  MenuView({this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('First Screen'),
        ),
        body: loadMenu(context, this.location));
  }
}

/// loadMenu
/// location is the document name under the menus collection
Widget loadMenu(BuildContext context, String location) {
  return StreamBuilder<Menu>(
    stream: getMenu(location),
    builder: (context, menu) {
      if (!menu.hasData) return LinearProgressIndicator();

      Menu currentMenu = menu.data;

      return _buildList(context, currentMenu);
    },
  );
}

Widget _buildList(BuildContext context, Menu menu) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: menu.items.map((item) => _buildListItem(context, item)).toList(),
  );
}

Widget _buildListItem(BuildContext context, MenuItem item) {
  return Padding(
    key: ValueKey(item.name),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        title: Text(item.name),
        trailing: Text(item.price.toString()),
        onTap: () => print(item),
      ),
    ),
  );
}

Stream<Menu> getMenu(String location) {
  return Firestore.instance
      .collection('menus')
      .document(location)
      .get()
      .then((snapshot) {
    // create Menu object here
    return Menu.fromSnapshot(snapshot);
  }).asStream();
}

// TODO: Add Category to MenuItem
// TODO: Member functions for sorting by category
class MenuItem {
  final String name;
  final double price;

  MenuItem.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['price'] != null),
        name = map['name'],
        price = map['price'];
}

class Menu {
  final String location;
  List<MenuItem> items;
  DocumentReference reference;

  // constructor for Menu object
  // uses initialization list
  Menu.fromSnapshot(DocumentSnapshot snapshot)
      : location = snapshot['name'],
        reference = snapshot.reference,
        items = snapshot['items'].map<MenuItem>((item) {
          return MenuItem.fromMap(item);
        }).toList();
}
