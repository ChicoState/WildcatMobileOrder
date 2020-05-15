import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../blocs/blocs.dart';
import '../repositories/repositories.dart';
import '../widgets/widgets.dart';

/// Screen to display the current cart
class CartView extends StatelessWidget {
  // builds the ListView that contains all the cart items
  Widget _buildCartList(
          BuildContext context, CartLoaded state, Menu menu) =>
      Container(
        color: Colors.grey[800],
        child: ListView.builder(
          shrinkWrap: false,
          itemCount: state.cart.items.length,
          itemBuilder: (context, idx) =>
              CartTile(state.cart.items[idx], idx, menu),
        ),
      );

  // displays an empty cart
  Widget _emptyCart(BuildContext context) => Container(
        color: Colors.grey[800],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.shopping_cart, size: 40),
              Text('Your cart is empty.')
            ],
          ),
        ),
      );

  Widget _buildCartPage(BuildContext context, List<Menu> menus) =>
      BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            final idx =
                menus.indexWhere((i) => i.location == state.cart.location);
            return state.cart.items.length == 0
                ? _emptyCart(context)
                : Container(
                    color: Colors.black,
                    child: Column(
                      children: <Widget>[
                        Flexible(
                          flex: 5,
                          child: _buildCartList(context, state, menus[idx]),
                        ),
                        Flexible(
                          flex: 1,
                          child: CartFooter(state.cart, menus[idx]),
                        )
                      ],
                    ));
          } else {
            return Loading();
          }
        },
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
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
