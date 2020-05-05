import 'package:WildcatMobileOrder/repositories/menu_repository/menu_entity.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:WildcatMobileOrder/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:WildcatMobileOrder/widgets/widgets.dart';

class ItemView extends StatelessWidget {
  final String location;
  final String id;

  ItemView(this.location, this.id);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(builder: (context, state) {
      if (state is MenusLoaded) {
        MenuItem item = state.menus
            .firstWhere((m) => m.location == location)
            .getItemById(id);
        return Scaffold(
            floatingActionButton: CartButton(),
            backgroundColor: Colors.grey[800],
            appBar: AppBar(
              title: Text(item.name),
              backgroundColor: Colors.red[900],
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Hero(
                        tag: item.name,
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          placeholder: MemoryImage(kTransparentImage),
                          image: item.img,
                        ),
                      )),
                ),
                // add spacing below image
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: item.description,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                    flex: 3,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Ink(
                                  decoration: const ShapeDecoration(
                                    color: Colors.black,
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    color: Colors.white,
                                    splashColor: Colors.redAccent,
                                    icon: Icon(Icons.add_shopping_cart),
                                    onPressed: () {
                                      print('add ${item.identifier} to cart');
                                      BlocProvider.of<CartBloc>(context).add(
                                          CartUpdated(
                                              cart: (BlocProvider.of<CartBloc>(
                                                          context)
                                                      .state as CartLoaded)
                                                  .cart
                                                  .addItem(item)));
                                    },
                                  ))),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              '\n\$${item.price.toStringAsFixed(2)}',
                              style:
                                  TextStyle(fontSize: 23, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ));
      }
      return Loading();
    });
  }
}
