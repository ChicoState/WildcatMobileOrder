import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../screens/cart.dart';

/// Floating action button for the cart
class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            return FloatingActionButton(
              child: Badge(
                badgeContent: Text(state.cart.getCount().toString()),
                elevation: 10,
                position: BadgePosition.topRight(right: -22, top: -22),
                child: Icon(Icons.shopping_cart),
              ),
              backgroundColor: Colors.red,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartView()));
              },
            );
          }
          // if cart is not loaded, disable cart button
          return FloatingActionButton(
            child: Icon(Icons.remove_shopping_cart),
            disabledElevation: 0.0,
            onPressed: null,
          );
        },
      );
}
