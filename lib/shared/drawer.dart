import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:WildcatMobileOrder/screens/landing/landing.dart';

Drawer hamMenu(BuildContext context) {
  //final user = Provider.of<FirebaseUser>(context);

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Header'),
          decoration: BoxDecoration(
            color: Colors.redAccent,
          ),
        ),
        ListTile(
          title: Text('Shops'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Landing()));
          },
        ),
        ListTile(
          title: Text('Cart'),
          onTap: () {
            Navigator.pop(context);
            /*Navigator.push(context, 
              MaterialPageRoute(builder: (context) => Cart()));*/
          },
        )
      ],
    ),
  );
}