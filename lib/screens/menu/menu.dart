import 'dart:async';
import 'package:WildcatMobileOrder/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:WildcatMobileOrder/models/menu.dart';

class MenuView extends StatelessWidget {
  final String location;
  final Cart cart;

  MenuView({this.location, this.cart});

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
    final MaterialPageRoute route =
        MaterialPageRoute(builder: (context) => ItemView(item, this.cart));
    return Card(
        elevation: 10,
        child: InkWell(
            onTap: () {
              Navigator.push(context, route);
            },
            child: ListTile(
                isThreeLine: true,
                leading: FractionallySizedBox(
                  widthFactor: 0.2,
                  heightFactor: 1.0,
                  child: FutureBuilder(
                      future: item.image,
                      builder: (BuildContext context,
                          AsyncSnapshot<NetworkImage> image) {
                        if (image.hasData) {
                          return FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: MemoryImage(kTransparentImage),
                            image: image.data,
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
                title: Row(
                  children: <Widget>[
                    Text(item.name),
                    Spacer(),
                    Text(item.getPrice()),
                  ],
                ),
                subtitle: Text('placeholder subtitle'))));
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

class ItemView extends StatelessWidget {
  final MenuItem item;
  final Cart cart;

  ItemView(this.item, this.cart);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.item.name),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Center(
                  child: FutureBuilder(
                      future: item.image,
                      builder: (BuildContext context,
                          AsyncSnapshot<NetworkImage> image) {
                        if (image.hasData) {
                          return FadeInImage(
                            fit: BoxFit.fill,
                            placeholder: MemoryImage(kTransparentImage),
                            image: image.data,
                          );
                        } else {
                          return Container();
                        }
                      })),
            ),
            Flexible(
              flex: 1,
              child: Text('placeholder description of the item'),
            ),
            Flexible(
              flex: 1,
              child: Text(item.getPrice()),
            ),
          ],
        ));
  }
}
