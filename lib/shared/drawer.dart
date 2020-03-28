import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

Drawer hamMenu(BuildContext context/*, MaterialPageRoute routes*/) {
  //final user = Provider.of<FirebaseUser>(context);

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text("Header"),
          decoration: BoxDecoration(
            color: Colors.redAccent,
          ),
        ),
        ListTile(
          title: Text('Home'),
          onTap: () {
            Navigator.pop(context);
            //Navigator.push(context, route);
          },
        ),
        ListTile(
          title: Text('Cart'),
          onTap: () {
            Navigator.pop(context);
            //Navigator.push(context, );
          },
        )
      ],
    ),
  );
}