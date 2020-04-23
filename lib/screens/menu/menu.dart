import 'dart:async';
import 'package:WildcatMobileOrder/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:WildcatMobileOrder/models/menu.dart';
import 'package:badges/badges.dart';
import 'package:WildcatMobileOrder/screens/cart/cart.dart';
import 'package:WildcatMobileOrder/main.dart';

Widget cartButton(BuildContext context) {
  final inheritedCart = context.dependOnInheritedWidgetOfExactType<InheritedCart>().cart;
  final MaterialPageRoute route =
      MaterialPageRoute(builder: (context) => MyCartView());
  return FloatingActionButton(
    child: Icon(Icons.shopping_cart),
//    child: Badge(
//      badgeContent: Text(inheritedCart.itemCount.toString()),
//      elevation: 10,
//      position: BadgePosition.topRight(right: -22, top: -22),
//      child: Icon(Icons.shopping_cart),
//    ),
    backgroundColor: Colors.red,
    onPressed: () {
      Navigator.push(context, route);
    },
  );
}

class MenuView extends StatelessWidget {
  final String location;


  MenuView({this.location});

  /// Returns a Stream of the Menu data
  Stream<DocumentSnapshot> getMenu(String location) {
    return Firestore.instance
        .collection('menus')
        .document(location)
        .snapshots();
  }

  /// loadMenu
  /// location is the document name under the menus collection
  Widget _loadMenu(BuildContext context, String location) {
    return StreamBuilder<DocumentSnapshot>(
      stream: getMenu(location),
      builder: (context, menu) {
        if (!menu.hasData) return LinearProgressIndicator();

        Menu currentMenu = Menu.fromSnapshot(menu.data);

        return _buildCategoryList(context, currentMenu);
      },
    );
  }

  Widget _buildCategoryList(BuildContext context, Menu menu) {
    return ListView(
      //shrinkWrap: true,
      children: menu.categories.map((category) {
        return ExpansionTile(
          title: Text(category),
          children: <Widget>[
            _buildMenuList(context, menu.getCategoryItems(category)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMenuList(BuildContext context, List<MenuItem> itemsList) {
    return ListView(
      //itemExtent: 100,
      shrinkWrap: true,
      children: itemsList.map((item) {
        return _buildMenuListItem(context, item);
      }).toList(),
    );
  }

  Widget _buildMenuListItem(BuildContext context, MenuItem item) {
    final MaterialPageRoute route =
        MaterialPageRoute(builder: (context) => ItemView(item));
    // try to resolve image here
    var configuration = createLocalImageConfiguration(context);
    item.img.resolve(configuration);
    return Container(
        child: Card(
            elevation: 10,
            child: InkWell(
                onTap: () {
                  Navigator.push(context, route);
                },
                child: ListTile(
                    dense: false,
                    isThreeLine: true,
                    leading: FractionallySizedBox(
                        widthFactor: 0.2,
                        heightFactor: 1.0,
                        child: Hero(
                            tag: item.name,
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: MemoryImage(kTransparentImage),
                              image: item.img,
                            ))),
                    title: Row(
                      children: <Widget>[
                        Text(item.name),
                        Spacer(),
                        Text(item.getPrice()),
                      ],
                    ),
                    subtitle: Text('placeholder subtitle')))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: cartButton(context),
        appBar: AppBar(
          title: Text('$location'),
        ),
        body: _loadMenu(context, this.location));
  }
}

class ItemView extends StatefulWidget {
  final MenuItem item;
  //final Cart cart;

  ItemView(this.item);

  @override
  _ItemViewState createState() => _ItemViewState(this.item);
}

class _ItemViewState extends State<ItemView> {
  final MenuItem item;
  //final Cart cart;

  _ItemViewState(this.item);

  void _alertWrongLocation(MenuItem item, int quantity, Cart cart) {
    // show a dialog if location mismatch
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        String currentLocation = cart.getLocation();
        String newLocation = item.location;
        return AlertDialog(
          title: Text('Adding item from different location'),
          content: Text(
              'Your cart currently contains items from $currentLocation. Would you like to empty your cart, and add items from $newLocation?'),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text('Yes, start a new cart'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  cart.setLocation(newLocation);
                  cart.addItem(item, quantity);
                });
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Cart cart = context.dependOnInheritedWidgetOfExactType<InheritedCart>().cart;
    return Scaffold(
        floatingActionButton: cartButton(context),
        appBar: AppBar(
          title: Text(this.item.name),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: item.name,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: MemoryImage(kTransparentImage),
                      image: item.img,
                    ),
                  )),
            ),
            // add spacing below image
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 2,
              child: Text(item.description),
            ),
            Flexible(
              flex: 3,
              child: Text(item.getPrice()),
            ),
            Flexible(
                flex: 3,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.red,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          color: Colors.white,
                          splashColor: Colors.redAccent,
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            // check if the locations match, warn if not
                            if (cart.checkLocation(item.location) && cart.location != '') {
                              setState(() {
                                cart.addItem(this.item, 1);
                              });
                            } else {
                              // do something if checkLocation fails
                              _alertWrongLocation(item, 1, cart);
                            }
                          },
                        ))))
          ],
        ));
  }
}
