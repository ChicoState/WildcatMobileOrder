import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:WildcatMobileOrder/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Drawer drawer(BuildContext context) {
  Widget loggedInDrawer(FirebaseUser user) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountEmail: Text(user.email),
          accountName: Text(user.displayName),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
          ),
        ),
        ListTile(
          title: Text('Locations'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Landing()));
          },
        ),
        ListTile(
          title: Text('Log out'),
          onTap: () {
            Navigator.pop(context);
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
          },
        ),
      ],
    );
  }

  Widget defaultDrawer() {
    return ListView(
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
  }

  return Drawer(child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
    if (state is Authenticated) {
      return loggedInDrawer(state.user);
    }
    return defaultDrawer();
  }));
}
