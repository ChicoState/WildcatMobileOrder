import 'package:WildcatMobileOrder/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        Flexible(
          flex: 4,
//          child: ListTile(
//            isThreeLine: true,
//            title: Text('Order from ${snapshot['location']}'),
//            subtitle: Text(orderInformation(orderTime, snapshot['orderid'])),
//            trailing: Text('\$${snapshot['price'].toStringAsFixed(2)}'),
//          ),
        child: _orderSummary(context, snapshot)
        )
      ],
    );
  }

  Widget _orderSummary(BuildContext context, DocumentSnapshot snapshot) {
    int itemCount = 0;
    snapshot.data['items'].forEach((item) {
      itemCount += item['qty'];
    });
    DateTime orderTime = snapshot['ordertime'].toDate();
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Order from ${snapshot['location']}'),
              Text('\$${snapshot['price'].toStringAsFixed(2)}'),
            ],
          ),
          Divider(),
          Text('$itemCount items'),
          Text('Order placed on ${orderTime.toString()}'),
          Text('Order ID: ${snapshot.documentID}'),
        ],
      ),
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
                return _buildOrder(context, snapshot.data);
              }
              return Loading();
            }));
  }
}
