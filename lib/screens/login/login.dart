import 'package:WildcatMobileOrder/screens/login/register.dart';
import 'package:WildcatMobileOrder/screens/login/sign_in.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  //Variable to say whether the person is signed in or not and a function to toggle the signIn var
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    //This is passing the login toggle view function as a parameter to the Register and SignIn widget. Allows for the ability to toggle between screens
    return showSignIn ? SignIn(toggleView: toggleView) : Register(toggleView: toggleView);
  }
}

//TODO: previous login code need to integrate with master in some way
// class LoginPage extends StatelessWidget {
//   final _controllerEmail = TextEditingController();
//   final _controllerPass = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Center(
//             child: Container(
//               child: TextFormField(
//               controller: _controllerEmail,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Email'
//                 ),
//               ),
//               margin: const EdgeInsets.only(bottom: 5, top: 160, left: 20, right: 20),
//               color: Colors.amber[100]
//             )
//           ),
//           Center(
//             child: Container(
//               child: TextFormField(
//               controller: _controllerPass,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Password'
//                 ),
//               ),
//               margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//               color: Colors.amber[100]
//             )
//           ),
//         ]
//       )
//     );
//   }
// }