import 'package:WildcatMobileOrder/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderConfirmation extends StatelessWidget {
  final DocumentReference order;

  OrderConfirmation(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: FutureBuilder(
        future: ,
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
