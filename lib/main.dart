import 'package:flutter/material.dart';

import 'login.dart';
void main() => runApp(MyApp());



































//* All above area is for merge with master branch
// class MyApp extends StatelessWidget {
//   final landingTitle = 'Wildcat Mobile Order';
//   @override
//   Widget build(BuildContext context) {
//     //this pulls from the package of english_words and creates a random wordPair
//     return MaterialApp(
      
//       title: 'Wildcat Mobile Order Shell',
//       theme: ThemeData(
//         primaryColor: Color(0xff960000),
//       ),
//       home: LandingPage(title: landingTitle),
//     );
//   }
// }

// class LandingPage extends StatelessWidget {
//   final String title;

//   LandingPage({Key key, this.title}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Center(
//         child: RaisedButton(
//           child: Text('Login'),
//           onPressed: () {
//             //Navigator.pop(context)
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => LoginPage()),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }