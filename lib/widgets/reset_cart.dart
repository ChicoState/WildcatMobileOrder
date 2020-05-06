import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:WildcatMobileOrder/blocs/blocs.dart';

class ResetCartDialog extends StatelessWidget {
  final String location;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ResetCartDialog(this.location, this.scaffoldKey);

  final SnackBar snackBar =
      SnackBar(content: Text('Cart reset, try to add the item again'));

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => AlertDialog(
        title: Text('Location mismatch'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'You currently have items in your cart from a different location.'),
              Text(
                  'Would you like to empty your cart to add an item from $location?'),
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
}
