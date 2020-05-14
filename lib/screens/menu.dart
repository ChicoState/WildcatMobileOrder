import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../repositories/repositories.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

/// Screen to view a particular locations menu
class MenuView extends StatelessWidget {
  /// Name of location's menu to display
  final String location;

  /// Default constructor for MenuView
  MenuView({this.location});

  /// loadMenu
  /// location is the document name under the menus collection
  Widget _loadMenu(BuildContext context, String location) =>
      BlocBuilder<MenuBloc, MenuState>(builder: (context, state) {
        if (state is MenusLoaded) {
          var currentMenu =
              state.menus.firstWhere((menu) => menu.location == location);
          return _buildCategoryList(context, currentMenu);
        }
        return CircularProgressIndicator();
      });

  Widget _buildCategoryList(BuildContext context, Menu menu) => Container(
      color: Colors.grey[800],
      child: ListView(
        //shrinkWrap: true,
        children: menu.categories
            .map((category) => ExpansionTile(
                  title: Text(
                    category,
                    style: TextStyle(color: Colors.white),
                  ),
                  children: <Widget>[
                    _buildMenuList(context, menu.getCategoryItems(category)),
                  ],
                ))
            .toList(),
      ));

  Widget _buildMenuList(BuildContext context, List<MenuItem> itemsList) =>
      ListView(
        shrinkWrap: true,
        children:
            itemsList.map((item) => _buildMenuListItem(context, item)).toList(),
      );

  Widget _buildMenuListItem(BuildContext context, MenuItem item) {
    final route = MaterialPageRoute<void>(
        builder: (context) => ItemView(item.location, item.identifier));
    // try to resolve image early
    var configuration = createLocalImageConfiguration(context);
    item.img.resolve(configuration);
    return Card(
        color: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 10,
        child: InkWell(
            onTap: () {
              Navigator.push(context, route);
            },
            child: ListTile(
                dense: false,
                isThreeLine: true,
                leading: FractionallySizedBox(
                    widthFactor: 0.2,
                    heightFactor: 1.0,
                    child: Hero(
                        tag: item.name,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: MemoryImage(kTransparentImage),
                          image: item.img,
                        ))),
                title: Row(
                  children: <Widget>[
                    Text(
                      item.name,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '\$ ${item.price.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                subtitle: Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ))));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      floatingActionButton: CartButton(),
      appBar: AppBar(
        title: Text('$location'),
        backgroundColor: Colors.red[900],
      ),
      body: _loadMenu(context, location));
}
