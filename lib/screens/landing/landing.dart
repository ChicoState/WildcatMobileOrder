import 'package:WildcatMobileOrder/services/auth.dart';
import 'package:flutter/material.dart';

class Landing extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('Home Screen'),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout'),
            onPressed: () async {
              //wait for the signout to clear
              await _auth.signOut();
              //Added a wait for google auth sign in
              await _auth.signOutGoogle();
            },
          )
        ],
      ),
      body: Center(
        child: RaisedButton(
            onPressed: () => Navigator.pushNamed(context, '/locations'),
            child: Text('Select a location')),
      ),
    );
  }
}
