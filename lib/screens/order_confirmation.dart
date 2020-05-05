import 'package:WildcatMobileOrder/widgets/loading.dart';
import 'package:WildcatMobileOrder/widgets/order_footer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:WildcatMobileOrder/blocs/blocs.dart';

class OrderConfirmation extends StatelessWidget {
  final DocumentReference order;

  OrderConfirmation(this.order);

  String orderInformation(DateTime date, String orderId) {
    return '${date.toString()}\nID: $orderId';
  }

  Widget _buildOrder(BuildContext context, DocumentSnapshot snapshot) {
    DateTime orderTime = snapshot['ordertime'].toDate();
    return Column(
      children: <Widget>[
        Flexible(
          flex: 5,
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: snapshot['items'].length,
            itemBuilder: (context, idx) {
              String id = snapshot['items'][idx]['identifier'];
              int qty = snapshot['items'][idx]['qty'];
              return Text('$id - x $qty');
            },
          ),
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
                BlocProvider.of<CartBloc>(context).add(CartSubmitted());
                return _buildOrder(context, snapshot.data);
              }
              return Loading();
            }));
  }
}
