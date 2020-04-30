import 'dart:async';
import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:badges/badges.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget cartButton(BuildContext context) {
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
      //Navigator.push(context, route);
      print('cart button push');
    },
  );
}

class MenuView extends StatelessWidget {
  final String location;


  MenuView({this.location});

  /// loadMenu
  /// location is the document name under the menus collection
  Widget _loadMenu(BuildContext context, String location) {
    return BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenusLoaded) {
            MenuEntity currentMenu = state.menus.firstWhere((menu) =>
            menu.location == location);
            return _buildCategoryList(context, currentMenu);
          }
          return CircularProgressIndicator();
        }
    );
  }

  Widget _buildCategoryList(BuildContext context, MenuEntity menu) {
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
    MaterialPageRoute(
        builder: (context) => ItemView2(item.location, item.identifier));
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
                        //Text(item.getPrice()),
                      ],
                    ),
                    subtitle: Text(item.description)))));
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

class ItemView2 extends StatelessWidget {
  final String location;
  final String id;

  ItemView2(this.location, this.id);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenusLoaded) {
            MenuItem item = state.menus.firstWhere((m) =>
            m.location == location).getItemById(id);
            return Scaffold(
                floatingActionButton: cartButton(context),
                appBar: AppBar(
                  title: Text(item.name),
                ),
                body: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
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
                      child: Text('\$${item.price.toStringAsFixed(2)}'),
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
                                    print('add ${item.name} to cart');
                                  },
                                ))))
                  ],
                ));
          }
          return CircularProgressIndicator();
        }
    );
  }
}
