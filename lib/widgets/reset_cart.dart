import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';

/// Dialog screen prompting a cart reset
class ResetCartDialog extends StatelessWidget {
  /// New location that doesn't match current cart's location
  final String location;

  /// Allows access to scaffold to display a snack bar on reset
  final GlobalKey<ScaffoldState> scaffoldKey;

  /// Default constructor for ResetCartDialog
  ResetCartDialog(this.location, this.scaffoldKey);

  /// Scack bar displayed when cart is reset
  final SnackBar snackBar =
      SnackBar(content: Text('Cart reset, try to add the item again'));

  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) => AlertDialog(
          title: Text('Location mismatch'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You currently have items in your cart from a different '
                    'location. \nWould you like to empty your cart to add an '
                    'item from $location?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                BlocProvider.of<CartBloc>(context).add(CartReset());
                scaffoldKey.currentState.showSnackBar(snackBar);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
}
