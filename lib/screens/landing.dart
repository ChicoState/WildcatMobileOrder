import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:WildcatMobileOrder/shared/drawer.dart';
import 'package:WildcatMobileOrder/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:WildcatMobileOrder/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:WildcatMobileOrder/blocs/blocs.dart';

class Landing extends StatelessWidget {
  Widget _showLocations(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(builder: (context, state) {
      if (state is MenusLoading) {
        return CircularProgressIndicator();
      } else if (state is MenusLoaded) {
        return ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children: state.menus
              .map((menu) => _buildLocationCards(context, menu))
              .toList(),
        );
      } else {
        return Center(child: Loading());
      }
    });
  }

  Widget _buildLocationCards(BuildContext context, MenuEntity menuEntity) {
    // build the route for each card
    final MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => MenuView(
        location: menuEntity.location,
      ),
    );
    return Padding(
        key: ValueKey(menuEntity.location),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
            color: Colors.grey[400],
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
                      // leading: Icon(Icons.local_cafe),
                      leading: new FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: AssetImage("graphics/creekside.jpg"),
                      ),
                      title: Text(
                        menuEntity.location ?? 'error',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                        'Mon-Thur: ${menuEntity.openTime} - ${menuEntity.closeTime}\n'
                        'Friday: ${menuEntity.openTime} - ${menuEntity.fcloseTime}',
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          color: Colors.red[900],
                          child: Text('Order from ${menuEntity.location}'),
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
        drawer: drawer(context),
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Text('Select a location'),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
              },
            )
          ],
        ),
        body: Center(child: _showLocations(context)));
  }
}

//class Landing extends StatefulWidget {
//  @override
//  _LandingState createState() => _LandingState();
//}
//
//class _LandingState extends State<Landing> {
//
//  /// Returns a Stream of Locations, used to populate the Location selection
//  /// screen.
//  Stream<DocumentSnapshot> _getLocations() {
//    return Firestore.instance
//        .collection('locations')
//        .document('info')
//        .snapshots();
//  }
//
//  Widget _showLocations(BuildContext context) {
//    return BlocBuilder<MenuBloc, MenuState>(
//      builder: (context, state) {
//        if (state is MenusLoading) {
//          return CircularProgressIndicator();
//        } else if (state is MenusLoaded) {
//          return ListView(
//            padding: const EdgeInsets.only(top: 20.0),
//            children: state.menus.map((menu) => _buildLocationCards(context, menu)).toList(),
//          );
//        }
//        else {
//          return Center(child: Loading());
//        }
//      }
//    );
//  }
//
//  Widget _buildLocationCards(BuildContext context, MenuEntity menuEntity) {
//    // build the route for each card
//    final MaterialPageRoute route = MaterialPageRoute(
//      builder: (context) => MenuView(
//        location: menuEntity.location,
//      ),
//    );
//    return Padding(
//        key: ValueKey(menuEntity.location),
//        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//        child: Card(
//            child: InkWell(
//                splashColor: Colors.redAccent,
//                onTap: () {
//                  Navigator.push(context, route);
//                },
//                child: Column(
//                  mainAxisSize: MainAxisSize.min,
//                  children: <Widget>[
//                    ListTile(
//                        // icon is hard coded at the moment, look into changing this
//                        leading: Icon(Icons.local_cafe),
//                        title: Text(menuEntity.location ?? 'error'),
//                        subtitle: Text('Opens at ${menuEntity.openTime} and closes at ${menuEntity.closeTime}'),
//                    ),
//                    ButtonBar(
//                      children: <Widget>[
//                        FlatButton(
//                          child: Text('Order from ${menuEntity.location}'),
//                          onPressed: () {
//                            Navigator.push(context, route);
//                          },
//                        )
//                      ],
//                    )
//                  ],
//                ))));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        backgroundColor: Colors.grey[800],
//        appBar: AppBar(
//          title: Text('Select a location'),
//          elevation: 0.0,
//          actions: <Widget>[
//            FlatButton.icon(
//              icon: Icon(Icons.person),
//              label: Text('logout'),
//              onPressed: () async {
//                BlocProvider.of<AuthenticationBloc>(context).add(
//                  LoggedOut()
//                );
//              },
//            )
//          ],
//        ),
//        body: Center(child: _showLocations(context)));
//  }
//}
