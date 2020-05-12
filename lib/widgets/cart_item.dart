import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';
import '../blocs/blocs.dart';
import '../repositories/repositories.dart';

/// Widget to display a CartItem on the Cart page
class CartTile extends StatelessWidget {
  /// Object representing the CartItem
  final CartItem item;

  /// Index in the list of items
  final int idx;

  /// Menu that the tile belongs to
  final Menu menu;

  /// Default constructor for CartTile
  CartTile(this.item, this.idx, this.menu);

  /// Dismisses (removes) an item from the cart
  void dismissItem(BuildContext context, MenuItem item) {
    var updatedCart = (BlocProvider.of<CartBloc>(context).state as CartLoaded)
        .cart
        .deleteItem(item);
    BlocProvider.of<CartBloc>(context).add(CartUpdated(cart: updatedCart));
  }

  /// Returns string representation of price
  String getPriceString(MenuItem item, int qty) =>
      '\$${(item.price * qty).toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    final menuItem = menu.items
        .firstWhere((i) => i.identifier == item.identifier, orElse: null);
    final cart = (BlocProvider.of<CartBloc>(context).state as CartLoaded).cart;
    return Dismissible(
      onDismissed: (_) => dismissItem(context, menuItem),
      key: ValueKey(item),
      background: Container(
        color: Colors.red,
      ),
      child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: menuItem.img,
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 6,
                  child: Container(
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: menuItem.name,
                            style: TextStyle(fontSize: 22, color: Colors.white),
                            // textAlign: TextAlign.right,
                          ),
                          TextSpan(
                            text: '\n\$${menuItem.price.toStringAsFixed(2)} x '
                                '${item.quantity}\n'
                                '${getPriceString(menuItem, item.quantity)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          BlocProvider.of<CartBloc>(context)
                              .add(CartUpdated(cart: cart.addItem(menuItem)));
                        }),
                    IconButton(
                        icon: Icon(Icons.remove),
                        color: Colors.white,
                        onPressed: () {
                          BlocProvider.of<CartBloc>(context).add(
                              CartUpdated(cart: cart.removeItem(menuItem)));
                        })
                  ],
                )
              ],
            ),
          )),
    );
  }
}
