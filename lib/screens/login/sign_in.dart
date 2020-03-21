import 'package:WildcatMobileOrder/services/auth.dart';
import 'package:WildcatMobileOrder/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  //Instance of authservice class
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Whether or not loading is taking place
  bool loading = false;

  //text field state
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey[800],
            appBar: AppBar(
              backgroundColor: Colors.red[900],
              elevation: 0.0,
              title: Text('Sign/Register in to Wildcat MO'),
              actions: <Widget>[
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey, //Key used for validation
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 50),
                      Image(
                        image: AssetImage("graphics/WildcatMO.png"),
                      ),
                      OutlineButton(
                        //* Outlined button for google sign in option
                        splashColor: Colors.white,
                        onPressed: () async {
                          _auth.signInWithGoogle().whenComplete(() async {
                            setState(() => loading = true);
                            dynamic result = await _auth.signInWithGoogle();
                            if (result == null) {
                              error = 'invalid Google login';
                              loading = false;
                            }
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        highlightElevation: 0,
                        borderSide: BorderSide(color: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                  image: AssetImage("graphics/google_logo.png"),
                                  height: 35.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text('Sign in with CSU Chico Gmail',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
              //! Leaving in this portion in case there are issues with the upper portion when debugging
              //? Raised button for Anonymous Sign In option
              // child: RaisedButton(
              //   child: Text('Sign in Anon'),
              //   onPressed: () async {
              //     //this will call the auth sign in function and await the result of it
              //     //Will return null if couldn't sign in else logged in
              //     dynamic result = await _auth.signInAnon();
              //     if(result == null)
              //     {
              //       print('Error signing in');
              //     }
              //     else {
              //       print('signed in');
              //       print(result.uid);
              //     }
              //   },
              // ),
              //?
            ));
  }
}
