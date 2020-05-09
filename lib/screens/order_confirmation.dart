import 'package:WildcatMobileOrder/widgets/loading.dart';
import 'package:WildcatMobileOrder/widgets/order_footer.dart';
import 'package:WildcatMobileOrder/widgets/order_summary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:flare_flutter/flare_actor.dart';

class OrderConfirmation extends StatelessWidget {
  final DocumentReference order;

  OrderConfirmation(this.order);

  String orderInformation(DateTime date, String orderId) {
    return '${date.toString()}\nID: $orderId';
  }

  Widget _buildOrder(BuildContext context, DocumentSnapshot snapshot) {
    return Column(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}
