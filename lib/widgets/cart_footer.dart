import 'package:WildcatMobileOrder/repositories/cart_repository/cart_model.dart';
import 'package:WildcatMobileOrder/repositories/menu_repository/menu_entity.dart';
import 'package:WildcatMobileOrder/screens/order_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:WildcatMobileOrder/repositories/cart_repository/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartFooter extends StatelessWidget {
  final Cart cart;
  final MenuEntity menu;
  final CartRepository cartRepo = CartRepository();

  void makeOrder(BuildContext context) async {
    double price = menu.calculateCartPrice(cart);
    DocumentReference order = await cartRepo.addOrder(cart, price);
    print(order.documentID);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => OrderConfirmation(order)
    ));
  }

  CartFooter(this.cart, this.menu);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                        'Total: \$${menu.calculateCartPrice(cart).toStringAsFixed(2)}',
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
}
