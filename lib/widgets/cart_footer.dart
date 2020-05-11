import 'package:flutter/material.dart';
import '../repositories/cart_repository/cart_model.dart';
import '../repositories/cart_repository/cart_repository.dart';
import '../repositories/menu_repository/menu_entity.dart';
import '../screens/order_confirmation.dart';

class CartFooter extends StatelessWidget {
  final Cart cart;
  final MenuEntity menu;
  final CartRepository cartRepo = CartRepository();

  void makeOrder(BuildContext context) async {
    var price = menu.calculateCartPrice(cart);
    var order = await cartRepo.addOrder(cart, price);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => OrderConfirmation(order)));
  }

  CartFooter(this.cart, this.menu);

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
                      text:
                          'Total: \$${getCartPrice()}',
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
