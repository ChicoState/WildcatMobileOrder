import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../blocs/blocs.dart';
import '../screens/screens.dart';

/// Drawer to to display user information and navigation buttons
class UserDrawer extends StatelessWidget {
  Widget _defaultDrawer() => ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Login to Wildcat Mobile Order'),
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
          ),
        ],
      );

  Widget _accountDrawerHeader(BuildContext context, FirebaseUser user) =>
      UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          color: Colors.red[900],
        ),
        accountEmail: Text(
          user.email,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        accountName: Text(
          user.displayName,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(user.photoUrl),
        ),
      );

  Widget _loggedInDrawer(BuildContext context, FirebaseUser user) => Container(
      color: Colors.grey[850],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _accountDrawerHeader(context, user),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white),
              ),
            ),
            child: ListTile(
              title: Text(
                'Locations',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (context) => Landing(user.email)));
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white),
              ),
            ),
            child: ListTile(
              title: Text(
                'Sign out',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
            ),
          ),
        ],
      ));

  @override
  Widget build(BuildContext context) => Drawer(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return _loggedInDrawer(context, state.user);
            }
            return _defaultDrawer();
          },
        ),
      );
}
