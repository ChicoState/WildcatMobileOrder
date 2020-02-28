// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final landingTitle = 'Wildcat Mobile Order';
  @override
  Widget build(BuildContext context) {
    //this pulls from the package of english_words and creates a random wordPair
    return MaterialApp(
      
      title: 'Wildcat Mobile Order Shell',
      theme: ThemeData(
        primaryColor: Color(0xff960000),
      ),
      home: LandingPage(title: landingTitle),
    );
  }
}

class LandingPage extends StatelessWidget {
  final String title;

  LandingPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Login'),
          onPressed: () {
            //Navigator.pop(context)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
    );
  }
}

/*
  These two areas are creating a "Stateful" widget that maintains
  state for the lifetime of the Widget
*/
// class RandomWordsState extends State<RandomWords> {
//   final List<WordPair> _suggestions = <WordPair>[];
//   final Set<WordPair> _saved = Set<WordPair>();
//   final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Wildcat Mobile Order Shell'),
//         actions: <Widget>[
//           IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
//         ],
//       ),
//       body: _buildSuggestions(),
//     );
//     //infinite scrolling changes

//     final wordPair = WordPair.random();
//     return Text(wordPair.asPascalCase);
//   }
//   Widget _buildSuggestions() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//       itemBuilder: /*1*/ (context, i) {
//         if (i.isOdd) return Divider(); /*2*/

//         final index = i ~/ 2; /*3*/
//         if (index >= _suggestions.length) {
//           _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//         }
//         return _buildRow(_suggestions[index]);
//       });
//   }

//   Widget _buildRow(WordPair pair) {
//     final bool alreadySaved = _saved.contains(pair);
//     return ListTile(
//       title: Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//       trailing: Icon( //Adds an icon trailing at the end of each row
//         alreadySaved ? Icons.favorite /*heart icon*/ : Icons.favorite_border,
//         color: alreadySaved ? Colors.red : null,
//       ),
//       onTap: () {
//         setState(() {
//           if (alreadySaved) {
//             _saved.remove(pair);
//           }
//           else {
//             _saved.add(pair);
//           }
//         });
//       },
//     );
//   }

//   void _pushSaved() {
//     Navigator.of(context).push(
//       MaterialPageRoute<void>(
//         builder: (BuildContext context) {
//           final Iterable<ListTile> tiles = _saved.map(
//             (WordPair pair) {
//               return ListTile(
//                 title: Text( 
//                   pair.asPascalCase,
//                   style: _biggerFont,
//                 ),
//               );
//             },
//           );
//           final List<Widget> divided = ListTile
//           .divideTiles(
//             context: context,
//             tiles: tiles,
//           )
//           .toList();

//           return Scaffold(
//             appBar: AppBar(
//               title: Text('Saved Suggestions'),
//             ),
//             body: ListView(children: divided),
//           );
//         },
//       ),
//     );
//   }
// }

// class RandomWords extends StatefulWidget {
//   @override 
//   RandomWordsState createState() => RandomWordsState();
// }

/*
  Creating an infinite scrolling ListView
*/
