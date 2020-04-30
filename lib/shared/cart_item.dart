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
      child: ListTile(
          isThreeLine: true,
          leading: FractionallySizedBox(
              widthFactor: 0.2,
              heightFactor: 1.0,
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: MemoryImage(kTransparentImage),
                image: menuItem.img,
              )),
          title: Text(menuItem.name),
          subtitle: Row(
            children: <Widget>[
              Text('\$${menuItem.price.toStringAsFixed(2)} x ${item.quantity}'),
              Spacer(),
              Text('\$${(menuItem.price * item.quantity).toStringAsFixed(2)}'),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => controller.activeState
                .open(actionType: SlideActionType.secondary),
          )),
    );
  }
}
