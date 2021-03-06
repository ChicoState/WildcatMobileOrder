import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../blocs/blocs.dart';
import '../repositories/menu_repository/menu_entity.dart';
import '../widgets/widgets.dart';

/// Screen to view an individual item
class ItemView extends StatelessWidget {
  /// Location to which the item belongs to
  final String location;

  /// Identifier of the item to display
  final String id;

  /// Provides access to scaffold for ResetUserDialog
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Default constructor for ItemView
  ItemView(this.location, this.id);

  /// Checks if an item can be added to cart, and responds accordingly
  /// Either adds an item, or prompts to reset cart if location mismatch
  void addItem(BuildContext context, MenuItem item) {
    if (BlocProvider
        .of<CartBloc>(context)
        .state is CartLoaded) {
      var cart = (BlocProvider
          .of<CartBloc>(context)
          .state as CartLoaded).cart;
      if (cart.checkItemAdd(item)) {
        BlocProvider.of<CartBloc>(context)
            .add(CartUpdated(cart: cart.addItem(item)));
      } else {
        showDialog<dynamic>(
            context: context,
            builder: (context) => ResetCartDialog(location, scaffoldKey));
      }
    }
  }

  /// Conditionally loads a cart button if the cart is loaded
  Widget _addToCartButton(BuildContext context, MenuItem item) =>
      Align(
          alignment: Alignment.bottomCenter,
          child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.black,
                shape: CircleBorder(),
              ),
              child: BlocProvider
                  .of<CartBloc>(context)
                  .state is CartLoaded
                  ? IconButton(
                color: Colors.white,
                splashColor: Colors.redAccent,
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  addItem(context, item);
                },
              )
                  : Container()));

  Widget _itemImage(BuildContext context, MenuItem item) =>
      Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Hero(
            tag: item.name,
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: MemoryImage(kTransparentImage),
              image: item.img,
            ),
          ));

  Widget _itemDescription(BuildContext context, MenuItem item) =>
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: item.description,
                  style:
                  TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ),
        ),
      );

  Widget _itemPrice(BuildContext context, MenuItem item) =>
      Align(
        alignment: Alignment.topCenter,
        child: Text(
          '\n\$${item.price.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 23, color: Colors.white),
        ),
      );

  /// Root of the ItemView screen
  Widget _buildItemViewScaffold(BuildContext context, MenuItem item) =>
      Scaffold(
          key: scaffoldKey,
          floatingActionButton: CartButton(),
          backgroundColor: Colors.grey[800],
          appBar: AppBar(
            title: Text(item.name),
            backgroundColor: Colors.red[900],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: _itemImage(context, item),
              ),
              Flexible(
                flex: 2,
                child: _itemDescription(context, item),
              ),
              Flexible(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: _addToCartButton(context, item),
                      ),
                      Expanded(
                        child: _itemPrice(context, item),
                      ),
                    ],
                  ))
            ],
          ));

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MenuBloc, MenuState>(builder: (context, state) {
        if (state is MenusLoaded) {
          var item = state.menus
              .firstWhere((m) => m.location == location)
              .getItemById(id);
          return _buildItemViewScaffold(context, item);
        }
        return Loading();
      });
}
