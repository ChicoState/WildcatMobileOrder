import 'package:WildcatMobileOrder/screens/login/sign_in.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Variable to say whether the person is signed in or not and a function to toggle the signIn var
  bool showSignIn = true;

  @override
  Widget build(BuildContext context) {
    //This is passing the login toggle view function as a parameter to the Register and SignIn widget. Allows for the ability to toggle between screens
    return SignIn();
  }
}
