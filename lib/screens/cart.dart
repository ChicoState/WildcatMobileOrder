import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:WildcatMobileOrder/shared/cart_item.dart';
import 'package:WildcatMobileOrder/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:transparent_image/transparent_image.dart';

class CartView extends StatelessWidget {
  // builds the ListView that contains all the cart items
  Widget _buildCartList(
      BuildContext context, CartLoaded state, MenuEntity menu) {
    return Container(
      child: ListView.builder(
        shrinkWrap: false,
        itemCount: state.cart.items.length,
        itemBuilder: (context, idx) {
          return CartTile(state.cart.items[idx], idx, menu);
        },
      ),
    );
  }

  // displays an empty cart
  Widget _emptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.shopping_cart, size: 40),
          Text('Your cart is empty.')
        ],
      ),
    );
  }

  Widget _buildCartPage(BuildContext context, List<MenuEntity> menus) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoaded) {
          final int idx =
              menus.indexWhere((i) => i.location == state.cart.location);
          return state.cart.items.length == 0
              ? _emptyCart(context)
              : Column(
                  children: <Widget>[
                    Flexible(
                      flex: 5,
                      child: _buildCartList(context, state, menus[idx]),
                    ),
                    Flexible(
                      child: Card(
                        elevation: 10,
                        borderOnForeground: false,
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                    'Sub: ${menus[idx].calculateCartPrice(state.cart).toStringAsFixed(2)}'),
                                Text('Total: with tax??'),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
//          return Scaffold(
//            appBar: AppBar(
//              title: Row(
//                children: <Widget>[
//                  Icon(Icons.shopping_cart),
//                  Text('Shopping Cart'),
//                ],
//              ),
//            ),
//
//          );
        } else {
          return Loading();
        }
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
          if (state is MenusLoaded) {
            return _buildCartPage(context, state.menus);
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
