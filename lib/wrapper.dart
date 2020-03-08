import 'package:WildcatMobileOrder/screens/landing/landing.dart';
import 'package:WildcatMobileOrder/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Accessing the user data everytime we get it will be null on logout
    final user = Provider.of<User>(context);

    //return either the langing page or login page based on Auth
    return user != null ? Landing() : Login();
  }
}
