import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:WildcatMobileOrder/models/menu.dart';



class MenuView extends StatelessWidget {
  final String location;

  MenuView({this.location});

  /// loadMenu
  /// location is the document name under the menus collection
  Widget _loadMenu(BuildContext context, String location) {
    return StreamBuilder<Menu>(
      stream: getMenu(location),
      builder: (context, menu) {
        if (!menu.hasData) return LinearProgressIndicator();

        Menu currentMenu = menu.data;

        return _buildMenuList(context, currentMenu);
      },
    );
  }

  Widget _buildMenuList(BuildContext context, Menu menu) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children:
          menu.items.map((item) => _buildMenuListItem(context, item)).toList(),
    );
  }

  Widget _buildMenuListItem(BuildContext context, MenuItem item) {
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
          trailing: Text(item.getPrice()),
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Stack(
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  Center(
                      child: FutureBuilder(
                          future: item.loadImage(),
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
        ),
      ),
    );
  }

  /// Returns a Stream of the Menu data
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$location'),
        ),
        body: _loadMenu(context, this.location));
  }
}

