import 'package:WildcatMobileOrder/services/auth.dart';
import 'package:WildcatMobileOrder/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WildcatMobileOrder/screens/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:WildcatMobileOrder/models/cart.dart';



void main() => runApp(MyApp());

final ThemeData td = ThemeData(
  primaryColor: Colors.red[800],
);

class InheritedCart extends InheritedWidget {
  InheritedCart({
    Key key,
    @required Widget child,
    this.cart,
  }) : super(key: key, child: child);
  final Cart cart;

  @override
  bool updateShouldNotify(InheritedCart oldCart) =>
      cart.itemCount != oldCart.cart.itemCount;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().user,
      child: InheritedCart(
        cart: new Cart(),
          child: MaterialApp(
              title: 'Wildcat Mobile Order Shell',
              theme: td,
              initialRoute: '/',
              routes: {
            //Inserted a wrapper to help solicit Authentication from Login Page
            '/': (context) => Wrapper(),
            '/menu': (context) => MenuView(),
          })),
    );
  }
}
