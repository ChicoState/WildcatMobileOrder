import 'package:WildcatMobileOrder/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:WildcatMobileOrder/models/menu.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:intl/intl.dart';


class CartView extends StatelessWidget {
  final Cart cart;

  final currencyFormat = NumberFormat.simpleCurrency();

  CartView(this.cart);

  ExpansionPanel _buildCartHeader(BuildContext context, MenuItem item,
      int qty) {
    return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            leading: FractionallySizedBox(
                widthFactor: 0.2,
                heightFactor: 1.0,
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: item.img,
                )),
            title: Text(item.name),
            subtitle: Text('x ${qty.toString()}'),
            trailing: Text(
                '${currencyFormat.format(cart.calcItemPrice(item))}'),
          );
        },
        body: ButtonBar(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add one ${item.name}',
              onPressed: () {
                cart.editQuantity(item, cart.getItemQuantity(item) + 1);
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              tooltip: 'Remove one ${item.name}',
              onPressed: () {
                cart.editQuantity(item, cart.getItemQuantity(item) - 1);
              },
            )
          ],
        )
    );
  }

  Widget _buildCartItem(BuildContext context, MenuItem item, int qty) {
    return Card(
        child: ListTile(
          leading: FractionallySizedBox(
              widthFactor: 0.2,
              heightFactor: 1.0,
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: MemoryImage(kTransparentImage),
                image: item.img,
              )),
          title: Text(item.name),
          subtitle: Text('x ${qty.toString()}'),
          trailing: Text('${currencyFormat.format(cart.calcItemPrice(item))}'),
        ));
  }

  Widget _buildCartList(BuildContext context) {
    List<ExpansionPanel> _cartItems = new List<ExpansionPanel>();
    cart.items.forEach((item, qty) {
      _cartItems.add(_buildCartHeader(context, item, qty));
    });
    return ExpansionPanelList(
      children: _cartItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart for ${cart.getLocation()}')),
      body: SingleChildScrollView(
        child:  _buildCartList(context),
      )
    );
  }
}
