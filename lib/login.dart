import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Login'),
          onPressed: () {
            Navigator.pop(context)
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            )*/;
          },
        ),
      ),
    );
  }
}