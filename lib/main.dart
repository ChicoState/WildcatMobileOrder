import 'package:flutter/material.dart';
import 'package:flutter_prac/menu.dart';

void main() => runApp(MyApp());

final ThemeData td = ThemeData(
  primaryColor: Colors.red[800],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //this pulls from the package of english_words and creates a random wordPair
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

/*
  These two areas are creating a "Stateful" widget that maintains
  state for the lifetime of the Widget
*/
//class HomePageState extends State<HomePage> {
//  final List<WordPair> _suggestions = <WordPair>[];
//  final Set<WordPair> _saved = Set<WordPair>();
//  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Wildcat Mobile Order Shell'),
//        actions: <Widget>[
//          IconButton(icon: Icon(Icons.list), onPressed: () {}),
//          // placeholder with no functionality
//        ],
//      ),
//      body: Builder(builder: (context) => HomeScreen()),
//    );
//  }
//}

//class HomePage extends StatefulWidget {
//  @override
//  HomePageState createState() => HomePageState();
//}

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
