import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:transparent_image/transparent_image.dart';

class CartTile extends StatelessWidget {
  final CartItem item;
  final int idx;
  final MenuEntity menu;

  CartTile(this.item, this.idx, this.menu);

  final SlidableController controller = SlidableController();

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
    return Slidable(
        controller: controller,
        key: ValueKey(this.item.hashCode),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        dismissal: SlidableDismissal(
          dragDismissible: false,
          child: SlidableDrawerDismissal(),
          onDismissed: (actionType) {
            Cart updatedCart =
                (BlocProvider.of<CartBloc>(context).state as CartLoaded)
                    .cart
                    .deleteItem(menuItem);
            BlocProvider.of<CartBloc>(context)
                .add(CartUpdated(cart: updatedCart));
          },
        ),
        actions: <Widget>[
          IconSlideAction(
            icon: Icons.delete,
            caption: 'Remove',
            color: Colors.red,
            onTap: () {
              print('delete ${menuItem.name} from cart');
              controller.activeState.dismiss();
            },
          )
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            closeOnTap: false,
            icon: Icons.add,
            color: Colors.green,
            onTap: () {
              Cart updatedCart =
                  (BlocProvider.of<CartBloc>(context).state as CartLoaded)
                      .cart
                      .addItem(menuItem);
              BlocProvider.of<CartBloc>(context)
                  .add(CartUpdated(cart: updatedCart));
            },
          ),
          IconSlideAction(
              closeOnTap: false,
              icon: Icons.remove,
              color: Colors.blue,
              onTap: () {
                Cart updatedCart =
                    (BlocProvider.of<CartBloc>(context).state as CartLoaded)
                        .cart
                        .removeItem(menuItem);
                if (updatedCart.items
                        .firstWhere((i) => i.identifier == menuItem.identifier)
                        .quantity ==
                    0) {
                  controller.activeState.dismiss();
                } else {
                  BlocProvider.of<CartBloc>(context)
                      .add(CartUpdated(cart: updatedCart));
                }
              })
        ],
        child: Card(
            color: Colors.black,
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: menuItem.img,
                  ),
                ),
                Spacer(flex: 1),
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
                Expanded(
                  //flex: 1,
                  child: ButtonBar(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () {
                            Cart updatedCart =
                                (BlocProvider.of<CartBloc>(context).state
                                        as CartLoaded)
                                    .cart
                                    .addItem(menuItem);
                            BlocProvider.of<CartBloc>(context)
                                .add(CartUpdated(cart: updatedCart));
                          }),
                      IconButton(
                          icon: Icon(Icons.remove),
                          color: Colors.white,
                          onPressed: () {
                            Cart updatedCart =
                                (BlocProvider.of<CartBloc>(context).state
                                        as CartLoaded)
                                    .cart
                                    .removeItem(menuItem);
                            if (updatedCart.items
                                    .firstWhere((i) =>
                                        i.identifier == menuItem.identifier)
                                    .quantity ==
                                0) {
                              controller.activeState.dismiss();
                            } else {
                              BlocProvider.of<CartBloc>(context)
                                  .add(CartUpdated(cart: updatedCart));
                            }
                          })
                    ],
                  ),
                )
              ],
            )));
  }
}
