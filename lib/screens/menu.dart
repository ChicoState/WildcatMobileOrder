import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:WildcatMobileOrder/shared/cart_button.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:WildcatMobileOrder/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens.dart';



class MenuView extends StatelessWidget {
  final String location;

  MenuView({this.location});

  /// loadMenu
  /// location is the document name under the menus collection
  Widget _loadMenu(BuildContext context, String location) {
    return BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenusLoaded) {
            MenuEntity currentMenu = state.menus.firstWhere((menu) =>
            menu.location == location);
            return _buildCategoryList(context, currentMenu);
          }
          return CircularProgressIndicator();
        }
    );
  }

  Widget _buildCategoryList(BuildContext context, MenuEntity menu) {
    return ListView(
      //shrinkWrap: true,
      children: menu.categories.map((category) {
        return ExpansionTile(
          title: Text(category),
          children: <Widget>[
            _buildMenuList(context, menu.getCategoryItems(category)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMenuList(BuildContext context, List<MenuItem> itemsList) {
    return ListView(
      //itemExtent: 100,
      shrinkWrap: true,
      children: itemsList.map((item) {
        return _buildMenuListItem(context, item);
      }).toList(),
    );
  }

  Widget _buildMenuListItem(BuildContext context, MenuItem item) {
    final MaterialPageRoute route =
    MaterialPageRoute(
        builder: (context) => ItemView(item.location, item.identifier));
    // try to resolve image early
    var configuration = createLocalImageConfiguration(context);
    item.img.resolve(configuration);
    return Container(
        child: Card(
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
                        Text(item.name),
                        Spacer(),
                        //Text(item.getPrice()),
                      ],
                    ),
                    subtitle: Text(item.description)))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: CartButton(),
        appBar: AppBar(
          title: Text('$location'),
        ),
        body: _loadMenu(context, this.location));
  }
}
