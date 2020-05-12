import 'package:flutter/material.dart';
import '../repositories/cart_repository/cart_model.dart';
import '../repositories/cart_repository/cart_repository.dart';
import '../repositories/menu_repository/menu_entity.dart';
import '../screens/order_confirmation.dart';

/// Widget to display at the bottom of a cart
class CartFooter extends StatelessWidget {
  /// Cart object to display data
  final Cart cart;

  /// Menu belonging to Cart's location
  final Menu menu;

  /// CartRepository to submit cart data to
  final CartRepository cartRepo = CartRepository();

  /// Submits an order to Firebase
  void makeOrder(BuildContext context) async {
    var price = menu.calculateCartPrice(cart);
    var order = await cartRepo.addOrder(cart, price);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => OrderConfirmation(order)));
  }

  /// Default constructor for CartFooter
  CartFooter(this.cart, this.menu);

  /// Returns cart price with proper price format
  String getCartPrice() => menu.calculateCartPrice(cart).toStringAsFixed(2);

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.grey[400],
        elevation: 10,
        borderOnForeground: false,
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: 'Total: \$${getCartPrice()}',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    TextSpan(
                      text: '\nLocation: ${menu.location}',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ]),
                ),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        color: Colors.red[900],
                        child: Text('Order from ${menu.location}'),
                        onPressed: () {
                          makeOrder(context);
                        },
                      )),
                )
              ],
            )
          ],
        ),
      );
}
