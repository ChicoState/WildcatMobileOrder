import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

class CartTile extends StatelessWidget {
  final CartItem item;
  final int idx;
  final MenuEntity menu;

  CartTile(this.item, this.idx, this.menu);

  void dismissItem(BuildContext context, MenuItem item) {
    Cart updatedCart = (BlocProvider.of<CartBloc>(context).state as CartLoaded)
        .cart
        .deleteItem(item);
    BlocProvider.of<CartBloc>(context).add(CartUpdated(cart: updatedCart));
  }

  @override
  Widget build(BuildContext context) {
    final MenuItem menuItem = menu.items
        .firstWhere((i) => i.identifier == item.identifier, orElse: null);
    final Cart cart =
        (BlocProvider.of<CartBloc>(context).state as CartLoaded).cart;
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
                            text:
                                '\n\$${menuItem.price.toStringAsFixed(2)} x ${item.quantity}\n\$${(menuItem.price * item.quantity).toStringAsFixed(2)}',
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
