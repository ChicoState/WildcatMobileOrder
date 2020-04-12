import 'package:WildcatMobileOrder/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:WildcatMobileOrder/models/menu.dart';
import 'package:transparent_image/transparent_image.dart';

class MyCartView extends StatefulWidget {
  final Cart cart;

  MyCartView(this.cart);

  @override
  _MyCartViewState createState() => _MyCartViewState(cart);
}

class _MyCartViewState extends State<MyCartView> {
  final Cart cart;

  _MyCartViewState(this.cart);

  Widget _buildCartItem(BuildContext context, CartItem item, int idx) {
    return Card(
      child: ListTile(
        isThreeLine: true,
        leading: FractionallySizedBox(
            widthFactor: 0.2,
            heightFactor: 1.0,
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: MemoryImage(kTransparentImage),
              image: item.item.img,
            )),
        title: Text(item.item.name),
        subtitle: Row(
          children: <Widget>[
            Text('x ${cart.itemList[idx].quantity.toString()}'),
            Spacer(),
            Text(cart.itemList[idx].getItemPriceString())
          ],
        ),
        trailing: ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add one ${item.item.name}',
              onPressed: () {
                setState(() {
                  cart.addOne(idx);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              tooltip: 'Remove one ${item.item.name}',
              onPressed: () {
                setState(() {
                  cart.removeOne(idx);
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: cart.itemList
          .asMap()
          .map((idx, element) =>
              MapEntry(idx, _buildCartItem(context, element, idx)))
          .values
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Cart for ${cart.getLocation()}')),
        body: _buildCartList(context));
  }
}

class CartView extends StatelessWidget {
  final Cart cart;

  CartView(this.cart);

  Widget _buildCartItem(BuildContext context, CartItem item, int idx) {
    return Card(
      child: ListTile(
        isThreeLine: true,
        leading: FractionallySizedBox(
            widthFactor: 0.2,
            heightFactor: 1.0,
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: MemoryImage(kTransparentImage),
              image: item.item.img,
            )),
        title: Text(item.item.name),
        subtitle: Row(
          children: <Widget>[
            Text('x ${cart.itemList[idx].quantity.toString()}'),
            Spacer(),
            Text(cart.itemList[idx].getItemPriceString())
          ],
        ),
        trailing: ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add one ${item.item.name}',
              onPressed: () {
                cart.itemList[idx].addOne();
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              tooltip: 'Remove one ${item.item.name}',
              onPressed: () {
                cart.itemList[idx].removeOne();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: cart.itemList
          .asMap()
          .map((idx, element) =>
              MapEntry(idx, _buildCartItem(context, element, idx)))
          .values
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Cart for ${cart.getLocation()}')),
        body: _buildCartList(context));
  }
}
