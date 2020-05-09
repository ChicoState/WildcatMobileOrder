import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../repositories/repositories.dart';

class LoginPage extends StatelessWidget {
  final UserRepository _userRepository;

  LoginPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  void _handleSignIn(AuthenticationBloc auth) {
    _userRepository.signInWithGoogle().then((user) {
      if (user != null) {
        auth.add(LoggedIn());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          elevation: 0.0,
          title: Center(
            child: Text(
              'Wildcat Mobile Order',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 24,
                  child: Image(
                    image: AssetImage("graphics/WildcatMO.png"),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: OutlineButton(
                    //* Outlined button for google sign in option
                    splashColor: Colors.white,
                    onPressed: () {
                      _handleSignIn(auth);
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
                              image: AssetImage(
                                  "graphics/CSUCHICO-Seal-Color.png"),
                              height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('CSU Chico Gmail',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
