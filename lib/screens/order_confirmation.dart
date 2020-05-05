import 'package:WildcatMobileOrder/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderConfirmation extends StatelessWidget {
  final DocumentReference order;

  OrderConfirmation(this.order);

  String orderInformation(DateTime date, String orderId)  {
    return '${date.toString()}\n$orderId';
  }

  Widget _buildOrder(BuildContext context, DocumentSnapshot snapshot) {
    int itemCount = 0;
    snapshot.data['items'].forEach((item) {
      itemCount += item.qty;
    });
    DateTime orderTime = snapshot.data['ordertime'].toDate();
    return Column(
      children: <Widget>[
        Flexible(
          flex: 5,
          child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, idx) {
                return Text(snapshot.data['items'][idx]);
              }
          ),
        ),
        Flexible(
          flex: 4,
          child: ListTile(
            isThreeLine: true,
            title: Text('Order from ${snapshot.data['location']}'),
            subtitle: Text(orderInformation(orderTime, snapshot.data['orderid'])),
            trailing: Text('\$${snapshot.data['price']}'),
          ),
        )
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
            future:,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container();
              }
              return Loading();
            }
        )
    );
  }
}
