import 'package:WildcatMobileOrder/screens/cart.dart';
import 'package:flutter/material.dart';


class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CartView()
        ));
        print('cart button push');
      },
    );
  }
}