import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

class CartView extends StatelessWidget {
  // builds the individual cart items
  Widget _buildCartItem(
      BuildContext context, CartItem item, int idx, MenuEntity menu) {
    final MenuItem currentItem = menu.items
        .firstWhere((i) => i.identifier == item.identifier, orElse: null);
    return Card(
      child: ListTile(
        isThreeLine: true,
        leading: FractionallySizedBox(
            widthFactor: 0.2,
            heightFactor: 1.0,
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: MemoryImage(kTransparentImage),
              image: currentItem.img,
            )),
        title: Text(currentItem.name),
        subtitle: Row(
          children: <Widget>[
            Text('x ${item.quantity}'),
            Spacer(),
            Text('\$priceplaceholder'),
          ],
        ),
        trailing: ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              tooltip: 'Add one ${currentItem.name}',
              onPressed: () {
                print('add an item from the cart');
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              tooltip: 'Remove one ${currentItem.name}',
              onPressed: () {
                print('remove an item from the cart');
              },
            )
          ],
        ),
      ),
    );
  }

  // builds the ListView that contains all the cart items
  Widget _buildCartList(
      BuildContext context, CartLoaded state, MenuEntity menu) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: state.cart.items.length,
      itemBuilder: (context, idx) {
        return _buildCartItem(context, state.cart.items[idx], idx, menu);
      },
    );
  }

  // displays an empty cart
  Widget _emptyCart(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.shopping_cart),
        Text('Your cart is empty.')
      ],
    );
  }

  Widget _buildCartPage(BuildContext context, List<MenuEntity> menus) {
    BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          final MenuEntity menu =
              menus.firstWhere((i) => i.location == state.cart.location);
          return state.cart.items.length == 0
              ? _emptyCart(context)
              : _buildCartList(context, state, menu);
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenusLoaded) {}
        },
      ),
    );
  }
}

//
//class MyCartView extends StatefulWidget {
//
//  MyCartView();
//
//  @override
//  _MyCartViewState createState() => _MyCartViewState();
//}
//
//class _MyCartViewState extends State<MyCartView> {
//
//  _MyCartViewState();
//
//Widget _buildCartItem2(BuildContext context, CartItem item, int idx) {
//  final inheritedCart = context
//      .dependOnInheritedWidgetOfExactType<InheritedCart>()
//      .cart;
//  return Card(
//    child: ListTile(
//      isThreeLine: true,
//      leading: FractionallySizedBox(
//          widthFactor: 0.2,
//          heightFactor: 1.0,
//          child: FadeInImage(
//            fit: BoxFit.cover,
//            placeholder: MemoryImage(kTransparentImage),
//            image: item.item.img,
//          )),
//      title: Text(item.item.name),
//      subtitle: Row(
//        children: <Widget>[
//          Text('x ${inheritedCart.itemList[idx].quantity.toString()}'),
//          Spacer(),
//          Text(inheritedCart.itemList[idx].getItemPriceString())
//        ],
//      ),
//      trailing: ButtonBar(
//        mainAxisSize: MainAxisSize.min,
//        alignment: MainAxisAlignment.center,
//        children: <Widget>[
//          IconButton(
//            icon: Icon(Icons.add),
//            tooltip: 'Add one ${item.item.name}',
//            onPressed: () {
//              setState(() {
//                inheritedCart.addOne(idx);
//              });
//            },
//          ),
//          IconButton(
//            icon: Icon(Icons.remove),
//            tooltip: 'Remove one ${item.item.name}',
//            onPressed: () {
//              setState(() {
//                inheritedCart.removeOne(idx);
//              });
//            },
//          )
//        ],
//      ),
//    ),
//  );
//}
//
//  Widget _buildCartList(BuildContext context) {
//    final inheritedCart = context.dependOnInheritedWidgetOfExactType<InheritedCart>().cart;
//    return ListView(
//      shrinkWrap: true,
//      children: inheritedCart.itemList
//          .asMap()
//          .map((idx, element) =>
//              MapEntry(idx, _buildCartItem(context, element, idx)))
//          .values
//          .toList(),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final inheritedCart = context.dependOnInheritedWidgetOfExactType<InheritedCart>().cart;
//    final String location = inheritedCart.getLocation();
//    String cartTitle;
//    if (location == '') {
//      cartTitle = 'Empty Cart';
//    } else {
//      cartTitle = 'Cart for $location';
//    }
//    return Scaffold(
//        appBar: AppBar(title: Text(cartTitle)),
//        body: _buildCartList(context));
//  }
//}
//
//class CartView extends StatelessWidget {
//  final Cart cart;
//
//  CartView(this.cart);
//
//  Widget _buildCartItem(BuildContext context, CartItem item, int idx) {
//    return Card(
//      child: ListTile(
//        isThreeLine: true,
//        leading: FractionallySizedBox(
//            widthFactor: 0.2,
//            heightFactor: 1.0,
//            child: FadeInImage(
//              fit: BoxFit.cover,
//              placeholder: MemoryImage(kTransparentImage),
//              image: item.item.img,
//            )),
//        title: Text(item.item.name),
//        subtitle: Row(
//          children: <Widget>[
//            Text('x ${cart.itemList[idx].quantity.toString()}'),
//            Spacer(),
//            Text(cart.itemList[idx].getItemPriceString())
//          ],
//        ),
//        trailing: ButtonBar(
//          mainAxisSize: MainAxisSize.min,
//          alignment: MainAxisAlignment.center,
//          children: <Widget>[
//            IconButton(
//              icon: Icon(Icons.add),
//              tooltip: 'Add one ${item.item.name}',
//              onPressed: () {
//                cart.itemList[idx].addOne();
//              },
//            ),
//            IconButton(
//              icon: Icon(Icons.remove),
//              tooltip: 'Remove one ${item.item.name}',
//              onPressed: () {
//                cart.itemList[idx].removeOne();
//              },
//            )
//          ],
//        ),
//      ),
//    );
//  }
//
//  Widget _buildCartList(BuildContext context) {
//    return ListView(
//      shrinkWrap: true,
//      children: cart.itemList
//          .asMap()
//          .map((idx, element) =>
//              MapEntry(idx, _buildCartItem(context, element, idx)))
//          .values
//          .toList(),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(title: Text('Cart for ${cart.getLocation()}')),
//        body: _buildCartList(context));
//  }
//}
