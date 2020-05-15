import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Screen to display a submitted order's summary
class OrderSummary extends StatelessWidget {
  /// DocumentSnapshot of submitted order
  final DocumentSnapshot snapshot;

  /// Default constructor for OrderSummary
  OrderSummary(this.snapshot);

  /// Style used to display text
  final TextStyle style = TextStyle(fontSize: 20);

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.all(12),
      child: ListView.separated(
        separatorBuilder: (context, idx) => Divider(),
        itemCount: snapshot['items'].length,
        itemBuilder: (context, idx) {
          String id = snapshot['items'][idx]['identifier'];
          int qty = snapshot['items'][idx]['qty'];
          return Text(
            '$id - x $qty',
            style: style,
          );
        },
      ),
    );
}
