import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../blocs/blocs.dart';
import '../repositories/repositories.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

/// Default screen after authentication, displays locations
class Landing extends StatelessWidget {
  /// Email of authenticated user
  final String user;

  /// Default constructor for Landing
  Landing(this.user);

  /// Provides an hours summary string from a Menu object
  String hoursSummary(Menu menu) =>
      'Mon-Thur: ${menu.openTime} - ${menu.closeTime}\n'
      'Friday: ${menu.openTime} - ${menu.fcloseTime}';

  Widget _showLocations(BuildContext context) =>
      BlocBuilder<MenuBloc, MenuState>(builder: (context, state) {
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

  void _navigateToLocation(BuildContext context, Menu menu) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => MenuView(location: menu.location)));
  }

  Widget _buildLocationCards(BuildContext context, Menu menu) => Padding(
      key: ValueKey(menu.location),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
          color: Colors.grey[400],
          child: InkWell(
              splashColor: Colors.redAccent,
              onTap: () {
                _navigateToLocation(context, menu);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: FractionallySizedBox(
                      widthFactor: 0.5,
                      heightFactor: 1.0,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: menu.img)),
                    ),
                    isThreeLine: true,
                    subtitle: Text(
                      hoursSummary(menu),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        color: Colors.red[900],
                        child: Text('Order from ${menu.location}'),
                        onPressed: () {
                          _navigateToLocation(context, menu);
                        },
                      )
                    ],
                  )
                ],
              ))));

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.grey[800],
      drawer: UserDrawer(),
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
