import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import '../blocs/blocs.dart';
import '../widgets/loading.dart';
import '../widgets/order_footer.dart';
import '../widgets/order_summary.dart';

/// Screen to display after ordering
class OrderConfirmation extends StatelessWidget {
  /// Reference to order of Firebase
  final DocumentReference order;

  /// Default constructor for OrderConfirmation
  OrderConfirmation(this.order);

  /// Returns a string of order metadata
  String orderInformation(DateTime date, String orderId) =>
      '${date.toString()}\nID: $orderId';

  Widget _buildOrder(BuildContext context, DocumentSnapshot snapshot) => Column(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: FlareActor(
              'graphics/Success_Check.flr',
              animation: "check",
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
          ),
          Divider(),
          Flexible(
            flex: 5,
            child: OrderSummary(snapshot),
          ),
          Expanded(
            child: SizedBox(),
          ),
          OrderFooter(snapshot),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: FutureBuilder(
          future: order.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              BlocProvider.of<CartBloc>(context).add(CartReset());
              return _buildOrder(context, snapshot.data);
            }
            return Loading();
          }));
}
