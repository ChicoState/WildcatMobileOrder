import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../blocs/blocs.dart';
import '../repositories/repositories.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class Landing extends StatelessWidget {
  final String user;

  Landing(this.user);

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

  Widget _buildLocationCards(BuildContext context, MenuEntity menuEntity) {
    // build the route for each card
    final route = MaterialPageRoute(
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
                      leading: FractionallySizedBox(
                        widthFactor: 0.5,
                        heightFactor: 1.0,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: FadeInImage(
                                placeholder: MemoryImage(kTransparentImage),
                                image: menuEntity.img)),
                      ),
                      isThreeLine: true,
                      subtitle: Text(
                        'Mon-Thur: ${menuEntity.openTime} - ${menuEntity.closeTime}\n'
                        'Friday: ${menuEntity.openTime} - ${menuEntity.fcloseTime}',
                        style: TextStyle(color: Colors.black),
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
  Widget build(BuildContext context) => Scaffold(
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
