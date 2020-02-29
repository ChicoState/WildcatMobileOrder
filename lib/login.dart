import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final _controllerEmail = TextEditingController();
  final _controllerPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              child: TextFormField(
              controller: _controllerEmail,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email'
                ),
              ),
              margin: const EdgeInsets.only(bottom: 5, top: 160, left: 20, right: 20),
              color: Colors.amber[100]
            )
          ),
          Center(
            child: Container(
              child: TextFormField(
              controller: _controllerPass,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password'
                ),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              color: Colors.amber[100]
            )
          ),
        ]
      )
    );
  }
}
/*
Center(
        child: RaisedButton(
          child: Text('Exit'),
          onPressed: () {
            build(context)
            //Navigator.pop(context)
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            )*/;
          },
        ),
      ),
final _controllerEmail = TextEditingController();
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      alignment: Alignment.center,
        /*padding:*/
        child: TextFormField(
          controller: _controllerEmail,
          decoration: InputDecoration(border: OutlineInputBorder()),
      )
    )
  );
}
*/