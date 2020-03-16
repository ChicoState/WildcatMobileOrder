import 'package:WildcatMobileOrder/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:WildcatMobileOrder/screens/menu/menu.dart';

class Landing extends StatelessWidget {
  final AuthService _auth = AuthService();

  /// Returns a Stream of Locations, used to populate the Location selection
  /// screen.
  Stream<Locations> _getLocations() {
    return Firestore.instance
        .collection('locations')
        .document('info')
        .get()
        .then((snapshot) {
      // create Location object here
      return Locations.fromSnapshot(snapshot);
    }).asStream();
  }

  Widget _showLocations(BuildContext context) {
    return StreamBuilder<Locations>(
        stream: _getLocations(),
        builder: (BuildContext context, locations) {
          if (locations.hasData) {
            Locations locList = locations.data;
            return ListView(
              padding: const EdgeInsets.only(top: 20.0),
              children: locList.locations
                  .map((loc) => _buildLocationCards(context, loc))
                  .toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _buildLocationCards(BuildContext context, LocationItem loc) {
    final MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => MenuView(location: loc.name),
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
                await _auth.signOut();
                //Added a wait for google auth sign in
                await _auth.signOutGoogle();
              },
            )
          ],
        ),
        body: Center(child: _showLocations(context)));
  }
}

/// Holds a list of all locations, and their meta data.
class Locations {
  List<LocationItem> locations;

  Locations.fromSnapshot(DocumentSnapshot snapshot)
      : locations = snapshot['meta'].map<LocationItem>((loc) {
          return LocationItem.fromMap(loc);
        }).toList();
}

/// Represents a single location
class LocationItem {
  final String openTime;
  final String closeTime;
  final String name;

  LocationItem.fromMap(Map<String, dynamic> map)
      : openTime = map['opentime'],
        closeTime = map['closetime'],
        name = map['name'];

  String getOpenHours() {
    return 'Opens at $openTime and closes at $closeTime';
  }

  String getOrderString() {
    return 'Order from $name';
  }
}
