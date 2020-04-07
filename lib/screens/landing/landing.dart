import 'package:WildcatMobileOrder/services/auth.dart';
import 'package:WildcatMobileOrder/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WildcatMobileOrder/screens/menu/menu.dart';
import 'package:WildcatMobileOrder/models/location.dart';
import 'package:WildcatMobileOrder/models/cart.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  final AuthService _auth = AuthService();
  Cart myCart = new Cart();

  /// Returns a Stream of Locations, used to populate the Location selection
  /// screen.
//  Stream<Locations> _getLocations() {
//    return Firestore.instance
//        .collection('locations')
//        .document('info')
//        .get()
//        .then((snapshot) {
//      // create Location object here
//      return Locations.fromSnapshot(snapshot);
//    }).asStream();
//  }

  Stream<DocumentSnapshot> _getLocations() {
    return Firestore.instance
        .collection('locations')
        .document('info')
        .snapshots();
  }

  Widget _showLocations(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: _getLocations(),
        builder: (BuildContext context, locations) {
          if (locations.hasData) {
            Locations locList = Locations.fromSnapshot(locations.data);
            return ListView(
              padding: const EdgeInsets.only(top: 20.0),
              children: locList.locations
                  .map((loc) => _buildLocationCards(context, loc))
                  .toList(),
            );
          } else {
            return Center(child: Loading());
          }
        });
  }

  Widget _buildLocationCards(BuildContext context, LocationItem loc) {
    // build the route for each card
    final MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => MenuView(
        location: loc.name,
        cart: myCart,
      ),
    );
    return Padding(
        key: ValueKey(loc.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
            child: InkWell(
                splashColor: Colors.redAccent,
                onTap: () {
                  Navigator.push(context, route);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        // icon is hard coded at the moment, look into changing this
                        leading: Icon(Icons.local_cafe),
                        title: Text(loc.name ?? 'error'),
                        subtitle: Text(loc.getOpenHours())),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: Text('Order from ${loc.name}'),
                          onPressed: () {
                            Navigator.push(context, route);
                          },
                        )
                      ],
                    )
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          title: Text('Select a location'),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                //wait for the signout to clear
                //Added a wait for google auth sign in
                await _auth.signOutGoogle();
              },
            )
          ],
        ),
        body: Center(child: _showLocations(context)));
  }
}
