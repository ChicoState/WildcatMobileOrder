import 'package:flutter/material.dart';
import 'package:WildcatMobileOrder/menu.dart';

void main() => runApp(MyApp());

final ThemeData td = ThemeData(
  primaryColor: Colors.red[800],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wildcat Mobile Order Shell',
        theme: td,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/locations': (context) => LocationSelection(),
          '/menu': (context) => MenuView(),
        });
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: RaisedButton(
            onPressed: () => Navigator.pushNamed(context, '/locations'),
            child: Text('Select a location')),
      ),
    );
  }
}
