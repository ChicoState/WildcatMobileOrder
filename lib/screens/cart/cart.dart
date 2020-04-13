import 'package:WildcatMobileOrder/models/cart.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:WildcatMobileOrder/main.dart';

class MyCartView extends StatefulWidget {

  MyCartView();

  @override
  _MyCartViewState createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {

  _MyCartViewState();

  Widget _buildCartItem(BuildContext context, CartItem item, int idx) {
    final inheritedCart = context.dependOnInheritedWidgetOfExactType<InheritedCart>().cart;
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
            Text('x ${inheritedCart.itemList[idx].quantity.toString()}'),
            Spacer(),
            Text(inheritedCart.itemList[idx].getItemPriceString())
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
                  inheritedCart.addOne(idx);
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              tooltip: 'Remove one ${item.item.name}',
              onPressed: () {
                setState(() {
                  inheritedCart.removeOne(idx);
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartList(BuildContext context) {
    final inheritedCart = context.dependOnInheritedWidgetOfExactType<InheritedCart>().cart;
    return ListView(
      shrinkWrap: true,
      children: inheritedCart.itemList
          .asMap()
          .map((idx, element) =>
              MapEntry(idx, _buildCartItem(context, element, idx)))
          .values
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inheritedCart = context.dependOnInheritedWidgetOfExactType<InheritedCart>().cart;
    return Scaffold(
        appBar: AppBar(title: Text('Cart for ${inheritedCart.getLocation()}')),
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
