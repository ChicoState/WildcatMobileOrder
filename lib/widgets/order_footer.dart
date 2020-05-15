import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Widget to display at then bottom of an order summary
class OrderFooter extends StatelessWidget {
  /// DocumentSnapshot of the order
  final DocumentSnapshot snapshot;

  /// Default constructor for OrderFooter
  OrderFooter(this.snapshot);

  @override
  Widget build(BuildContext context) {
    var itemCount = 0;
    for (var i in snapshot.data['items']) {
      itemCount += i['qty'];
    }
//    snapshot.data['items'].forEach((item) {
//      itemCount += item['qty'];
//    });
    DateTime orderTime = snapshot['ordertime'].toDate();
    return Card(
      color: Colors.grey[400],
      elevation: 10,
      borderOnForeground: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                      text: 'Total: \$${snapshot['price'].toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    TextSpan(
                      text: '\nLocation: ${snapshot['location']}\n',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    TextSpan(
                      text: itemCount > 1
                          ? '$itemCount items'
                          : '$itemCount item',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    TextSpan(
                      text: '\n${orderTime.toString()}',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    TextSpan(
                      text: '\nOrder ID: ${snapshot.documentID}',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )
                  ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
