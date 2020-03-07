import 'package:WildcatMobileOrder/services/auth.dart';
import 'package:WildcatMobileOrder/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:WildcatMobileOrder/screens/menu/menu.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

void main() => runApp(MyApp());

final ThemeData td = ThemeData(
  primaryColor: Colors.red[800],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
          title: 'Wildcat Mobile Order Shell',
          theme: td,
          initialRoute: '/',
          routes: {
            //Inserted a wrapper to help solicit Authentication from Login Page
            '/': (context) => Wrapper(),
            '/locations': (context) => LocationSelection(),
            '/menu': (context) => MenuView(),
          }),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       body: Center(
//         child: RaisedButton(
//             onPressed: () => Navigator.pushNamed(context, '/locations'),
//             child: Text('Select a location')),
//       ),
//     );
//   }
// }
