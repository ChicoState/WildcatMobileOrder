import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../blocs/blocs.dart';
import '../screens/screens.dart';

/// Drawer to provide to all scaffolds where necessary
Drawer drawer(BuildContext context) {
  Widget loggedInDrawer(FirebaseUser user) => Container(
      color: Colors.grey[850],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
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
          ),
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
                    MaterialPageRoute(
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

  Widget defaultDrawer() => ListView(
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

  return Drawer(child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
    if (state is Authenticated) {
      return loggedInDrawer(state.user);
    }
    return defaultDrawer();
  }));
}
