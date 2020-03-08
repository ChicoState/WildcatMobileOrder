import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:transparent_image/transparent_image.dart';

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
          title: Text('$location'),
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
      child: ExpansionTile(
        title: Text(item.name),
        initiallyExpanded: false,
        trailing: Text(item.price.toString()),
        children: <Widget>[
          SizedBox(
            height: 200,
            child: Stack(
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
                Center(
                    child: FutureBuilder(
                        future: _loadImage(item.gsurl),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> image) {
                          if (image.hasData) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: image.data,
                                ));
                          } else {
                            return Container();
                          }
                        })),
              ],
            ),
          ),
          
        ],
        //onTap: () => print(item),
      ),
    ),
  );
}

Future<String> _loadImage(String gs) async {
  final ref = FirebaseStorage.instance.getReferenceFromUrl(gs);
  dynamic url = await ref.then((doc) => doc.getDownloadURL());
  return url.toString();
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
