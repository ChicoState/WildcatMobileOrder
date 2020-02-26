// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //this pulls from the package of english_words and creates a random wordPair
    return MaterialApp(
      title: 'Wildcat Mobile Order Shell',
      theme: ThemeData(
        primaryColor: Colors.red[800],
      ),
      home: RandomWords(),
    );
  }
}

/*
  These two areas are creating a "Stateful" widget that maintains
  state for the lifetime of the Widget
*/
class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wildcat Mobile Order Shell'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: () {}),
          // placeholder with no functionality
        ],
      ),
      body: Builder(builder: (context) => _buildMenu(context)),
    );
  }

//  Widget _buildSuggestions() {
//    return ListView.builder(
//      padding: const EdgeInsets.all(16.0),
//      itemBuilder: /*1*/ (context, i) {
//        if (i.isOdd) return Divider(); /*2*/
//
//        final index = i ~/ 2; /*3*/
//        if (index >= _suggestions.length) {
//          _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//        }
//        return _buildRow(_suggestions[index]);
//      });
//  }

  Widget _buildMenu(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('menus').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    int idx =
        snapshot.indexWhere((snap) => snap.documentID == 'Coffee Place 1');
    print(idx);

    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final item = MenuItem.fromSnapshot(data);

    return Padding(
      key: ValueKey(item.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(item.name),
          trailing: Text(item.price.toString()),
          onTap: () => print(item),
        ),
      ),
    );
  }
}

//  Widget _buildRow(WordPair pair) {
//    final bool alreadySaved = _saved.contains(pair);
//    return ListTile(
//      title: Text(
//        pair.asLowerCase,
//        style: _biggerFont,
//      ),
//      trailing: Icon( //Adds an icon trailing at the end of each row
//        alreadySaved ? Icons.favorite /*heart icon*/ : Icons.favorite_border,
//        color: alreadySaved ? Colors.red : null,
//      ),
//      onTap: () {
//        setState(() {
//          if (alreadySaved) {
//            _saved.remove(pair);
//          }
//          else {
//            _saved.add(pair);
//          }
//        });
//      },
//    );
//  }

//  // navigates to another page
//  void _pushSaved() {
//    Navigator.of(context).push(
//      MaterialPageRoute<void>(
//        builder: (BuildContext context) {
//          final Iterable<ListTile> tiles = _saved.map(
//            (WordPair pair) {
//              return ListTile(
//                title: Text(
//                  pair.asPascalCase,
//                  style: _biggerFont,
//                ),
//              );
//            },
//          );
//          final List<Widget> divided = ListTile
//          .divideTiles(
//            context: context,
//            tiles: tiles,
//          )
//          .toList();
//
//          return Scaffold(
//            appBar: AppBar(
//              title: Text('Saved Suggestions'),
//            ),
//            body: ListView(children: divided),
//          );
//        },
//      ),
//    );
//  }
//}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

// TODO: Add Category to MenuItem
class MenuItem {
  final String name;
  final double price;
  final String location;
  final DocumentReference reference;

  MenuItem.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['price'] != null),
        assert(map['location'] != null),
        location = map['location'],
        name = map['name'],
        price = map['price'];

  MenuItem.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}

// TODO: Fix Menu constructor
class Menu {
  final String location;
  List<MenuItem> items;
  DocumentReference reference;

  Menu.fromList(List<dynamic> list, {this.reference})
      : location = 'Coffee_place1',
        items = list;
}
